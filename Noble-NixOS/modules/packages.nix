{ config, lib, pkgs, ... }:

 let
    snapshot_wrapper = pkgs.writeShellScriptBin "snapshot_wrap"
    (import ./bin/snap.nix { inherit pkgs; });
    
    nix_wrapper = pkgs.writeScriptBin "gix"
    (import ./bin/gix.nix { inherit pkgs; });
 in
{

  ## PACKAGES
  environment.systemPackages = with pkgs; [
    unzip
    git
    wget
    firefox-wayland
    connman-gtk
    gtkmm3
    grim
    papirus-icon-theme
    gtk-layer-shell
    cached-nix-shell
  
    lynis
    ossec
    chkrootkit
    aide

    snapshot_wrapper
    nix_wrapper
  ];
}
