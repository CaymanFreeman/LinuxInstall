#!bin/bash

killall -SIGUSR1 gpu-screen-recorder && sleep 0.5 && notify-send -t 1500 -u critical -- "GPU Screen Recorder" "Replay saved"
