#!/bin/bash

echo -e "\e[32m\nInstall all\e[0m"
git config --global user.email "contact@eliesauveterre.com"
git config --global user.name "Elie"

echo -e "\e[32m\nPackage repo refresh\e[0m"
sudo pacman -Syy

if ! pacman -Q "cachyos-gaming-meta" &>/dev/null; then

    echo -e "\e[32m\nInstall Gaming\e[0m"
    sudo pacman -S --noconfirm --needed cachyos-gaming-meta
fi

if ! pacman -Q "joplin-desktop" &>/dev/null; then

    echo -e "\e[32m\nInstall joplin\e[0m"
    sudo pacman -S --noconfirm --needed joplin-desktop
fi

if ! pacman -Q "keepassxc" &>/dev/null; then

    echo -e "\e[32m\nInstall keepassxc\e[0m"
    sudo pacman -S --noconfirm --needed keepassxc
fi

if ! pacman -Q "synology-drive" &>/dev/null; then

    echo -e "\e[32m\nInstall synology-drive\e[0m"
    paru -S --review synology-drive
fi

if ! pacman -Q "brave-bin" &>/dev/null; then

    echo -e "\e[32m\nInstall Brave\e[0m"
    sudo pacman -S --noconfirm --needed brave-bin
fi


if ! pacman -Q "flatpak" &>/dev/null; then

    echo -e "\e[32m\nInstall flatpak\e[0m"
    sudo pacman -S --noconfirm --needed flatpak
    flatpak install --noninteractive flathub tv.plex.PlexDesktop
    mkdir -p ~/.config/environment.d
    echo "XDG_DATA_DIRS=/var/lib/flatpak/exports/share:/home/$USER/.local/share/flatpak/exports/share:/usr/local/share:/usr/share" > ~/.config/environment.d/flatpak.conf
fi

if ! pacman -Q "anydesk-bin" &>/dev/null; then

    echo -e "\e[32m\nInstall anydesk\e[0m"
    paru -S --review anydesk-bin
fi

if ! pacman -Q "lenovolegionlinux-git" &>/dev/null; then

    echo -e "\e[32m\nInstall Legion Linux\e[0m"
    sudo pacman -S --noconfirm --needed base-devel linux-headers dkms
    paru -S --review lenovolegionlinux-git
    paru -S lenovolegionlinux-dkms-git
    sudo cp -R /usr/share/legion_linux /etc/legion_linux
    sudo dkms install lenovolegionlinux/1.0.0
fi

if ! pacman -Q "wivrn-dashboard" &>/dev/null; then

    echo -e "\e[32m\nInstall wivrn\e[0m"
    paru -S --review wivrn-dashboard
    wget https://nightly.link/Supreeeme/xrizer/workflows/ci/main/xrizer-nightly-release.zip
    unzip xrizer-nightly-release.zip -d ~/.local/share
    ## Need to add /home/elie/.local/share/xrizer in wivrn settings
    # Allow from LAN
    sudo ufw allow from 192.168.0.0/16 to any port 5353 proto udp
    sudo ufw allow from 192.168.0.0/16 to any port 9757
    sudo systemctl enable --now avahi-daemon
    # For FPS overlay
    sudo pacman -S mangohud
    # On each Steam games, set launch options to:
    # PROTON_USE_NTSYNC=1 VR_OVERRIDE=/home/elie/.local/share/xrizer %command%
fi
