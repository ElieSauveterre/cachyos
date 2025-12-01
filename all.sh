#!/bin/bash

echo -e "\e[32m\nInstall all\e[0m"
echo -e "\e[32m\nPackage repo refresh\e[0m"
sudo pacman -Syy
echo -e "\e[32m\nFull upgrade\e[0m"
sudo pacman -Syu
mkdir Workspace -p

if ! pacman -Q "git" &>/dev/null; then

    echo -e "\e[32m\nInstall git\e[0m"
    sudo pacman -S --noconfirm --needed git
    git config --global user.email "contact@eliesauveterre.com"
    git config --global user.name "Elie"
    git config --global credential.helper store
fi

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

if [ ! -f "/usr/local/bin/lll" ]; then

    # https://github.com/johnfanv2/LenovoLegionLinux
    echo -e "\e[32m\nInstall Legion Linux\e[0m"
sudo pacman -S --noconfirm --needed base-devel dkms linux-headers
    sudo pacman -S --noconfirm --needed linux-cachyos-headers
    sudo pacman -S --needed base-devel git dkms lm_sensors dmidecode python-pyqt6 python-yaml python-argcomplete python-darkdetect openssl mokutil
    cd Workspace
    git clone https://github.com/johnfanv2/LenovoLegionLinux.git
    cd LenovoLegionLinux
    git checkout 1952cd6f0a7730358209577a0ea85dcfb875240b
    cd kernel_module
    LLVM=1 make
    sudo LLVM=1 make install
    sudo LLVM=1 make reloadmodule
    cd ..
    # DKMS install to avoid patching kernel after each update
    sudo mkdir -p /usr/src/LenovoLegionLinux-1.0.0
    sudo cp ./kernel_module/* /usr/src/LenovoLegionLinux-1.0.0 -r
    sudo dkms add -m LenovoLegionLinux -v 1.0.0
    sudo dkms build -m LenovoLegionLinux -v 1.0.0
    cd ..
    sudo su
    sudo tee /usr/local/bin/lll >/dev/null << 'EOF'
#!/bin/bash
cd /home/elie/Workspace/LenovoLegionLinux
exec python python/legion_linux/legion_linux/legion_gui.py
EOF
    exit
    sudo chmod +x /usr/local/bin/lll
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

if ! pacman -Q "lact" &>/dev/null; then

    echo -e "\e[32m\nInstall lact - GPU monitor & OC\e[0m"
    sudo pacman -S --noconfirm --needed lact
    sudo systemctl enable --now lactd
fi

if ! flatpak list --app | grep -q "com.getpostman.Postman"; then

    echo -e "\e[32m\nInstall postman\e[0m"
    sudo flatpak install flathub com.getpostman.Postman

fi

if ! pacman -Q "thunderbird" &>/dev/null; then

    echo -e "\e[32m\nInstall thunderbird\e[0m"
    sudo pacman -S --noconfirm --needed thunderbird
fi
