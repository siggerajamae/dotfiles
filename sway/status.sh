#!/bin/sh

# Date and time
date_formatted=$(date "+%a %F %H:%M")

# Append date and time to the status line
status_line="$date_formatted"

# If battery status file exists
if [ -f /sys/class/power_supply/BAT0/status ]; then
    # Get the battery status
    battery_status=$(cat /sys/class/power_supply/BAT0/status)

    # Initialize battery icon
    battery_icon="󱉝"

    # Get the battery level
    battery_level=$(cat /sys/class/power_supply/BAT0/capacity)

    # Battery icon based on battery status
    if [ "$battery_status" = "Full" ]; then 
        battery_icon="󰁹"
    elif [ "$battery_status" = "Discharging" ]; then
        if [ "$battery_level" -ge 90 ]; then
            battery_icon="󰂂"
        elif [ "$battery_level" -ge 80 ]; then
            battery_icon="󰂁"
        elif [ "$battery_level" -ge 70 ]; then
            battery_icon="󰂀"
        elif [ "$battery_level" -ge 60 ]; then
            battery_icon="󰁿"
        elif [ "$battery_level" -ge 50 ]; then
            battery_icon="󰁾"
        elif [ "$battery_level" -ge 40 ]; then
            battery_icon="󰁽"
        elif [ "$battery_level" -ge 30 ]; then
            battery_icon="󰁼"
        elif [ "$battery_level" -ge 20 ]; then
            battery_icon="󰁻"
        else
            battery_icon="󰂃"
        fi
    elif [ "$battery_status" = "Charging" ]; then
        battery_icon="󰂄"
    elif [ "$battery_status" = "Not charging" ]; then
        battery_icon="󱉝"
    elif [ "$battery_status" = "Unknown" ]; then
        battery_icon="󰂑"
    fi
    
    # Append battery info to the status line
    battery_status="$battery_icon $battery_level%"
    status_line="$battery_status  $status_line"
fi

# Get the current audio volume level and mute status
audio_status=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)
audio_level=$(echo "$audio_status" | awk '{print $2 * 100}')
audio_muted=$(echo "$audio_status" | grep -o MUTED)

# Icon based on mute status
if [ "$audio_muted" = "MUTED" ]; then
    audio_icon="󰖁"
else
    audio_icon="󰕾"
fi

# Append audio info to the status line
audio_status="$audio_icon ${audio_level}%"
status_line="$audio_status  $status_line"

# Get the current microphone volume level and mute status
mic_status=$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@)
mic_level=$(echo "$mic_status" | awk '{print $2 * 100}')
mic_muted=$(echo "$mic_status" | grep -o MUTED)

# Icon based on mute status
if [ "$mic_muted" = "MUTED" ]; then
    mic_icon="󰍭"
else
    mic_icon="󰍬"
fi

# Append microphone info to the status line
mic_status="$mic_icon ${mic_level}%"
status_line="$mic_status  $status_line"

# Memory usage
memory_usage=$(free -m | awk 'NR==2{printf "%.0f%%\n", $3 * 100 / $2 }')

# Append memory usage to the status line
memory_status="󰍛 $memory_usage"
status_line="$memory_status  $status_line"

# Output the status line
echo "$status_line"
