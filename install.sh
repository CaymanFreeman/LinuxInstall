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
gsettings set org.gnome.shell.extensions.dash-to-dock dock-alignment 'START'
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
gsettings set org.gnome.desktop.privacy remove-old-trash-files true
gsettings set org.gnome.desktop.privacy remove-old-temp-files true
gsettings set org.gnome.desktop.privacy old-files-age 1
gsettings set org.gnome.desktop.screensaver lock-delay 0
gsettings set org.gnome.desktop.session idle-delay 0
gsettings set org.gnome.desktop.screensaver lock-enabled false
gsettings set org.gnome.desktop.wm.preferences button-layout 'appmenu:minimize,maximize,close'
gsettings set org.gnome.settings-daemon.plugins.power idle-dim false
gsettings set org.gnome.settings-daemon.plugins.power power-saver-profile-on-low-battery false
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-type 'nothing'
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type 'nothing'


# Nala mirror setup
sudo apt -qq install nala -y
sudo nala fetch --auto -y

# Brave debian repository
sudo curl -fsSLo "/usr/share/keyrings/brave-browser-archive-keyring.gpg" "https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg"
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee "/etc/apt/sources.list.d/brave-browser-release.list"

# Gyazo debian repository
sudo curl -s "https://packagecloud.io/install/repositories/gyazo/gyazo-for-linux/script.deb.sh" | sudo bash

# Spotify debian repository
curl -sS "https://download.spotify.com/debian/pubkey_6224F9941A8AA6D1.gpg" | sudo gpg --dearmor --yes -o "/etc/apt/trusted.gpg.d/spotify.gpg"
echo "deb http://repository.spotify.com stable non-free" | sudo tee "/etc/apt/sources.list.d/spotify.list"

# Remove packages
sudo nala remove --purge totem -y
sudo nala remove --purge firefox -y

# Install packages
sudo nala update
sudo nala install plocate git brave-browser steam vlc nemo cosmic-store cosmic-term neofetch gyazo spotify-client libnotify-bin -y
sudo nala upgrade -y

# Flathub repository
flatpak remote-add --if-not-exists --system flathub "https://dl.flathub.org/repo/flathub.flatpakrepo"

# Install flatpaks
flatpak update -y
flatpak install --user io.github.milkshiift.GoofCord xyz.xclicker.xclicker -y
flatpak install --system com.dec05eba.gpu_screen_recorder -y
flatpak upgrade -y

# Cleanup
sudo nala autoremove -y
sudo nala clean
flatpak uninstall --unused -y

# Disable nautilus and configure nemo
[ -f "/usr/share/applications/nautilus-autorun-software.desktop" ] && sudo mv "/usr/share/applications/nautilus-autorun-software.desktop" "/usr/share/applications/nautilus-autorun-software.desktop.disabled"
[ -f "/usr/share/applications/org.gnome.Nautilus.desktop" ] && sudo mv "/usr/share/applications/org.gnome.Nautilus.desktop" "/usr/share/applications/org.gnome.Nautilus.desktop.disabled"
gsettings set org.gnome.desktop.background show-desktop-icons false
gsettings set org.nemo.desktop show-desktop-icons true
xdg-mime default nemo.desktop inode/directory application/x-gnome-saved-search

# Set dash apps
gsettings set org.gnome.shell favorite-apps "['pop-cosmic-applications.desktop', 'com.system76.CosmicStore.desktop', 'nemo.desktop', 'gnome-control-center.desktop', 'com.system76.CosmicTerm.desktop', 'gyazo.desktop', 'brave-browser.desktop', 'io.github.milkshiift.GoofCord.desktop', 'steam.desktop', 'spotify.desktop', 'xyz.xclicker.xclicker.desktop']"

# Create replay scripts
mkdir -p "$HOME/Scripts"
wget "https://raw.githubusercontent.com/CaymanFreeman/LinuxInstall/main/save_replay.sh" -O "$HOME/Scripts/save_replay.sh"
wget "https://raw.githubusercontent.com/CaymanFreeman/LinuxInstall/main/start_replay.sh" -O "$HOME/Scripts/start_replay.sh"
wget "https://raw.githubusercontent.com/CaymanFreeman/LinuxInstall/main/stop_replay.sh" -O "$HOME/Scripts/stop_replay.sh"
chmod +x $HOME/Scripts/*.sh

# Prepare custom keyboard shortcuts
KEYBINDINGS='[
  "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/PopLaunch1/",
  "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/",
  "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/",
  "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/"
]'
dconf write "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings" "$KEYBINDINGS"

# Default PopLaunch shortcut
dconf write "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/PopLaunch1/name" "'WiFi'"
dconf write "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/PopLaunch1/command" "'gnome-control-center wifi'"
dconf write "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/PopLaunch1/binding" "'Launch1'"

# Save Replay shortcut
dconf write "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/name" "'Save Replay'"
dconf write "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/command" "'$HOME/Scripts/save_replay.sh'"
dconf write "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/binding" "'<Alt>F10'"

# Start replay shortcut
dconf write "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/name" "'Start Replay'"
dconf write "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/command" "'$HOME/Scripts/start_replay.sh'"
dconf write "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/binding" "'<Alt>F11'"

# Stop replay shortcut
dconf write "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/name" "'Stop Replay'"
dconf write "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/command" "'$HOME/Scripts/stop_replay.sh'"
dconf write "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/binding" "'<Alt>F12'"

neofetch
