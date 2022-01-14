{ config, pkgs, hostName, lib, ...}:

{
  wayland.windowManager.sway = {
    enable = true;

    extraConfig = ''
         for_window [app_id="^launcher$"] floating enable, sticky enable, resize set 28 ppt 70 ppt, border pixel 6
         for_window [app_id="^file$"] floating enable, sticky enable, resize set 60 ppt 50 ppt, border pixel 6,
         for_window [app_id="^imv$"] floating enable, sticky enable, resize set 56 ppt 109 ppt, border pixel 0, opacity 0.9
    '';

    config = {
       down = "j";
       up = "k";
       left = "h";
       right = "l";
       modifier = "Mod4";

       startup = [{ command = "mpd"; }
                  { command = "sh ~/.config/swayrc"; }
                 ];

       bars = [{ command = "none"; }];
       colors = {
         focused = {
           background = "#609ce0";
           border = "#609ce0";
           text = "#3a3a3a";
           indicator = "#778564";
           childBorder = "#abb2bf";
      };
         focusedInactive = {
           background = "#1b1e23";
           border = "#1b1e23";
           text = "#eceff4";
           indicator = "#1b1e23";
           childBorder = "#1b1e23";
      };
         placeholder = {
           background = "#000000";
           border = "#0c0c0c";
           text = "#eceff4";
           indicator = "#000000";
           childBorder = "#1b1e23";
      };
         urgent = {
           background = "#cb7073";
           border = "#cb7073";
           text = "#eceff4";
           indicator = "#cb7073";
           childBorder = "#1b1e23";
      };
         unfocused = {
           background = "#1b1e23";
           border = "#1b1e23";
           text = "#eceff4";
           indicator = "#1b1e23";
           childBorder = "#1b1e23";
      };

    };
           window.border = 1;
           focus.followMouse = true;
#           fonts = [ "Iosevka 12" ];
           gaps = {
             outer = 0;
             inner = 8;
             smartBorders = "on";
             smartGaps = true;
           };
      keybindings = let
        mod = "Mod4";
        term = "foot";
        menu = "exec foot --class=launcher sh ~/launch";
      in lib.mkOptionDefault {
                 "${mod}+Shift+Return" = "exec foot";
                 "${mod}+Control+Return" = "exec kitty";
                 "${mod}+q" = "kill";
                 "${mod}+Return" = "exec foot --app-id=launcher ~/.config/nixpkgs/machine/bin/launch";
         #        "${mod}+Return" = "exec wofi -c ~/.config/wofi/config --show drun";
                 "${mod}+p" = "exec sh ~/.config/wofer/wofer wofi --dmenu";
                 "${mod}+Control+Alt+l" = "exec swaylock -C ~/.config/nixpkgs/roles/radon/recipes/swaylock/lock.conf";
                 "${mod}+Control+Down" = "resize grow height 10 px";
                # "Alt+x" = "exec wofi --show drun";
                 "${mod}+Control+Left" = "resize shrink width 10 px";
                 "${mod}+d" = "exec foot --app-id=file ranger";
                 "${mod}+Control+Right" = "resize grow width 10 px";
                 "${mod}+Control+Up" = "resize shrink height 10 px";
                 "${mod}+Control+h" = "resize shrink width 30 px";
                 "${mod}+Control+j" = "resize grow height 20 px";
                 "${mod}+Control+k" = "resize shrink height 20 px";
                 "${mod}+Control+l" = "resize grow width 30 px";
                 "${mod}+o" = "mode open";
};
      modes = {
        open  = {
                   r = "exec wf-recorder";
                   x = "exec pkill wf-recorder";
                   Escape = "mode default";
                   Left = "resize shrink width 10 px";
                 };
               };
             };
           };
}
