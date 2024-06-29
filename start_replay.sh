#!bin/bash

VIDEO_PATH="$HOME/Videos"

mkdir -p "$VIDEO_PATH"
flatpak run --command=gpu-screen-recorder com.dec05eba.gpu_screen_recorder -w screen -f 60 -a "$(pactl get-default-sink).monitor|$(pactl get-default-source)" -c mkv -r 90 -k h265 -o "$VIDEO_PATH" && sleep 0.5 && notify-send -t 1500 -u critical -- "GPU Screen Recorder" "Replay started"
