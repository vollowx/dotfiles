# dotfiles

_Stow-managed dotfiles for *nix systems_

Package names are those in Arch Linux and AUR by default.

This dotfiles will probably not work for you without modifying since there are
many hard-coded names that doesn't exist on your machine. For reference only.

[TODO](./TODO.md)

## Applying

    git clone git@github.com:vollowx/dotfiles.git && cd ~/dotfiles
    ./scripts/install-desktop.sh

`stow bash-completion pkgfile unzip unrar 7zip go`

    go install go.senan.xyz/untree@latest
    sudo pkgfile --update

`htop fd ripgrep newsboat neomutt`

`mpd` `mpc ncmpcpp mpd-discord-rpc mpdscribble`

`lf` `bat catimg chafa ffmpegthumbnailer transmission-cli`

`neovim` `lua-language-server stylua shfmt prettier`

`sway` `swaybg swayidle swaylock sway-contrib waybar dunst blueman`

`xdg-desktop-portal-wlr xdg-desktop-portal-gtk polkit-gnome`

`foot zathura`

`fcitx5 fcitx5-rime rime-ice rime-pinyin-moegirl qutebrowser gimp`

**Audio**

`pipewire pipewire-alsa pipewire-jack pipewire-pulse`

This also installs `pipewire-audio pipewire-session-manager wireplumber`, and
the `systemd`-based auto-start is managed in
`@/home-gui/.config/systemd`.

**Bluetooth**

`bluez bluez-utils`

    sudo systemctl enable bluetooth.service

`blueman` is for the GUI manager and applet, the applet is used in Waybar.

**Gaming**

`steam proton-ge-custom-bin`

    sudo usermod <username> -aG games

`xpadneo-dkms linux-header`

For Xbox controllers e.g. Xbox Series X/S Controller,
[xpadneo](https://github.com/atar-axis/xpadneo) is necessary to make them
function remotely. Without it, they can only be used plugging in (`xpad` works
in that case).
<del>Stay sway from me cables :)</del>

**GTK**

`adw-gtk-theme`

    ./scripts/update-gsettings.sh

**Hibernate**

Power button config is in `@/root`

```
# /etc/mkinitcpio.conf
HOOKS=(...filesystems resume fsck...)
```

**QT**

`kvantum kvantum-theme-libadwaita-git`

**Samba**

`samba`

    sudo smbpasswd -a <username>
    sudo systemctl enable --now smb

- [Samba Arch Wiki](https://wiki.archlinux.org/title/Samba)
- [Samba folder read only on iOS 18.5+](https://blog.fernvenue.com/archives/samba-read-only-issue-on-ios/)

**Virtualization**

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
