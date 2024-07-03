LATEST_TAG=$(curl -s "https://api.github.com/repos/noisetorch/NoiseTorch/releases/latest" | grep 'tag_name' | cut -d\" -f4)
ASSET_NAME="NoiseTorch_x64_$LATEST_TAG.tgz"
DOWNLOAD_URL="https://github.com/noisetorch/NoiseTorch/releases/download/$LATEST_TAG/$ASSET_NAME"
cd "$HOME/Downloads" && curl -JLO $DOWNLOAD_URL && tar -C $HOME -h -xzf $ASSET_NAME && rm $ASSET_NAME && cd
gtk-update-icon-cache
sudo setcap 'CAP_SYS_RESOURCE=+ep' "$HOME/.local/bin/noisetorch"
