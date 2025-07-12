# Stowed

_GNU/Stow-managed dotfiles for *nix systems_

* Package names are those in Arch Linux and AUR by default

## Installation

- base: `stow`
- cli: `bash-completion neovim-git lf htop `
- cli/Neovim: `lua-language-server stylua`
- gui/Sway: `sway waybar dunst wofi network-manager-applet blueman`
- gui/apps: `ghostty zathura`

## Additional

### Bluetooth

`bluez bluez-utils`

`sudo systemctl enable bluetooth.service`

For the GUI and applet.

`blueman`

### Gaming

This is an extra session as a tutorial for Linux gaming, basically for myself so that I don't need to Google next time.

I do not have a very specific reason for using Proton GE, it was just base it magically solved my problem of this error:

`wine: failed to open "c:\\windows\\system32\\steam.exe": c0000135`

even though I was not actually running games in an NTFS drive, yet most of the threads talking about this error, they are. So I just gave up Proton downloaded by Steam and use Proton GE.

`steam proton-ge-custom-bin`

For Xbox controllers e.g. Xbox Series X/S Controller, [xpadneo](https://github.com/atar-axis/xpadneo) is necessary to make them function. Without it, they can only be used plugging in, and (at least) Forza Horizon 4 cannot read controller input.

`xpadneo-dkms linux-header`
