#!/usr/bin/env sh

stow -vRt ~ home-cli
stow -vRt ~ home-gui

read -p "Do you want to copy dotfiles at root directory? (y/N): " choice
choice=${choice:-N}

case $choice in
[Yy]*) ;;
[Nn]*)
  exit
  ;;
*)
  exit
  ;;
esac

sudo cp -r root /
