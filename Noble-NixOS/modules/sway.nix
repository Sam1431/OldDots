{ config, lib, pkgs, inputs, ... }:

{

  ## DESKTOP SETUP

   fonts.fonts = with pkgs; [
     (nerdfonts.override { fonts = [ "Iosevka" "Cousine" "Hack" "JetBrainsMono" ]; })
   ];


   programs = {
   dconf.enable = true;
   sway = {
     enable = true;
     wrapperFeatures.gtk = true; # so that gtk works properly
     extraPackages = with pkgs; [
       swaylock
       swayidle
       glpaper
       wl-clipboard
       mako
       wpgtk
      ];
   };
     xwayland.enable = true;
  };
}
