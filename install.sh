#!/bin/bash

# Clear and sudo
clear
sudo -v

# Determine if laptop or desktop
if ls /sys/class/power_supply/BAT* > /dev/null 2>&1; then
    SYSTEM_TYPE="LAPTOP"
else
    SYSTEM_TYPE="DESKTOP"
fi

# Change settings
if [ "$SYSTEM_TYPE" = "LAPTOP" ]; then
    gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll true
    gsettings set org.gnome.settings-daemon.plugins.power power-saver-profile-on-low-battery false
    gsettings set org.gnome.desktop.interface show-battery-percentage true
fi
gsettings set org.gnome.shell.extensions.pop-cosmic clock-alignment 'RIGHT'
gsettings set org.gnome.shell.extensions.pop-cosmic overlay-key-action 'APPLICATIONS'
gsettings set org.gnome.shell.extensions.pop-cosmic show-workspaces-button false
gsettings set org.gnome.shell.extensions.pop-cosmic show-applications-button false
gsettings set org.gnome.desktop.wm.preferences button-layout 'appmenu:minimize,maximize,close'
gsettings set org.gnome.desktop.background color-shading-type 'solid'
gsettings set org.gnome.desktop.background picture-options 'zoom'
gsettings set org.gnome.desktop.background picture-uri-dark 'file:///usr/share/backgrounds/pop/nick-nazzaro-ice-cave.png'
gsettings set org.gnome.desktop.background primary-color '#000000'
gsettings set org.gnome.desktop.background secondary-color '#000000'
gsettings set org.gnome.desktop.screensaver color-shading-type 'solid'
gsettings set org.gnome.desktop.screensaver picture-options 'zoom'
gsettings set org.gnome.desktop.screensaver picture-uri 'file:///usr/share/backgrounds/pop/nick-nazzaro-ice-cave.png'
gsettings set org.gnome.desktop.screensaver primary-color '#000000'
gsettings set org.gnome.desktop.screensaver secondary-color '#000000'
gsettings set org.gnome.shell.extensions.dash-to-dock dock-alignment 'START'
gsettings set org.gnome.desktop.privacy remove-old-trash-files true
gsettings set org.gnome.desktop.privacy remove-old-temp-files true
gsettings set org.gnome.desktop.privacy old-files-age 1
gsettings set org.gnome.desktop.screensaver lock-delay 0
gsettings set org.gnome.desktop.session idle-delay 0
gsettings set org.gnome.desktop.screensaver lock-enabled false
gsettings set org.gnome.settings-daemon.plugins.power idle-dim false
gsettings set org.gnome.settings-daemon.plugins.power power-saver-profile-on-low-battery false
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-type 'nothing'
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type 'nothing'

# Nala mirror setup
sudo apt -qq install nala -y
sudo nala fetch --auto -y

# Brave browser repository
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list

# Flatpak flathub remote
flatpak remote-add --if-not-exists --system flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# Update
sudo nala update
flatpak update -y

# Install packages
sudo nala install plocate -y
sudo nala install git -y
sudo nala install brave-browser -y
sudo nala install steam -y
sudo nala install vlc -y
sudo nala install nemo -y
sudo nala install cosmic-store -y
sudo nala install cosmic-term -y
sudo nala install neofetch -y
flatpak install --user io.github.milkshiift.GoofCord -y
flatpak install --user xyz.xclicker.xclicker -y
sudo nala upgrade -y
flatpak upgrade -y

# Remove packages
sudo nala remove --purge totem -y
sudo nala remove --purge firefox -y

# Cleanup
flatpak uninstall --unused
sudo nala autoremove -y
sudo nala clean

# Set dash apps
gsettings set org.gnome.shell favorite-apps "['pop-cosmic-applications.desktop', 'com.system76.CosmicStore.desktop', 'nemo.desktop', 'gnome-control-center.desktop', 'com.system76.CosmicTerm.desktop', 'brave-browser.desktop', 'io.github.milkshiift.GoofCord.desktop', 'steam.desktop', 'xyz.xclicker.xclicker.desktop']"

neofetch