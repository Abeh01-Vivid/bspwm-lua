# bspwm on Salix Linux — Install Guide

Full setup for bspwm + sxhkd + rofi + picom on a Salix Linux install,
tuned for an Intel Ironlake iGPU (X11-only, xrender compositing, no glx/vulkan).

---

## 1. Package installation

Salix is Slackware-based and uses `slapt-get` for its own repos. Not all of
these packages exist in core Salix/Slackware repos — check first, and fall
back to SlackBuilds (via `sbopkg`) for anything missing.

Check what's available:

```sh
slapt-get --search bspwm
slapt-get --search sxhkd
slapt-get --search picom
slapt-get --search rofi
slapt-get --search dunst
```

Install whatever slapt-get finds:

```sh
su -
slapt-get --install bspwm sxhkd picom rofi dunst feh xautolock slock
```

### For anything not in the repos (likely bspwm, sxhkd, picom, rofi)

Salix/Slackware users typically build these from SlackBuilds.org via `sbopkg`:

```sh
su -
slapt-get --install sbopkg     # if not already installed
sbopkg -r                      # sync SlackBuilds repo
sbopkg -i bspwm
sbopkg -i sxhkd
sbopkg -i picom
sbopkg -i rofi
```

`sbopkg` will walk you through downloading sources, building, and installing
`.txz` packages via `installpkg`. Some of these (bspwm, sxhkd) may need
`xcb-util`, `xcb-util-wm`, `xcb-util-keysyms`, and `libxcb` — SlackBuilds
handles dependency resolution poorly, so build in this order if you hit
missing-dependency errors:

```
libxcb -> xcb-util -> xcb-util-wm -> xcb-util-keysyms -> xcb-util-cursor -> sxhkd -> bspwm
```

### Fonts and icons

```sh
sbopkg -i nerd-fonts-jetbrains-mono   # or manually install to ~/.local/share/fonts
slapt-get --install papirus-icon-theme
```

If Papirus isn't packaged, grab it manually:

```sh
git clone https://github.com/PapirusDevelopmentTeam/papirus-icon-theme.git
cd papirus-icon-theme
su -
./install.sh
```

### Clipboard manager

`clipmenud` isn't in most repos — build from source:

```sh
git clone https://github.com/cdown/clipnotify.git
git clone https://github.com/cdown/clipmenu.git
```
Both are small POSIX shell scripts — copy `clipmenu`/`clipmenud`/`clipnotify`
into `/usr/local/bin` and `chmod +x` them.

---

## 2. File placement

Copy the configs from this conversation to their proper locations:

```sh
mkdir -p ~/.config/bspwm ~/.config/sxhkd ~/.config/rofi ~/.config/picom

cp bspwmrc.lua   ~/.config/bspwm/bspwmrc
cp sxhkdrc       ~/.config/sxhkd/sxhkdrc
cp config.rasi   ~/.config/rofi/config.rasi
cp picom.conf    ~/.config/picom/picom.conf
cp xinitrc       ~/.xinitrc

chmod +x ~/.config/bspwm/bspwmrc
chmod +x ~/.xinitrc
```

Make sure the `bspwmrc` shebang line matches your installed Lua binary name
(`lua`, `lua5.3`, `lua5.4`, etc. — check with `which lua5.4` or similar).

---

## 3. Wallpaper

The `.xinitrc` expects a wallpaper at `~/Pictures/wallpaper.jpg`. Either drop
one there or edit the `feh --bg-fill` line to point somewhere else.

---

## 4. Starting the session

If you don't have a display/login manager installed, start X manually from
a TTY:

```sh
startx
```

This will read `~/.xinitrc`, launch the daemons (sxhkd, picom, dunst,
slstatus, etc.), and finally `exec bspwm`.

If you do want a graphical login manager, Salix typically ships with
`slim` or you can install `lightdm` via slapt-get/sbopkg — either will
pick up a `bspwm.desktop` entry in `/usr/share/xsessions/` if you create one:

```sh
su -
cat > /usr/share/xsessions/bspwm.desktop << 'EOF'
[Desktop Entry]
Name=bspwm
Comment=Binary space partitioning window manager
Exec=bspwm
Type=Application
EOF
```

---

## 5. What you get

| Component  | Role                                              |
|------------|----------------------------------------------------|
| `bspwm`    | Tiling window manager (binary space partitioning)   |
| `sxhkd`    | Hotkey daemon — dwm-style keybinds, mapped to `bspc` |
| `rofi`     | App launcher (`super+p`) + window switcher (`super+Tab`), Catppuccin Mocha themed |
| `picom`    | Compositor — xrender backend only (Ironlake iGPU has no glx/vulkan) |
| `dunst`    | Notification daemon |
| `slstatus` | Status bar info feed |
| `feh`      | Wallpaper setter |
| `clipmenud`| Clipboard history via rofi |
| `xautolock`/`slock` | Idle detection + screen lock |

Desktops are labeled with kanji (一–九) to match your existing dwm/other WM
setups, and keybinds in `sxhkdrc` mirror your dwm-flexipatch muscle memory
as closely as bspwm's tiling model allows (see the caveats noted earlier
about master-area resizing not translating 1:1).

---

## 6. Known gaps / things to revisit

- **No multi-monitor binds** — intentionally left out per your setup.
- **`bspc node @focused -z ...` resize binds** are an approximation of dwm's
  master/stack resize, not identical behavior.
- **Corner-radius/blur in picom.conf** require a patched picom fork
  (e.g. `picom-jonaburg` or `picom-ibhagwan`) — if Salix/SBo only has vanilla
  picom, remove the `corner-radius`, `rounded-corners-exclude`, and `blur`
  blocks or the config will error out.
- **GTK/Qt theming** (`Catppuccin-Mocha` referenced in `.xinitrc`) assumes
  you've separately installed the GTK theme — let me know if you want that
  covered too.
