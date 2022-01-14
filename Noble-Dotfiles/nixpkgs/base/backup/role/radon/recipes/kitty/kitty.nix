{ pkgs, config, lib, ...}:
let
  clr = import ../../../../themes/dynamic/tomorrow.nix;
in
{
  programs.kitty = { 
    enable = true;
    font = { 
      name = "Iosevka Nerd Font";
      size = 11;
    };
   
      settings = {
 
        shell = "zsh";
        foreground = clr.foreground;
        background = clr.background;
        selection_foreground = "#2e3440";
        selection_background = "#d8dee9";
        url_color = "#0087BD";
        background_opacity = "1.0";
        cursor = "#abb2bf";
        window_padding_width = "12";
        enable_audio_bell = "no";


            color0 = clr.black;  # black
            color1 = clr.red;  # red
            color2 = clr.green;  # green
            color3 = clr.yellow;  # yellow
            color4 = clr.blue;  # blue
            color5 = clr.magenta;  # magenta
            color6 = clr.cyan;  # cyan
            color7 = clr.white;  # white
            
            color8 = clr.black-br;   # bright black
            color9 = clr.red-br;   # bright red
            color10 = clr.green-br;   # bright green
            color11 = clr.yellow-br;   # bright yellow
            color12 = clr.blue-br;   # bright blue
            color13 = clr.magenta-br;   # bright magenta
            color14 = clr.cyan-br;   # bright cyan
            color15 = clr.white-br;   # bright white


     #   # black
     #   color0 = "#3B4252";
     #   color8 = "#4C566A";
     #   # red
     #   color1 = "#BF616A";
     #   color9 = "#BF616A";
     #   # green
     #   color2 = "#A3BE8C";
     #   color10 = "#A3BE8C";
     #   # yellow
     #   color3 = "#EBCB8B";
     #   color11 = "#EBCB8B";
     #   # blue
     #   color4 = "#81A1C1";
     #   color12 = "#81A1C1";
     #   # magenta
     #   color5 = "#B48EAD";
     #   color13 = "#B48EAD";
     #   # cyan
     #   color6 = "#88C0D0";
     #   color14 = "#8FBCBB";
     #   # white
     #   color7 = "#E5E9F0";
     #   color15 = "#ECEFF4";
    };
  };
} 
