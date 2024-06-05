#! /bin/sh

if swaymsg -t get_outputs | grep -q "\bDP-1\b"; then
	swaymsg output eDP-1 disable
else 
	swaymsg output eDP-1 enable
fi
