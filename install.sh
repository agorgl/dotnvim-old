#!/bin/bash
set -e

NVIM_CONF=${XDG_CONFIG_HOME:-$HOME/.config}/nvim
NVIM_DOTS=$(dirname "$(readlink -f "$0")")

if [ -e "$NVIM_CONF" ]; then
  echo "error: target $NVIM_CONF already exists"
  exit 1
fi

ln -r -s "$NVIM_DOTS" "$NVIM_CONF"
