#!/bin/sh
#
# ~/.xinitrc - launches bspwm session with supporting daemons
# For your Acer Veriton X498G (Ironlake iGPU: X11-only, xrender compositing)
#

# --- environment ---
export XDG_CURRENT_DESKTOP=bspwm
export GTK_THEME=Catppuccin-Mocha
export QT_QPA_PLATFORMTHEME=qt5ct

# --- merge Xresources if you have any ---
[ -f ~/.Xresources ] && xrdb -merge -I$HOME ~/.Xresources

# --- keyboard/mouse settings ---
setxkbmap -option caps:escape   # example: caps as escape, drop if unwanted
xset r rate 300 50              # faster key repeat

# --- core daemons ---
sxhkd &
picom --backend xrender --config ~/.config/picom/picom.conf &
dunst &                          # notifications
nm-applet &                      # network tray (if using NetworkManager)

# --- bar / status ---
slstatus &

# --- wallpaper ---
feh --bg-fill ~/Pictures/wallpaper.jpg &

# --- polkit agent (needed for GUI privilege prompts) ---
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &

# --- clipboard manager (optional but common) ---
clipmenud &

# --- autolock / idle (optional) ---
xautolock -time 15 -locker "slock" &

# --- finally, exec bspwm as the session ---
exec bspwm
