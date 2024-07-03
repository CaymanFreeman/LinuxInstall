## Built For Pop! OS (22.04 LTS)

### Get Main Script:
```
wget https://raw.githubusercontent.com/CaymanFreeman/LinuxInstall/main/install.sh -O install.sh
```

### Auto-Run Main Script:
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
```
sh "$HOME/Scripts/stop_replay.sh"
flatpak remove com.dec05eba.gpu_screen_recorder -y
rm "$HOME/Scripts/save_replay.sh"
rm "$HOME/Scripts/stop_replay.sh"
rm "$HOME/Scripts/start_replay.sh"
rmdir "$HOME/Scripts" 2> /dev/null
rm "$HOME/.config/autostart/start_replay.sh.desktop"
# Keyboard shortcuts can be removed in the Settings application
```

---

### Get NoiseTorch Install Script:
```
wget https://raw.githubusercontent.com/CaymanFreeman/LinuxInstall/main/noisetorch_install.sh -O noisetorch_install.sh
```

### Auto-Run NoiseTorch Install Script:
```
wget https://raw.githubusercontent.com/CaymanFreeman/LinuxInstall/main/noisetorch_install.sh -O noisetorch_install.sh && chmod +x noisetorch_install.sh && ./noisetorch_install.sh && sudo rm noisetorch_install.sh
```

#### Uninstall NoiseTorch
```
rm ~/.local/bin/noisetorch
rm ~/.local/share/applications/noisetorch.desktop
rm ~/.local/share/icons/hicolor/256x256/apps/noisetorch.png 
```
