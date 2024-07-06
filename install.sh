#!/bin/bash

set -e

REPOSITORY_URL='https://raw.githubusercontent.com/CaymanFreeman/LinuxInstall/main'

sudo -v

# Change settings
if ls /sys/class/power_supply/BAT* > /dev/null 2>&1; then
    gsettings set-from-string << EOF
    org.gnome.desktop.peripherals.touchpad natural-scroll true
    org.gnome.settings-daemon.plugins.power power-saver-profile-on-low-battery false
    org.gnome.desktop.interface show-battery-percentage true
EOF
fi

gsettings set-from-string << EOF
org.gnome.shell.extensions.pop-cosmic clock-alignment 'RIGHT'
org.gnome.shell.extensions.pop-cosmic overlay-key-action 'APPLICATIONS'
org.gnome.shell.extensions.pop-cosmic show-workspaces-button false
org.gnome.shell.extensions.pop-cosmic show-applications-button false
org.gnome.shell.extensions.dash-to-dock dock-alignment 'START'
org.gnome.shell.extensions.dash-to-dock show-mounts false
org.gnome.desktop.background color-shading-type 'solid'
org.gnome.desktop.background picture-options 'zoom'
org.gnome.desktop.background picture-uri-dark 'file:///usr/share/backgrounds/pop/nick-nazzaro-ice-cave.png'
org.gnome.desktop.background primary-color '#000000'
org.gnome.desktop.background secondary-color '#000000'
org.gnome.desktop.screensaver color-shading-type 'solid'
org.gnome.desktop.screensaver picture-options 'zoom'
org.gnome.desktop.screensaver picture-uri 'file:///usr/share/backgrounds/pop/nick-nazzaro-ice-cave.png'
org.gnome.desktop.screensaver primary-color '#000000'
org.gnome.desktop.screensaver secondary-color '#000000'
org.gnome.desktop.privacy remove-old-trash-files true
org.gnome.desktop.privacy remove-old-temp-files true
org.gnome.desktop.privacy old-files-age 1
org.gnome.desktop.screensaver lock-delay 0
org.gnome.desktop.session idle-delay 0
org.gnome.desktop.screensaver lock-enabled false
org.gnome.desktop.wm.preferences button-layout 'appmenu:minimize,maximize,close'
org.gnome.settings-daemon.plugins.power idle-dim false
org.gnome.settings-daemon.plugins.power power-saver-profile-on-low-battery false
org.gnome.settings-daemon.plugins.power sleep-inactive-battery-type 'nothing'
org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type 'nothing'
EOF

# Nala mirror setup
sudo apt-get -qq install nala -y
sudo nala fetch --auto -y

# Gyazo debian repository
sudo curl -s "https://packagecloud.io/install/repositories/gyazo/gyazo-for-linux/script.deb.sh" | sudo bash

# Remove packages
sudo nala remove --purge totem firefox -y

# Install packages and drivers
sudo nala update
if lspci | grep -i nvidia > /dev/null 2>&1; then
    sudo nala install system76-driver-nvidia -y
fi
sudo nala install plocate git steam vlc nemo neofetch gyazo libnotify-bin -y
sudo nala upgrade -y

# Install flatpaks
flatpak update -y
GPU_VENDORS=$(lspci | grep VGA | cut -d ' ' -f5)
if [[ "$GPU_VENDORS" = *"NVIDIA"* ]] || [[ "$GPU_VENDORS" = *"AMD"* ]]; then
    flatpak remote-add --if-not-exists --system flathub "https://dl.flathub.org/repo/flathub.flatpakrepo"
    flatpak install --system com.dec05eba.gpu_screen_recorder -y
elif [[ "$GPU_VENDORS" = *"Intel"* ]] && [[ "$GPU_VENDORS" != *"NVIDIA"* ]] && [[ "$GPU_VENDORS" != *"AMD"* ]]; then
    flatpak remote-add --if-not-exists --system flathub "https://dl.flathub.org/repo/flathub.flatpakrepo"
    flatpak install --system com.dec05eba.gpu_screen_recorder -y
else
    flatpak remote-add --if-not-exists --user flathub "https://dl.flathub.org/repo/flathub.flatpakrepo"
    flatpak install --user com.dec05eba.gpu_screen_recorder -y
fi
flatpak install --user io.github.milkshiift.GoofCord xyz.xclicker.xclicker com.obsproject.Studio com.atlauncher.ATLauncher com.brave.Browser com.spotify.Client -y
flatpak upgrade -y

# Install NoiseTorch
LATEST_TAG=$(curl -s "https://api.github.com/repos/noisetorch/NoiseTorch/releases/latest" | grep 'tag_name' | cut -d\" -f4)
ASSET_NAME="NoiseTorch_x64_$LATEST_TAG.tgz"
DOWNLOAD_URL="https://github.com/noisetorch/NoiseTorch/releases/download/$LATEST_TAG/$ASSET_NAME"
cd "$HOME/Downloads" && curl -JLO $DOWNLOAD_URL && tar -C $HOME -h -xzf $ASSET_NAME && rm $ASSET_NAME && cd
sudo setcap 'CAP_SYS_RESOURCE=+ep' "$HOME/.local/bin/noisetorch"
gtk-update-icon-cache

# Set dash apps
gsettings set org.gnome.shell favorite-apps "['pop-cosmic-applications.desktop', 'io.elementary.appcenter.desktop', 'nemo.desktop', 'gnome-control-center.desktop', 'org.gnome.Terminal.desktop', 'gyazo.desktop', 'com.brave.Browser.desktop', 'io.github.milkshiift.GoofCord.desktop', 'steam.desktop', 'com.atlauncher.ATLauncher.desktop', 'com.spotify.Client.desktop', 'com.obsproject.Studio.desktop', 'xyz.xclicker.xclicker.desktop', 'noisetorch.desktop']"

# Cleanup
sudo nala autoremove -y
sudo nala clean
flatpak uninstall --unused -y

# Disable Invidious in Goofcord
[[ -f "$HOME/.var/app/io.github.milkshiift.GoofCord/config/goofcord/scripts/14_invidiousEmbeds.js" ]] && mv "$HOME/.var/app/io.github.milkshiift.GoofCord/config/goofcord/scripts/14_invidiousEmbeds.js" "$HOME/.var/app/io.github.milkshiift.GoofCord/config/goofcord/scripts/14_invidiousEmbeds.js.disabled"

# Disable nautilus and configure nemo
[[ -f "/usr/share/applications/nautilus-autorun-software.desktop" ]] && sudo mv "/usr/share/applications/nautilus-autorun-software.desktop" "/usr/share/applications/nautilus-autorun-software.desktop.disabled"
[[ -f "/usr/share/applications/org.gnome.Nautilus.desktop" ]] && sudo mv "/usr/share/applications/org.gnome.Nautilus.desktop" "/usr/share/applications/org.gnome.Nautilus.desktop.disabled"
gsettings set org.gnome.desktop.background show-desktop-icons false
gsettings set org.nemo.desktop show-desktop-icons true
xdg-mime default nemo.desktop inode/directory application/x-gnome-saved-search

# GPU-Screen-Recorder OC optimization
if [[ $GPU_VENDORS = *"NVIDIA"* ]]; then
    sudo nvidia-xconfig --cool-bits=12
fi

# GPU-Screen-Recorder CUDA fix
if [[ $GPU_VENDORS = *"NVIDIA"* ]]; then
    sudo nala install nvidia-cuda-toolkit -y
fi
if command -v nvcc > /dev/null; then
    wget "$REPOSITORY_URL/gsr-nvidia.conf" -O "$HOME/Downloads/gsr-nvidia.conf" && sudo install -Dm644 "$HOME/Downloads/gsr-nvidia.conf" "/etc/modprobe.d/gsr-nvidia.conf" && rm "$HOME/Downloads/gsr-nvidia.conf"
else
    sudo nala remove nvidia-cuda-toolkit -y
fi

# Create replay scripts
mkdir -p "$HOME/Scripts"
wget "$REPOSITORY_URL/save_replay.sh" -O "$HOME/Scripts/save_replay.sh" && chmod +x "$HOME/Scripts/save_replay.sh"
wget "$REPOSITORY_URL/start_replay.sh" -O "$HOME/Scripts/start_replay.sh" && chmod +x "$HOME/Scripts/start_replay.sh"
wget "$REPOSITORY_URL/stop_replay.sh" -O "$HOME/Scripts/stop_replay.sh" && chmod +x "$HOME/Scripts/stop_replay.sh"

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
mkdir -p "$HOME/.config/autostart" && wget "$REPOSITORY_URL/start_replay.sh.desktop" -O "$HOME/.config/autostart/start_replay.sh.desktop" && sed -i '/Exec=/s/$/sh '${HOME//\//\\/}'\/Scripts\/start_replay.sh/' "$HOME/.config/autostart/start_replay.sh.desktop"

tput ed
neofetch

echo "It is now highly recommended that you restart your system"
