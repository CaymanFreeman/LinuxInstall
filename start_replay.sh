#!bin/bash

# Run `flatpak run --command=gpu-screen-recorder com.dec05eba.gpu_screen_recorder --help` for a description of the settings
VIDEO_PATH="$HOME/Videos"
ORGANIZE_IN_DATED_FOLDERS=no
RECORD_CURSOR=yes
REPLAY_LENGTH_SECONDS=90
CONTAINER_FORMAT=mp4
VIDEO_CODEC=hevc
QUALITY=very_high
COLOR_RANGE=limited
FRAME_RATE=60
FRAME_RATE_MODE=vfr
KEY_FRAME_INTERVAL_SECONDS=1.0
AUDIO_CODEC=opus
AUDIO_BITRATE=128000

# Run `xrandr` to see your current monitor setup
#WINDOW_ID=DP-2 # This will record the monitor in the third display port slot
#WINDOW_ID=HDMI-0 # This will record the monitor in the first HDMI slot
#WINDOW_ID=screen # This will record every monitor at once
WINDOW_ID=focused # This will record the current focused application (not the monitor, just the application)
VIDEO_AREA=1920x1080 # Required if the window ID is `focused`, add `-s $VIDEO_AREA` to the command flags if using, remove otherwise

# Run `pactl list short sources && pactl list short sinks` to see your audio inputs/outputs
#AUDIO_TRACK="alsa_output.usb-Logitech_PRO_X_000000000000-00.analog-stereo.monitor" # This is an example of an output (Logitech G Pro X Headphones via USB)
#AUDIO_TRACK="alsa_input.usb-Logitech_PRO_X_000000000000-00.mono-fallback" # This is an example of an input (Logitech G Pro X Microphone via USB)
#AUDIO_TRACK="alsa_output.usb-Logitech_PRO_X_000000000000-00.analog-stereo.monitor|alsa_input.usb-Logitech_PRO_X_000000000000-00.mono-fallback" # This is an example of a merged input/output (Logitech G Pro X Headset via USB)
#AUDIO_TRACK="$(pactl get-default-source)" # This is your default input
#AUDIO_TRACK="$(pactl get-default-sink).monitor" # This is your default output
AUDIO_TRACK="$(pactl get-default-sink).monitor|$(pactl get-default-source)" # This is your merged default input and output

(
    sleep 1 # Increase this number if a "Replay failed to start" notification is being sent when it in fact does start
    if pgrep -f "gpu-screen-recorder" > /dev/null; then
        notify-send -t 1500 -u normal -- "GPU Screen Recorder" "Replay started"
    else
        notify-send -t 1500 -u critical -- "GPU Screen Recorder" "Replay failed to start"
    fi
) &

mkdir -p "$VIDEO_PATH" && flatpak run --command=gpu-screen-recorder com.dec05eba.gpu_screen_recorder -w $WINDOW_ID -s $VIDEO_AREA -mf $ORGANIZE_IN_DATED_FOLDERS -cursor $RECORD_CURSOR -c $CONTAINER_FORMAT -f $FRAME_RATE -fm $FRAME_RATE_MODE -keyint $KEY_FRAME_INTERVAL_SECONDS -q $QUALITY -cr $COLOR_RANGE -r $REPLAY_LENGTH_SECONDS -k $VIDEO_CODEC -ac $AUDIO_CODEC -ab $AUDIO_BITRATE -a $AUDIO_TRACK -o "$VIDEO_PATH"; notify-send -t 1500 -u normal -- "GPU Screen Recorder" "Replay stopped"
