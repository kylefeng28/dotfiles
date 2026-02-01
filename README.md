# dotfiles

See the `minimal` directory for minimal dotfiles (< 100 lines) that can easily be copied to a remote host.

## Useful tools:
On Mac, install [Homebrew](https://brew.sh/):

```
$ /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Run `brew bundle` which will install the packages listed in `Brewfile`

- [ag (the_silver_searcher)](https://github.com/ggreer/the_silver_searcher) - fast file search; like `grep` and `ack` but faster
- [jq](https://jqlang.github.io/jq/) - JSON processor tool (useful for processing JSON in Bash scripts)
- [fzf](https://github.com/junegunn/fzf) - command-line fuzzy finder
- [asdf](https://asdf-vm.com/) - runtime version manager for various languages (ruby, node, scala, etc)
- 
**Windows tools**:
- [PowerToys](https://learn.microsoft.com/en-us/windows/powertoys/)
- [Windows Terminal](https://aka.ms/terminal)

**macOS tools**:
- [iTerm2](https://iterm2.com/) - much better than the stock Terminal.app; supports Tmux integration
- [Karabiner-Elements](https://karabiner-elements.pqrs.org/)
  - See `mac/karabiner` directory for setting up a compose key on macOS

## vim / [neovim](https://neovim.io/)
Neovim is a modern vim replacement. See the `.config/nvim` directory for my neovim config.
Plugins are handled by [lazy.nvim](https://lazy.folke.io/) which should be install and update itself automatically.

Bring up the Lazy UI using `:Lazy` or `<Space>I`.

If you want to start your own neovim config, I would recommend starting off with some minimal templates like
 and adding onto to it incrementally:
- [nvim-lua/kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) - lua-based, neovim-only config that uses lazy.nvim
- [theopn/kickstart.vim](https://github.com/theopn/kickstart.vim) - vimscript version of kickstart.nvim that uses Plug
- [rstacruz/vim-from-scratch](https://github.com/rstacruz/vim-from-scratch) for regular Vim (repo is deprecated but still useful to see for how VimScript works)

## Linux Desktop 🚀
Wayland for the win

- [kitty](https://github.com/kovidgoyal/kitty) - terminal
- [hyprland](https://hypr.land/) - Wayland compositor with dynamic tiling
- [niri](https://github.com/YaLTeR/niri) - Wayland compositor with scrollable tiling
- [quickshell](https://quickshell.org/) - composable and reusable desktop widgets (status bars, menus, notifications, etc)

Quickshell configs:
- [Dank Linux (dms)](https://danklinux.com/docs/getting-started) - full-fledged suite of quickshell widgets and desktop customizations for niri and hyprland. maximum dank
- [caelestia shell](https://github.com/caelestia-dots/shell) - another great suite of quickshell widgets for hyprland


There are also a lot of distros like [LazyVim](https://www.lazyvim.org/), [LunarVim](https://www.lunarvim.org/), [NvChad](https://nvchad.com/) that come with a much more IDE-like setup out of the box; these are useful for inspiration for plugins but I would not recommend starting off with these.

## Inspiration:
- https://andrew.cloud/dev-setup/
- https://github.com/minimal/dotfiles
- https://www.hamvocke.com/blog/a-guide-to-customizing-your-tmux-conf/
