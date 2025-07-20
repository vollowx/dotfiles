#!/usr/bin/env bash

INFO_INDICATOR='\033[0;34m::\033[0m '
ERROR_INDICATOR='\033[0;31merror:\033[0m '

TMP_DIR="$(mktemp -d /tmp/firefox-gnome-theme-XXXXXXXXXX)"
REPO_URL="https://github.com/rafaelmardojai/firefox-gnome-theme.git"

echo -e "${INFO_INDICATOR}Downloading the theme repository..."
git clone "$REPO_URL" "$TMP_DIR"
if [ $? -ne 0 ]; then
  echo -e "${ERROR_INDICATOR}failed to clone the repository"
  exit 1
fi

cd "$TMP_DIR"

echo -e "${INFO_INDICATOR}Running auto-install script..."
./scripts/auto-install.sh
