#!/bin/bash

echo -e "\e[32m\nInstall all\e[0m"
echo -e "\e[32m\nPackage repo refresh\e[0m"
sudo pacman -Syy
echo -e "\e[32m\nFull upgrade\e[0m"
sudo pacman -Syu
paru -Sua --review
mkdir Workspace -p

if ! pacman -Q "git" &>/dev/null; then

    echo -e "\e[32m\nInstall git\e[0m"
    sudo pacman -S --noconfirm --needed git git-lfs
    git lfs install
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

if ! pacman -Q "cursor-bin" &>/dev/null; then

    echo -e "\e[32m\nInstall cursor\e[0m"
    paru -S --review cursor-bin
    sudo chown -R $USER:$USER /usr/share/cursor # Needs to be after first launch??
fi

if ! pacman -Q "docker" &>/dev/null; then

    echo -e "\e[32m\nInstall docker\e[0m"
    sudo pacman -S --noconfirm --needed docker docker-compose docker-buildx
    sudo mkdir -p /etc/docker
    sudo touch /etc/docker/daemon.json
    printf '{\n  "features": { "buildkit": true },\n  "storage-driver": "btrfs"\n}\n' | sudo tee /etc/docker/daemon.json > /dev/null
    sudo systemctl enable --now docker.service
    sudo usermod -aG docker $USER
    newgrp docker
fi

if ! pacman -Q "ddev-bin" &>/dev/null; then

    echo -e "\e[32m\nInstall ddev\e[0m"
    paru -S --review ddev-bin
    mkcert -install
    mkdir -p ~/.local/bin
    cat << 'EOF' > ~/.local/bin/php
#!/usr/bin/env bash

# Host project root (where you run the command from)
HOST_ROOT="$(pwd)"

# Project root inside DDEV container
CONTAINER_ROOT="/var/www/html"

# Arguments to forward to php (minus -r and its script)
args=()

use_script_file=false
script_content=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    -r)
      # Next argument is the inline PHP script
      use_script_file=true
      shift
      # Rewrite host paths in the script to container paths
      script_content="${1//$HOST_ROOT/$CONTAINER_ROOT}"
      shift
      ;;
    *)
      # Rewrite host paths in normal args too (e.g. file paths)
      args+=( "${1//$HOST_ROOT/$CONTAINER_ROOT}" )
      shift
      ;;
  esac
done

if $use_script_file; then
  # Write the script to a temp file under the project
  host_script="${HOST_ROOT}/.vscode-laravel-intellisense.php"
  printf "%s" "$script_content" > "$host_script"

  # Translate that path for inside the container
  container_script="${host_script//$HOST_ROOT/$CONTAINER_ROOT}"

  # Run PHP in the DDEV container, pointing at the file (no -r anymore)
  ddev exec php "${args[@]}" "$container_script"
else
  # Normal usage, no inline script
  ddev exec php "${args[@]}"
fi
EOF
    chmod +x ~/.local/bin/php
    set -U fish_user_paths ~/.local/bin $fish_user_paths
fi

if ! pacman -Q "android-studio" &>/dev/null; then

    echo -e "\e[32m\nInstall android\e[0m"
    paru -S --review android-studio
    set -x ANDROID_SDK_VERSION "11076708"
    set -x ANDROID_BUILD_TOOLS_VERSION 35.0.0
    set -x ANDROID_APIS "android-34"
    mkdir -p $HOME/Android/Sdk
    wget https://dl.google.com/android/repository/commandlinetools-linux-{$ANDROID_SDK_VERSION}_latest.zip
    unzip commandlinetools-linux-{$ANDROID_SDK_VERSION}_latest.zip -d $HOME/Android/Sdk/cmdline-tools
    mv $HOME/Android/Sdk/cmdline-tools/cmdline-tools $HOME/Android/Sdk/cmdline-tools/latest
    rm commandlinetools-linux-{$ANDROID_SDK_VERSION}_latest.zip
    set -Ux ANDROID_SDK_ROOT $HOME/Android/Sdk
    set -U fish_user_paths $ANDROID_SDK_ROOT/cmdline-tools/latest/bin $fish_user_paths
    set -U fish_user_paths $ANDROID_SDK_ROOT/platform-tools $fish_user_paths
    #
    echo -e "\e[32m\nInstall Android SDKs\e[0m"
    yes | sdkmanager --licenses --sdk_root=$ANDROID_HOME
    sdkmanager "cmdline-tools;latest" --sdk_root=$ANDROID_HOME
    sdkmanager "build-tools;$ANDROID_BUILD_TOOLS_VERSION" --sdk_root=$ANDROID_HOME
    sdkmanager "platform-tools" --sdk_root=$ANDROID_HOME
    sdkmanager "platforms;$ANDROID_APIS" --sdk_root=$ANDROID_HOME
    sdkmanager "extras;android;m2repository" --sdk_root=$ANDROID_HOME
    sdkmanager "extras;google;m2repository" --sdk_root=$ANDROID_HOME
    #
    echo -e "\e[32m\nInstall JAVA\e[0m"
    sudo pacman -S --noconfirm --needed jdk17-openjdk
    set -Ux JAVA_HOME /usr/lib/jvm/java-17-openjdk
    set -U fish_user_paths $JAVA_HOME/bin $fish_user_paths
fi

if ! flatpak list --app | grep -q "io.dbeaver.DBeaverCommunity"; then

    echo -e "\e[32m\nInstall DBeaver\e[0m"
    sudo flatpak install flathub io.dbeaver.DBeaverCommunity
fi

if ! flatpak list --app | grep -q "com.github.IsmaelMartinez.teams_for_linux"; then

    echo -e "\e[32m\nInstall teams\e[0m"
    sudo flatpak install flathub com.github.IsmaelMartinez.teams_for_linux
fi
