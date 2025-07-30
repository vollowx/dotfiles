# Stowed

_GNU/Stow-managed dotfiles for *nix systems_

[TODO](./TODO.md)

*Package names are those in Arch Linux and AUR by default

## Showcasee

<img width="2560" height="1440" alt="qutebrowser and newsboat" src="https://github.com/user-attachments/assets/9773a6a8-13d9-4ad7-93f2-6d9a515e4688" />
<img width="2560" height="1440" alt="Neovim checking dwl source code and lf previewing image" src="https://github.com/user-attachments/assets/f9ae9a7e-47a9-4593-8d97-10a605f93074" />
<img width="2560" height="1440" alt="lf previewing PDF and zathura viewing PDF, with dmenu selecting default audio input/output at the bottom of the screen" src="https://github.com/user-attachments/assets/ba42e4f5-afdf-4579-a71e-69f2af48ce08" />

I don't use floating windows so often actually, this is just for a better look
in screenshots.

## Installation

    git clone git@github.com:vollowx/Stowed.git ~/Stowed
    cd ~/Stowed
    stow stow-cli
    stow stow-gui

Basic ones:

`stow bash-completion pkgfile unzip unrar 7zip go`

    go install go.senan.xyz/untree@latest
    sudo pkgfile --update

The ones run in command line

`htop fd ripgrep newsboat neomutt`

`mpd mpc ncmpcpp`

`lf bat catimg chafa ffmpegthumbnailer transmission-cli`

`neovim lua-language-server stylua shfmt prettier`

The ones run in GUI

`sway swaybg swayidle swaylock sway-contrib`

`waybar dunst wofi network-manager-applet blueman`

`xdg-desktop-portal-wlr xdg-desktop-portal-gtk polkit-gnome`

`ghostty zathura`

## Addition

### Other Apps

The packages below are neither configured by nor related to this set of
dotfiles.

`fcitx5 firefox nemo file-roller mission-center gimp`

### Audio

`pipewire pipewire-alsa pipewire-jack pipewire-pulse`

This also installs `pipewire-audio pipewire-session-manager wireplumber`, and
the `systemd`-based auto-start is already managed in
`@/stow-gui/.config/systemd`.

### Bluetooth

`bluez bluez-utils`

    sudo systemctl enable bluetooth.service

`blueman` is for the GUI manager and applet, the applet is used in Waybar.

### Gaming

`steam proton-ge-custom-bin`

    sudo usermod <username> -aG games

Proton GE is used just because it magically solves this error:

`wine: failed to open "c:\\windows\\system32\\steam.exe": c0000135`

which happens every time I launch a game in Steam, even though I was not
actually running games in an NTFS drive, yet most of the threads talking about
this error, they are.

Set Steam > Settings > Compatibility > Default compatibility tool to Proton-GE.

`xpadneo-dkms linux-header`

For Xbox controllers e.g. Xbox Series X/S Controller,
[xpadneo](https://github.com/atar-axis/xpadneo) is necessary to make them
function remotely. Without it, they can only be used plugging in (`xpad` works
in that case).
<del>Stay sway from me cables :)</del>

### GTK

`adw-gtk-theme`

    ./scripts/update-gsettings.sh
    ./scripts/install-adw-firefox.sh
    ./scripts/install-adw-steam.sh

### Hibernate

```
# /etc/systemd/logind.conf
HandlePowerKey=hibernate
```

```
# /etc/mkinitcpio.conf
HOOKS=(...filesystems resume fsck...)
```

### QT

`kvantum kvantum-theme-libadwaita-git`

### Virtualization

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
