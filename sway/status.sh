#! /bin/sh

date_formatted=$(date '+%a %F %H:%M')
battery_status=$(cat /sys/class/power_supply/BAT0/status)
if [ "$battery_status" != "Full" ]; then 
	battery_level=$(cat /sys/class/power_supply/BAT0/capacity)
	battery_status="$battery_level%, $battery_status"
fi
echo Battery: $battery_status \| $date_formatted
