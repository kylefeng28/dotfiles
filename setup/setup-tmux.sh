#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/setup-prelude.sh"

# tpm
echo 'Downloading tpm...'
if [ -d ~/.tmux/plugins/tpm ]; then
  echo 'tpm already installed, skipping clone.'
else
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi
echo 'Done.'

# Caveats
echo
echo 'Caveats:'
echo 'Make sure to symlink or create `~/.tmux.conf.local` before running tmux.'
echo 'Run tmux and press `prefix+I` to install tpm.'
