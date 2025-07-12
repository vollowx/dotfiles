# Stowed

_GNU/Stow-managed dotfiles for *nix systems_

* Package names are those in Arch Linux and AUR by default

## Installation

`stow bash-completion unzip unrar 7zip`

`lf htop neovim-git`
`lua-language-server stylua`

`sway waybar dunst wofi network-manager-applet blueman`
`ghostty zathura`

`fcitx5 firefox nemo file-roller mission-center krita`

## Additional

### Bluetooth

`bluez bluez-utils`

`sudo systemctl enable bluetooth.service`

`blueman` is for the GUI configurator and applet.

### Gaming

`steam proton-ge-custom-bin`

I do not have a very specific reason for using Proton GE, it was just base it magically solved my problem of this error:

`wine: failed to open "c:\\windows\\system32\\steam.exe": c0000135`

even though I was not actually running games in an NTFS drive, yet most of the threads talking about this error, they are. So I just gave up Proton downloaded by Steam and use Proton GE.

`xpadneo-dkms linux-header`

For Xbox controllers e.g. Xbox Series X/S Controller, [xpadneo](https://github.com/atar-axis/xpadneo) is necessary to make them function. Without it, they can only be used plugging in, and (at least) Forza Horizon 4 cannot read controller input.
<del>stay sway from me cables</del>
