#!/usr/bin/env python3
import os
import sys
import shutil
from pathlib import Path
import platform
import tomllib

DOTFILES = Path.home() / "dotfiles"
HOME = Path.home()
CONFIG = DOTFILES / ".dotfiles-config"
HOSTNAME = os.getenv('HOSTNAME') or platform.node()

def load_config(config_file):
    """Load TOML config file"""
    config_path = Path(config_file)

    if not config_path.exists():
        print(f"No config file found!")
        sys.exit(1)

    try:
        with open(config_path, 'rb') as f:
            return tomllib.load(f)
    except Exception as e:
        print(f"Error parsing config: {e}")
        sys.exit(1)

def get_mappings(config):
    """Extract mappings from config"""
    mappings = {}

    for repo_path, target in config.items():
        repo_path = repo_path.replace('$HOST', HOSTNAME)
        target = target.replace('$HOST', HOSTNAME)
        mappings[repo_path] = target

    return mappings

def add_to_config(config_file, repo_path: Path, target: Path):
    with config_file.open('a') as f:
        target_path_relative_to_home = target.relative_to(HOME)
        print(target_path_relative_to_home)
        f.write(f'"{repo_path}" = "{target_path_relative_to_home}"\n')
    print(f"Added mapping to config")

def import_file(target: Path, repo_path: Path):
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

    # repo_path might already be an absolute path pointing to ~/dotfiles/a/b
    if repo_path.is_absolute():
        if repo_path.is_relative_to(DOTFILES):
            repo_file = Path(repo_path).relative_to(DOTFILES)
        else:
            print(f'Error: {repo_path} is not in {DOTFILES}')
            sys.exit(1)
    else:
        repo_file = DOTFILES / repo_path

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
    add_to_config(CONFIG, repo_path, target)

# TODO features:
# setup a single symlink (via command line arg)
# setup from custom file
# interactive handling if file already exists / has symlink conflict
def setup():
    """Setup symlinks on a new system"""
    config = load_config(CONFIG)
    if not config:
        print("No config found")
        return

    mappings = get_mappings(config)
    if not mappings:
        print("No mappings to process")
        return
    
    for repo_path, target_path in mappings.items():
        repo_file = DOTFILES / repo_path
        target = HOME / target_path.lstrip('~/')
       
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

        # Target exists => create symlink
        if not target.exists():
            create_symlink()
            status = 'created symlink'
        # Target already exists => backup existing file first
        elif not target.is_symlink():
            create_backup()
            create_symlink()
            status = 'created symlink, backed up previous file'
        # Symlink already exists
        elif target.is_symlink():
            if target.resolve() == repo_file.resolve():
                status = 'symlink already exists, skipping'
            else:
                print(f"Symlink conflict: {target} points to {target.resolve()}")
                # TODO: choice between unlinking or creating backup
                # target.unlink()
                create_backup()
                create_symlink()
                status = 'replaced symlink'

        print(f"✓ {target} -> {repo_file} ({status})")

def main():
    if len(sys.argv) < 2:
        print("Usage:")
        print("  dotfiles.py import <path>   - Import file into repo")
        print("  dotfiles.py setup           - Setup symlinks")
        sys.exit(1)
    
    cmd = sys.argv[1]
    if cmd == "import":
        if len(sys.argv) < 3:
            print("Usage: dotfiles.py import <path> [repo-path]")
            sys.exit(1)
        if len(sys.argv) == 3:
            # Prompt for repo location
            target = Path(sys.argv[2])
            default_repo_path = str(target.relative_to(HOME))
            repo_path = input(f"Repo path in {DOTFILES} [default: {default_repo_path}]: ").strip() or default_repo_path
            import_file(target, Path(repo_path))
        if len(sys.argv) == 4:
            import_file(Path(sys.argv[2]), Path(sys.argv[3]))
    elif cmd == "setup":
        setup()
    else:
        print(f"Unknown command: {cmd}")

if __name__ == "__main__":
    main()

# Test cases:
# target arg only: python3 dotfiles.py import ~/.asdf
#   should prompt repo_path, with default = .asdf
# good absolute path: python3 dotfiles.py import ~/.asdf ~/dotfiles/.asdf
# bad absolute path: python3 dotfiles.py import ~/.asdf /tmp
