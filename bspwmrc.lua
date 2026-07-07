#!/usr/bin/env lua

-- Basic bspwmrc for bspwm, written in Lua
-- Place at ~/.config/bspwm/bspwmrc and chmod +x it

local function bspc(args)
    os.execute("bspc " .. args)
end

local function spawn(cmd)
    os.execute(cmd .. " &")
end

-- Monitors / desktops (kanji labels, matching your dwm setup)
bspc("monitor -d 一 二 三 四 五 六 七 八 九")

-- Core config
bspc("config border_width         2")
bspc("config window_gap           8")

bspc("config split_ratio          0.52")
bspc("config borderless_monocle   true")
bspc("config gapless_monocle      true")

bspc("config focus_follows_pointer true")

-- Catppuccin Mocha colors
bspc("config normal_border_color   '#45475a'")  -- Surface1
bspc("config active_border_color   '#585b70'")  -- Surface2
bspc("config focused_border_color  '#cba6f7'")  -- Mauve
bspc("config presel_feedback_color '#89b4fa'")  -- Blue

-- Window rules
bspc("rule -a Gimp desktop='^8' state=floating follow=on")
bspc("rule -a firefox desktop='^2'")

-- Autostart (adjust to what you actually have installed)
spawn("sxhkd")
spawn("picom --backend xrender")  -- Ironlake iGPU: xrender only, no glx/vulkan
spawn("slstatus")
spawn("feh --bg-fill ~/Pictures/wallpaper.jpg")
