## Built For Pop! OS (22.04 LTS)

#### Get Install Script:
```
wget https://raw.githubusercontent.com/CaymanFreeman/LinuxInstall/main/install.sh -O install.sh
```

#### Auto-Run Install Script:
```
wget https://raw.githubusercontent.com/CaymanFreeman/LinuxInstall/main/install.sh -O install.sh && chmod +x install.sh && ./install.sh && sudo rm install.sh
```

#### Uninstall Brave Browser
```
sudo nala remove brave-browser -y
```

#### Uninstall Steam Launcher
```
sudo nala remove steam -y
```

#### Uninstall VLC Media Player
```
sudo nala remove vlc -y
```

#### Uninstall Nemo
```
sudo nala remove nemo -y
[ -f "/usr/share/applications/nemo.desktop.disabled" ] && sudo mv "/usr/share/applications/nemo.desktop.disabled" "/usr/share/applications/nemo.desktop"
[ -f "/usr/share/applications/nautilus-autorun-software.desktop.disabled" ] && sudo mv "/usr/share/applications/nautilus-autorun-software.desktop.disabled" "/usr/share/applications/nautilus-autorun-software.desktop"
[ -f "/usr/share/applications/org.gnome.Nautilus.desktop.disabled" ] && sudo mv "/usr/share/applications/org.gnome.Nautilus.desktop.disabled" "/usr/share/applications/org.gnome.Nautilus.desktop"
gsettings set org.gnome.desktop.background show-desktop-icons true
gsettings set org.nemo.desktop show-desktop-icons false
xdg-mime default org.gnome.Nautilus.desktop inode/directory application/x-gnome-saved-search
```

#### Uninstall Neofetch
```
sudo nala remove neofetch -y
```

#### Uninstall Gyazo
```
sudo nala remove gyazo -y
```

#### Uninstall Spotify
```
sudo nala remove spotify-client -y
```

#### Uninstall Goofcord
```
flatpak remove io.github.milkshiift.GoofCord -y
```

#### Uninstall XClicker
```
flatpak remove xyz.xclicker.xclicker -y
```

#### Uninstall OBS
```
flatpak remove com.obsproject.Studio -y
```

#### Uninstall GPU-Screen-Recorder
##### (Keyboard shortcuts can be removed in the Settings application)
```
sh "$HOME/Scripts/stop_replay.sh"
flatpak remove com.dec05eba.gpu_screen_recorder -y
rm "$HOME/Scripts/save_replay.sh"
rm "$HOME/Scripts/stop_replay.sh"
rm "$HOME/Scripts/start_replay.sh"
rmdir "$HOME/Scripts" 2> /dev/null
rm "$HOME/.config/autostart/start_replay.sh.desktop"
```

#### Uninstall NoiseTorch
```
rm ~/.local/bin/noisetorch
rm ~/.local/share/applications/noisetorch.desktop
rm ~/.local/share/icons/hicolor/256x256/apps/noisetorch.png 
```
