#!/bin/bash

echo -e "\e[32m\nInstall all\e[0m"

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
