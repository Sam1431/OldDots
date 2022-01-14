{ config, pkgs, hostName, lib, ...}:

{
  wayland.windowManager.sway = {
    enable = true;
      config = {
       down = "j";
       up = "k";
       left = "h";
       right = "l";
       modifier = "Mod4";

       startup = [{ command = "swaybg --mode fill --image ~/.config/nixpkgs/machine/wallpaper/solid/solid.png"; }
                  { command = "mpd"; }
                 # { command = "foot -s"; }
                 ];

       bars = [{ command = "waybar"; }];
       colors = {
         focused = {
           background = "#9da98d";
           border = "#9da98d";
           text = "#3a3a3a";
           indicator = "#778564";
           childBorder = "#757980";
      };
         focusedInactive = {
           background = "#2e3440";
           border = "#2e3440";
           text = "#eceff4";
           indicator = "#2e3440";
           childBorder = "#282a2e";
      };
         placeholder = {
           background = "#000000";
           border = "#0c0c0c";
           text = "#eceff4";
           indicator = "#000000";
           childBorder = "#282a2e";
      };
         urgent = {
           background = "#cb7073";
           border = "#cb7073";
           text = "#eceff4";
           indicator = "#cb7073";
           childBorder = "#282a2e";
      };
         unfocused = {
           background = "#2e3440";
           border = "#2e3440";
           text = "#eceff4";
           indicator = "#2e3440";
           childBorder = "#282a2e";
      };

    };
           window.border = 2;
           focus.followMouse = true;
#           fonts = [ "Iosevka 12" ];
           gaps = {
             outer = 5;
             inner = 5;
             smartBorders = "off";
             smartGaps = false;
           };
      keybindings = let
        mod = "Mod4"; 
      in lib.mkOptionDefault {
                 "${mod}+Shift+Return" = "exec kitty";
                 "${mod}+q" = "kill";
                 "${mod}+Return" = "exec wofi -c ~/.config/wofi/config --show drun";
                 "${mod}+p" = "exec sh ~/.config/wofer/wofer wofi --dmenu";
                 "${mod}+Control+Alt+l" = "exec swaylock -C ~/.config/nixpkgs/roles/radon/recipes/swaylock/lock.conf";
                 "${mod}+Control+Down" = "resize grow height 10 px";
                 "Alt+x" = "exec wofi --show drun";
                 "${mod}+Control+Left" = "resize shrink width 10 px";
                 "Control+x" = "mode control";
                 "${mod}+Control+Right" = "resize grow width 10 px";
                 "${mod}+Control+Up" = "resize shrink height 10 px";
                 "${mod}+Control+h" = "resize shrink width 30 px";
                 "${mod}+Control+j" = "resize grow height 20 px";
                 "${mod}+Control+k" = "resize shrink height 20 px";
                 "${mod}+Control+l" = "resize grow width 30 px";
};
      modes = {
        control = {
                   d = "exec sh ~/.config/wofer/wofer wofi --dmenu";
                   Escape = "mode default";
                   Left = "resize shrink width 10 px";
                 };
               };
             };
           };
}
