# dotfiles

_Stow-managed dotfiles for *nix systems_

[TODO](./TODO.md)

*Package names are those in Arch Linux and AUR by default

## Installation

    git clone git@github.com:vollowx/dotfiles.git && cd ~/dotfiles
    ./scripts/install-desktop.sh

Basic ones:

`stow bash-completion pkgfile unzip unrar 7zip go`

    go install go.senan.xyz/untree@latest
    sudo pkgfile --update

The ones run in command line

`htop fd ripgrep newsboat neomutt`

`mpd mpc ncmpcpp mpd-discord-rpc`

`lf bat catimg chafa ffmpegthumbnailer transmission-cli`

`neovim lua-language-server stylua shfmt prettier`

The ones run in GUI

`sway swaybg swayidle swaylock sway-contrib`

`waybar dunst wofi network-manager-applet blueman`

`xdg-desktop-portal-wlr xdg-desktop-portal-gtk polkit-gnome`

`ghostty zathura`

## Addition

### Other Apps

`fcitx5 fcitx5-rime rime-ice rime-pinyin-moegirl gimp`

### Audio

`pipewire pipewire-alsa pipewire-jack pipewire-pulse`

This also installs `pipewire-audio pipewire-session-manager wireplumber`, and
the `systemd`-based auto-start is already managed in
`@/stow-gui/.config/systemd`.

### Bluetooth

`bluez bluez-utils`

    sudo systemctl enable bluetooth.service

`blueman` is for the GUI manager and applet, the applet is used in Waybar.

### Local Network Sharing

`samba`

    sudo systemctl enable --now smb

### Gaming

`steam proton-ge-custom-bin`

    sudo usermod <username> -aG games

`xpadneo-dkms linux-header`

For Xbox controllers e.g. Xbox Series X/S Controller,
[xpadneo](https://github.com/atar-axis/xpadneo) is necessary to make them
function remotely. Without it, they can only be used plugging in (`xpad` works
in that case).
<del>Stay sway from me cables :)</del>

### GTK

`adw-gtk-theme`

    ./scripts/update-gsettings.sh

### Hibernate

```
# /etc/mkinitcpio.conf
HOOKS=(...filesystems resume fsck...)
```

### QT

`kvantum kvantum-theme-libadwaita-git`

### Virtualization

- [Sharing folder with Windows guest](https://www.debugpoint.com/kvm-share-folder-windows-guest/)

`libvirt qemu-base virt-manager bridge-utils dnsmasq`

    sudo usermod <username> -aG kvm,libvrt # it will take effects after reboot
    sudo systemctl enable libvirtd --now
    sudo virsh net-define /etc/libvirt/qemu/networks/default.xml
    sudo virsh net-autostart default
    sudo virsh net-start default

To control virtual machines in command line, here are some useful ones:

    sudo virsh list
    sudo virsh shutdown <domain>
    sudo virsh snapshot-create-as --domain <domain> --name "<name>"
    sudo virsh snapshot-list --domain <domain>

To use tools like OpenSSH with virtual machines, here is how to get the IP:

    sudo virsh net-list
    sudo virsh net-dhcp-leases default

## Acknowledgements

[marie's dotfiles](https://github.com/mariesavch/dotfiles), for the Oxocarbon override layer over Catppuccin integrations
