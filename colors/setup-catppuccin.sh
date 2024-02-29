#!/bin/bash

# Catppuccin: Soothing pastel theme for the high-spirited!
# https://github.com/catppuccin/catppuccin

set -euo pipefail

mkdir -p iterm

for flavor in frappe latte macchiato mocha; do
	curl -O --output-dir iterm "https://raw.githubusercontent.com/catppuccin/iterm/main/colors/catppuccin-${flavor}.itermcolors"
done

echo "Done downloading."
echo
echo "Make sure to import color presets in iTerm:"
echo "Cmd+I > Navigate to the Colors tab > Click on Color Presets > Click on Import"
