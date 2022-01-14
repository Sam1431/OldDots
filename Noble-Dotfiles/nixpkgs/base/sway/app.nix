# ~/.config/nixpkgs/user/app.nix
{ config, pkgs, lib, ... }:
let
    mode-sway = pkgs.writeShellScriptBin "swaymode"
    (import ../../machine/bin/swaymode.nix { inherit pkgs; });
in
{

home.packages = with pkgs; [

##### SYSTEM ##### ------------------
ranger
unzip
trash-cli
wpa_supplicant_gui
gnome.gnome-tweaks
element-desktop

##### SWAY ##### --------------------
swaybg
wf-recorder
swaylock
waybar
wofi
xdg-desktop-portal-wlr
mode-sway

##### UTILITIES ##### ---------------
pfetch
imv
cmst
mpv

##### NETWORK ##### -----------------
connman-notify
connman-ncurses
qutebrowser
firefox-wayland

##### MEDIA ##### -------------------
mpd
mpc_cli
pulsemixer

##### LIB ##### ---------------------
libnotify
libsForQt5.qtstyleplugins

##### MISC ##### --------------------
nordic
easytag
hakuneko

##### RUST ##### --------------------
broot
exa
tokei
procs
ripgrep
fd
dust
hyperfine
delta
cargo
bat
tealdeer

##### DEVELOP ##### -----------------
gcc
python3
fzf

##### APPLIST END ##### -------------

    ];
}
