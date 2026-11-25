#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/setup-prelude.sh"

# fisher
echo 'Downloading fisher...'
curl -Lo ~/.config/fish/functions/fisher.fish --create-dirs https://git.io/fisher
echo 'Done.'

echo 'Updating fisher packages...'
fish -c 'fisher update'
echo 'Done.'
