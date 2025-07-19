#!/usr/bin/env bash

INFO_INDICATOR='\033[0;34m::\033[0m '
WARN_INDICATOR='\033[0;33mwarning:\033[0m '
ERROR_INDICATOR='\033[0;31merror:\033[0m '

config="$HOME/.config/gtk-3.0/settings.ini"
gset="gsettings set org.gnome.desktop.interface"

try() {
  local key
  local value="$2"

  case "$1" in
  gtk-application-prefer-dark-theme)
    key="color-scheme"
    value="$([[ "$2" == "1" || "$2" == "true" ]] && echo "prefer-dark" || echo "prefer-light")"
    ;;
  gtk-font-name)
    key="font-name"
    ;;
  gtk-theme-name)
    key="gtk-theme"
    ;;
  gtk-icon-theme-name)
    key="icon-theme"
    ;;
  gtk-cursor-theme-name)
    key="cursor-theme"
    ;;
  gtk-cursor-theme-size)
    key="cursor-size"
    ;;
  *)
    echo -e "${WARN_INDICATOR}unsupported key read: $1"
    return
    ;;
  esac

  if $gset "$key" "$value" &>/dev/null; then
    echo -e " $key: $value"
  else
    echo -e "${ERROR_INDICATOR}failed to set $key: $value"
  fi
}

if [[ ! -f "$config" ]]; then
  echo -e "${ERROR_INDICATOR}configuration file ($config) not found"
  exit 1
fi

echo -e "${INFO_INDICATOR}Resolving GTK 3.0 configuration..."
while IFS='=' read -r key value; do
  [[ "$key" == "[Settings]" ]] && continue
  key=$(echo "$key" | xargs)
  value=$(echo "$value" | xargs)
  try "$key" "$value"
done < <(grep -v '^#' "$config")
