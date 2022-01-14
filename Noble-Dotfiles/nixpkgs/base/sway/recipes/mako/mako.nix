{ pkgs, lib, config, ... }:

{
    programs.mako = {
        enable = true;
        width = 400;
        margin = "5";
        padding = "10";
        borderSize = 2;
        borderRadius = 4;
        defaultTimeout = 5000;
        borderColor = "#353a45";
        backgroundColor = "#282c34";
        anchor = "bottom-right";
        layer = "overlay";
        font = "Iosevka Nerd Font 11";
      };
  }
