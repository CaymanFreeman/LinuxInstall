## Built For Pop! OS (22.04 LTS)

#### Get Install Script:
```
wget https://raw.githubusercontent.com/CaymanFreeman/LinuxInstall/main/install.sh -O install.sh
```

#### Auto-Run Install Script:
```
wget https://raw.githubusercontent.com/CaymanFreeman/LinuxInstall/main/install.sh -O install.sh && chmod +x install.sh && ./install.sh && sudo rm install.sh
```

---

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
[ -f "/usr/share/applications/nemo.desktop.disabled" ] && sudo mv "/usr/share/applications/nemo.desktop.disabled" "/usr/share/applications/nemo.desktop"
[ -f "/usr/share/applications/nautilus-autorun-software.desktop.disabled" ] && sudo mv "/usr/share/applications/nautilus-autorun-software.desktop.disabled" "/usr/share/applications/nautilus-autorun-software.desktop"
[ -f "/usr/share/applications/org.gnome.Nautilus.desktop.disabled" ] && sudo mv "/usr/share/applications/org.gnome.Nautilus.desktop.disabled" "/usr/share/applications/org.gnome.Nautilus.desktop"
gsettings set org.gnome.desktop.background show-desktop-icons true
gsettings set org.nemo.desktop show-desktop-icons false
xdg-mime default org.gnome.Nautilus.desktop inode/directory application/x-gnome-saved-search
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

#### Uninstall ATLauncher
```
flatpak remove com.atlauncher.ATLauncher -y
```

#### Uninstall Minecraft Bedrock Launcher
```
flatpak remove io.mrarm.mcpelauncher -y
```

#### Uninstall ProtonUp-QT
```
flatpak remove net.davidotek.pupgui2 -y
```

#### Uninstall Brave Browser
```
flatpak remove com.brave.Browser -y
```

#### Uninstall GPU-Screen-Recorder
##### (Keyboard shortcuts can be removed in the Settings application)
```
sh "$HOME/Scripts/stop_replay.sh"
rm "$HOME/Scripts/save_replay.sh"
rm "$HOME/Scripts/stop_replay.sh"
rm "$HOME/Scripts/start_replay.sh"
rmdir "$HOME/Scripts" 2> /dev/null
rm "$HOME/.config/autostart/start_replay.sh.desktop"
flatpak remove com.dec05eba.gpu_screen_recorder -y
```

#### Uninstall NoiseTorch
```
rm ~/.local/bin/noisetorch
rm ~/.local/share/applications/noisetorch.desktop
rm ~/.local/share/icons/hicolor/256x256/apps/noisetorch.png 
```

---

#### OBS Settings
Output:
- Output Mode: **Advanced**
- Recording:
  - Type: **Custom Output (FFmpeg)**
  - File path or URL: **$HOME/Videos**
  - Generate File Name without Space: **True**
  - Container Format: **mov**
  - Video Bitrate: **24000 Kbps**
  - Video Encoder: **mpeg4 - MPEG-4 part 2**
  - Audio Bitrate: **300 Kbps**
  - Audio Encoder: **pcm_s16le - PCM signed 16-bit little-endian**

Hotkeys:
- Start Recording: **Control + Shift + F11**
- Stop Recording: **Control + Shift + F12**

Advanced:
- Overwrite if file exists: **True**

---

#### Steam Launcher Settings
Interface:
- Start Up Location: **Library**

Downloads:
- Schedule auto-updates: **True**
- Display download rates in bits per second: **False**

Compatibility:
- Enable Steam Play for all other titles: **True**
- Run other titles with: **Proton Experimental**

---

#### Brave Browser Settings
Customize Dashboard:
- Background Image:
  - Show Sponsored Images: **False**
- Brave Stats:
  - Show Brave Stats: **False**
- Top Sites:
  - Top Sites: **False**
- Cards:
  - Cards: **False**

Settings:
- Appearance:
  - Show Brave News button: **False**
  - Show Brave Rewards button: **False**
  - Show Brave Wallet button: **False**
  - Show Sidebar button: **False**
  - Use wide address bar: **True**
  - Always show full URLs: **True**
  - Show tab search button: **False**
  - Show sidebar: **Never**
  
- Leo:
  - Show Leo icon in the sidebar: **False**
  - Show Leo in the context menu on websites: **False**

  
- System:
  - Memory Saver: **True**
