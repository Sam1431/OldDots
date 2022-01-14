{ pkgs, lib, config, ... }:

{
    programs.mako = {
        enable = true;
        width = 300;
        margin = "6";
        padding = "10";
        borderSize = 0;
        borderRadius = 0;
        defaultTimeout = 5000;
        borderColor = "#44484a";
        backgroundColor = "#141617";
        anchor = "bottom-right";
        layer = "overlay";
        font = "Iosevka Nerd Font 11";
      };
  }
