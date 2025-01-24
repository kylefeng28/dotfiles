#!/bin/bash

# Helper script to test out dotfiles

set -euo pipefail

ROOT=$(realpath $(dirname -- "$0"))

while getopts "c:" opt; do
  case "$opt" in
    c)  config_home=$OPTARG
      ;;
  esac
done
shift $((OPTIND-1))

if [[ $# -eq 0 ]] ; then
    echo "usage: $0 [-c config-home-dir] <command>"
    exit 1
fi

config_home="${config_home:-$ROOT/.config}"
cmd=$@; shift

set_xdg_env() {
	echo "Setting XDG_CONFIG_HOME to $config_home"
	export XDG_CONFIG_HOME="$config_home"
}

case $cmd in
	bash)
		set -x
		bash --rcfile $1
		;;
	zsh)
		set -x
		export ZDOTDIR=$(mktemp -d)
		echo "source $1" > $ZDOTDIR/.zshrc
		zsh
		;;
	nvim|fish|*)
		set_xdg_env
		$cmd
		;;
esac

