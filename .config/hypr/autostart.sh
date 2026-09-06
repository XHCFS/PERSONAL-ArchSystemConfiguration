#!/bin/sh
hyprpaper &
waybar &
hypridle &
gammastep -c ~/.config/gammastep/gammastep.conf -v &
QT_QPA_PLATFORM=xcb copyq &
fcitx5 &
