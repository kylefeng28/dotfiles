#!/usr/bin/env python3
"""Dotfiles manager.

Config (.dotfiles-config, TOML) is split into modules. Each module can have
symlinks ([<module>.links]) and setup scripts (scripts = [...], which run
scripts in the ./setup dir). See the header of .dotfiles-config for the format.

  dotfiles.py list                       list modules
  dotfiles.py link  [module ...]         create symlinks (default: all modules)
  dotfiles.py setup [module ...]         symlinks + setup scripts (default: all)
  dotfiles.py import <path> [repo-path] [-m module]
                                         move a file into the repo and symlink it
"""
import argparse
import os
import platform
import shutil
import subprocess
import sys
from pathlib import Path

import tomllib

# DOTFILES = Path.home() / "dotfiles"
DOTFILES = Path(__file__).resolve().parent
HOME = Path.home()
CONFIG = DOTFILES / ".dotfiles-config"
SETUP_DIR = DOTFILES / "setup"
HOSTNAME = os.getenv('HOSTNAME') or platform.node()
SYSTEM = platform.system().lower()  # 'linux', 'darwin', ...

KNOWN_MODULE_KEYS = {"links", "scripts", "platforms"}


# -- config --------------------------------------------------------------------
def load_config(config_file=CONFIG):
    """Load the TOML config"""
    config_path = Path(config_file)

    if not config_path.exists():
        print("No config file found!")
        sys.exit(1)

    try:
        with open(config_path, 'rb') as f:
            config = tomllib.load(f)
    except Exception as e:
        print(f"Error parsing config: {e}")
        sys.exit(1)

    for name, module in config.items():
        if not isinstance(module, dict):
            print(f"Error: '{name}' in {config_path.name} must be a [module] table")
            sys.exit(1)
        unknown = set(module) - KNOWN_MODULE_KEYS
        if unknown:
            print(f"Warning: module '{name}' has unknown keys: {', '.join(sorted(unknown))}")
    return config


def get_links(module):
    """Return {repo_path: target_path} for a module, with $HOST substituted"""
    return {
        repo_path.replace('$HOST', HOSTNAME): target.replace('$HOST', HOSTNAME)
        for repo_path, target in module.get("links", {}).items()
    }


def select_modules(config, names):
    """Resolve CLI module names (empty = all) to [(name, table)], exiting on unknown names"""
    if not names:
        names = list(config)
    unknown = [n for n in names if n not in config]
    if unknown:
        print(f"Error: unknown module(s): {', '.join(unknown)}")
        print(f"Available: {', '.join(config)}")
        sys.exit(1)
    return [(n, config[n]) for n in names]


def supported_here(name, module):
    platforms = module.get("platforms")
    if platforms and SYSTEM not in platforms:
        print(f"Skip module '{name}': only for {', '.join(platforms)} (this is {SYSTEM})")
        return False
    return True


def add_to_config(config_file, module, repo_rel: Path, target: Path):
    """Append a link under [<module>.links], creating the table if needed"""
    entry = f"'{repo_rel}' = '~/{target.relative_to(HOME)}'"
    header = f"[{module}.links]"
    lines = Path(config_file).read_text().splitlines()

    if header in (line.strip() for line in lines):
        idx = next(i for i, line in enumerate(lines) if line.strip() == header)
        end = idx + 1
        while end < len(lines) and not lines[end].lstrip().startswith('['):
            end += 1
        # insert after the last non-blank line of the table
        while end > idx + 1 and not lines[end - 1].strip():
            end -= 1
        lines.insert(end, entry)
    else:
        lines += ["", header, entry]

    Path(config_file).write_text("\n".join(lines) + "\n")
    print(f"Added to [{module}.links]: {entry}")


def run_setup_script(name):
    """Run setup/<name>"""
    script = SETUP_DIR / name

    if not script.is_file():
        print(f"Error: no setup script '{name}' in {SETUP_DIR}")
        sys.exit(1)

    print(f"Running script: {script}")
    result = subprocess.run(["bash", str(script)])
    if result.returncode != 0:
        print(f"Error: {script.name} exited with {result.returncode}")
        sys.exit(result.returncode)


# -- import --------------------------------------------------------------------
def import_file(target: Path, repo_path: Path, module=None):
    """Move a file (target, usually from ~) into dotfiles repo and create symlink"""
    # This essential just replicates these 2 shell commands, but with more error handling:
    #   mv $target $repo_path
    #   ln -s $repo_path $target

    if not target.exists():
        print(f"Error: {target} does not exist")
        sys.exit(1)

    if target.is_symlink():
        print(f"Error: {target} is already a symbolic link")
        sys.exit(1)

    if not target.is_relative_to(HOME):
        print(f"Error: {target} is not in {HOME}")
        sys.exit(1)

    # repo_path might already be an absolute path pointing to ~/dotfiles/a/b
    if repo_path.is_absolute():
        if not repo_path.is_relative_to(DOTFILES):
            print(f'Error: {repo_path} is not in {DOTFILES}')
            sys.exit(1)
        repo_file = repo_path
    else:
        repo_file = DOTFILES / repo_path
    repo_rel = repo_file.relative_to(DOTFILES)

    config = load_config()
    if module is None:
        first = repo_rel.parts[0]
        if first in config:
            module = first
        else:
            module = input(f"Module for {repo_rel} [default: {first}]: ").strip() or first

    print(f"Attempting to move {target} -> {repo_file}")

    if repo_file.exists():
        print(f"Error: {repo_file} already exists")

        # Case 1: ok: move dir a/b to repo dir a/b (a exists, a/b does not)
        # Case 2: bad: move file a/b to existing parent dir a
        # Case 3: bad: move dir a/b to repo dir a/b, but a/b already exists
        # Case 4.1: bad: move file a/b to repo dir a/b, but a/b already exists
        # Case 4.2: bad: move file a/b to repo file a/b, but a/b already exists
        if repo_file.is_dir():
            print(f"If you wanted to move {target} inside of {repo_file.parent}, please remove {repo_file} and try again")
        sys.exit(1)

    # Move file
    repo_file.parent.mkdir(parents=True, exist_ok=True)
    shutil.move(str(target), str(repo_file))
    print(f"Moved {target} -> {repo_file}")

    # Create symlink
    target.symlink_to(repo_file)
    print(f"Created symlink {target} -> {repo_file}")

    # Add to config
    add_to_config(CONFIG, module, repo_rel, target)


# -- link ----------------------------------------------------------------------
# TODO features:
# setup a single symlink (via command line arg)
# interactive handling if file already exists / has symlink conflict
def link_module(name, module):
    """Create symlinks for one module"""
    links = get_links(module)
    if not links:
        return

    print(f"[{name}] linking")
    for repo_path, target_path in links.items():
        repo_file = DOTFILES / repo_path
        target = HOME / target_path.removeprefix('~/')

        if not repo_file.exists():
            print(f"Skip: {repo_file} not found")
            continue

        # TODO: backup with timestamp
        def create_backup():
            backup = target.with_suffix(target.suffix + '.backup')
            shutil.move(str(target), str(backup))
            print(f"Backed up {target} -> {backup}")

        # Create symlink
        def create_symlink():
            target.parent.mkdir(parents=True, exist_ok=True)
            target.symlink_to(repo_file)

        status = None

        # Target does not exist => create symlink
        if not target.exists() and not target.is_symlink():
            create_symlink()
            status = 'created symlink'
        # Target already exists => backup existing file/dir first
        elif not target.is_symlink():
            create_backup()
            create_symlink()
            status = 'created symlink, backed up previous file'
        # Symlink already exists
        elif target.resolve() == repo_file.resolve():
            status = 'symlink already exists, skipping'
        else:
            print(f"Symlink conflict: {target} points to {target.resolve()}")
            # TODO: choice between unlinking or creating backup
            create_backup()
            create_symlink()
            status = 'replaced symlink'

        print(f"✓ {target} -> {repo_file} ({status})")


# -- CLI -----------------------------------------------------------------------
def cmd_list(args):
    """List modules"""
    config = load_config()
    for name, module in config.items():
        extra = f" [{', '.join(module['platforms'])} only]" if module.get("platforms") else ""
        scripts = ", ".join(module.get("scripts", [])) or "-"
        print(f"{name}{extra}: {len(get_links(module))} link(s), scripts: {scripts}")


def cmd_link(args):
    """Create symlinks"""
    for name, module in select_modules(load_config(), args.modules):
        if supported_here(name, module):
            link_module(name, module)


def cmd_setup(args):
    """Create symlinks and run each module's setup scripts"""
    for name, module in select_modules(load_config(), args.modules):
        if not supported_here(name, module):
            continue
        link_module(name, module)
        for script in module.get("scripts", []):
            print(f"[{name}] script: {script}")
            run_setup_script(script)


def cmd_import(args):
    """Move a file into the repo and symlink it"""
    target = Path(os.path.abspath(os.path.expanduser(args.path)))
    if args.repo_path:
        repo_path = Path(os.path.expanduser(args.repo_path))
    elif target.is_relative_to(HOME):
        # Prompt for repo location
        default_repo_path = str(target.relative_to(HOME))
        repo_path = Path(input(f"Repo path in {DOTFILES} [default: {default_repo_path}]: ").strip()
                         or default_repo_path)
    else:
        print(f"Error: {target} is not in {HOME}")
        sys.exit(1)
    import_file(target, repo_path, args.module)


def main():
    parser = argparse.ArgumentParser(description=__doc__.split("\n\n")[0])
    sub = parser.add_subparsers(dest="command", required=True)

    sub.add_parser("list", help=cmd_list.__doc__).set_defaults(func=cmd_list)

    p = sub.add_parser("link", help=cmd_link.__doc__)
    p.add_argument("modules", nargs="*", help="modules (default: all)")
    p.set_defaults(func=cmd_link)

    p = sub.add_parser("setup", help=cmd_setup.__doc__)
    p.add_argument("modules", nargs="*", help="modules (default: all)")
    p.set_defaults(func=cmd_setup)

    p = sub.add_parser("import", help=cmd_import.__doc__)
    p.add_argument("path")
    p.add_argument("repo_path", nargs="?")
    p.add_argument("-m", "--module", help="module to add the link to (default: inferred from repo path)")
    p.set_defaults(func=cmd_import)

    args = parser.parse_args()
    args.func(args)


if __name__ == "__main__":
    main()

# Test cases:
# target arg only: python3 dotfiles.py import ~/.asdf
#   should prompt repo_path, with default = .asdf
# good absolute path: python3 dotfiles.py import ~/.asdf ~/dotfiles/.asdf
# bad absolute path: python3 dotfiles.py import ~/.asdf /tmp
