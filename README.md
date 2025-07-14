# Stowed

_GNU/Stow-managed dotfiles for *nix systems_

[TODO](./TODO.md)

*Package names are those in Arch Linux and AUR by default

## Installation

```bash
git clone git@github.com:vollowx/Stowed.git ~/Stowed
cd ~/Stowed
stow cli
stow gui
```

Basic ones:

`stow bash-completion unzip unrar 7zip`

The ones run in command line

`lf htop neovim-git`
`lua-language-server stylua shfmt prettier`

The ones run in GUI

`sway swaybg swayidle swaylock-effects`
`waybar dunst wofi network-manager-applet blueman`
`xdg-desktop-portal-wlr xdg-desktop-portal-gtk polkit-gnome`
`ghostty zathura`

## Addition

### Other Apps

The packages below are neither configured by nor related to this set of
dotfiles.

`fcitx5 firefox nemo file-roller mission-center krita`

### Audio

`pipewire pipewire-alsa pipewire-jack pipewire-pulse`

This also installs `pipewire-audio pipewire-session-manager wireplumber`

### Bluetooth

`bluez bluez-utils`

`sudo systemctl enable bluetooth.service`

`blueman` is for the GUI configurator and applet, used in Waybar.

### Gaming

`steam proton-ge-custom-bin`

`usermod -a -G games`

Proton GE is used just because it magically solves this error:

`wine: failed to open "c:\\windows\\system32\\steam.exe": c0000135`

which happens everytime I launch a game in Steam, even though I was not actually
running games in an NTFS drive, yet most of the threads talking about this
error, they are.

Set Steam > Settings > Compatibility > Default compatibility tool to Proton-GE.

`xpadneo-dkms linux-header`

For Xbox controllers e.g. Xbox Series X/S Controller,
[xpadneo](https://github.com/atar-axis/xpadneo) is necessary to make them
function. Without it, they can only be used plugging in, and (at least) Forza
Horizon 4 cannot read controller input.
<del>Stay sway from me cables :)</del>
