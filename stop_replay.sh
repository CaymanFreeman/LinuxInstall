#!bin/bash

killall -SIGINT gpu-screen-recorder && sleep 0.5 && notify-send -t 1500 -u normal -- "GPU Screen Recorder" "Replay stopped"
