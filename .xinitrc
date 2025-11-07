#!/bin/bash
export $(dbus-launch --exit-with-session --exit-with-x11)

setxkbmap latam

xset r rate 200 50

/usr/libexec/polkit-gnome-authentication-agent-1 &

pipewire &

picom &

~/.local/scripts/dwmbar.sh &

feh --bg-fill ~/.local/share/wallpapers/lain.png &

exec dwm
