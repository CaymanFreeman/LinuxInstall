#!/bin/bash

sudo -v

# Change settings
if ls /sys/class/power_supply/BAT* > /dev/null 2>&1; then
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

# Gyazo debian repository
sudo curl -s "https://packagecloud.io/install/repositories/gyazo/gyazo-for-linux/script.deb.sh" | sudo bash

# Spotify debian repository
curl -sS "https://download.spotify.com/debian/pubkey_6224F9941A8AA6D1.gpg" | sudo gpg --dearmor --yes -o "/etc/apt/trusted.gpg.d/spotify.gpg"
echo "deb http://repository.spotify.com stable non-free" | sudo tee "/etc/apt/sources.list.d/spotify.list"

# Remove packages
sudo nala remove --purge totem -y
sudo nala remove --purge firefox -y

# Install packages and drivers
sudo nala update
if lspci | grep -i nvidia > /dev/null 2>&1; then
    sudo nala install system76-driver-nvidia -y
fi
sudo nala install plocate git steam vlc nemo neofetch gyazo spotify-client libnotify-bin -y
sudo nala upgrade -y

# Flathub repository
flatpak remote-add --if-not-exists --system flathub "https://dl.flathub.org/repo/flathub.flatpakrepo"

# Install flatpaks
flatpak update -y
flatpak install --user io.github.milkshiift.GoofCord xyz.xclicker.xclicker com.obsproject.Studio com.atlauncher.ATLauncher com.brave.Browser -y
flatpak install --system com.dec05eba.gpu_screen_recorder -y
flatpak upgrade -y

# Install NoiseTorch
LATEST_TAG=$(curl -s "https://api.github.com/repos/noisetorch/NoiseTorch/releases/latest" | grep 'tag_name' | cut -d\" -f4)
ASSET_NAME="NoiseTorch_x64_$LATEST_TAG.tgz"
DOWNLOAD_URL="https://github.com/noisetorch/NoiseTorch/releases/download/$LATEST_TAG/$ASSET_NAME"
cd "$HOME/Downloads" && curl -JLO $DOWNLOAD_URL && tar -C $HOME -h -xzf $ASSET_NAME && rm $ASSET_NAME && cd
sudo setcap 'CAP_SYS_RESOURCE=+ep' "$HOME/.local/bin/noisetorch"
gtk-update-icon-cache

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
gsettings set org.gnome.shell favorite-apps "['pop-cosmic-applications.desktop', 'io.elementary.appcenter.desktop', 'nemo.desktop', 'gnome-control-center.desktop', 'org.gnome.Terminal.desktop', 'gyazo.desktop', 'brave-browser.desktop', 'io.github.milkshiift.GoofCord.desktop', 'steam.desktop', 'com.atlauncher.ATLauncher.desktop', 'spotify.desktop', 'com.obsproject.Studio.desktop', 'xyz.xclicker.xclicker.desktop', 'noisetorch.desktop']"

# Create replay scripts
mkdir -p "$HOME/Scripts"
wget "https://raw.githubusercontent.com/CaymanFreeman/LinuxInstall/main/save_replay.sh" -O "$HOME/Scripts/save_replay.sh" && chmod +x "$HOME/Scripts/save_replay.sh"
wget "https://raw.githubusercontent.com/CaymanFreeman/LinuxInstall/main/start_replay.sh" -O "$HOME/Scripts/start_replay.sh" && chmod +x "$HOME/Scripts/start_replay.sh"
wget "https://raw.githubusercontent.com/CaymanFreeman/LinuxInstall/main/stop_replay.sh" -O "$HOME/Scripts/stop_replay.sh" && chmod +x "$HOME/Scripts/stop_replay.sh"

# Get and set the highest resolution size
RESOLUTIONS=$(xrandr --query | grep ' connected' | grep -oP '\d+x\d+')
HIGHEST_RES="0x0"
for RES in $RESOLUTIONS; do
  WIDTH=${RES%x*}
  HEIGHT=${RES#*x}
  HIGHEST_WIDTH=${HIGHEST_RES%x*}
  HIGHEST_HEIGHT=${HIGHEST_RES#*x}
  if (( WIDTH > HIGHEST_WIDTH )) || { (( WIDTH == HIGHEST_WIDTH )); (( HEIGHT > HIGHEST_HEIGHT )); }; then
    HIGHEST_RES=$RES
  fi
done
sed -i "/VIDEO_AREA=/s/$/$HIGHEST_RES/" "$HOME/Scripts/start_replay.sh"

# Get and set the video codec
CODECS=$(flatpak run --command=gpu-screen-recorder com.dec05eba.gpu_screen_recorder --list-supported-video-codecs)
VIDEO_CODEC='auto'
if echo "$CODECS" | grep -q 'hevc'; then
    VIDEO_CODEC='hevc'
elif echo "$CODECS" | grep -q 'h264'; then
    VIDEO_CODEC='h264'
fi
sed -i "/VIDEO_CODEC=/s/$/$VIDEO_CODEC/" "$HOME/Scripts/start_replay.sh"

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
dconf write "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/command" "'sh $HOME/Scripts/save_replay.sh'"
dconf write "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/binding" "'<Alt>F10'"

# Start replay shortcut
dconf write "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/name" "'Start Replay'"
dconf write "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/command" "'sh $HOME/Scripts/start_replay.sh'"
dconf write "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/binding" "'<Primary><Shift>F11'"

# Stop replay shortcut
dconf write "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/name" "'Stop Replay'"
dconf write "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/command" "'sh $HOME/Scripts/stop_replay.sh'"
dconf write "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/binding" "'<Primary><Shift>F12'"

# Setup replay autostart
wget "https://raw.githubusercontent.com/CaymanFreeman/LinuxInstall/main/start_replay.sh.desktop" -O "$HOME/.config/autostart/start_replay.sh.desktop" && sed -i '/Exec=/s/$/sh '${HOME//\//\\/}'\/Scripts\/start_replay.sh/' "$HOME/.config/autostart/start_replay.sh.desktop"

neofetch
