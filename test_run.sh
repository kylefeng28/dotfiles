#!/bin/bash

# Helper script to test out dotfiles

set -euo pipefail

ROOT=$(realpath $(dirname -- "$0"))

set_xdg_env() {
	set -x
	export XDG_CONFIG_HOME="$ROOT/.config"
	set +x
}

cmd=$1; shift

case $cmd in
	nvim)
		set_xdg_env
		nvim
		;;
	bash)
		set -x
		exec bash --rcfile $1
		;;
	zsh)
		set -x
		export ZDOTDIR=$(mktemp -d)
		echo "source $1" > $ZDOTDIR/.zshrc
		zsh
		;;
	fish)
		set -x
		set_xdg_env
		fish
		;;
esac

