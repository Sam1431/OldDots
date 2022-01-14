{ config, lib, pkgs, ... }:

let
gnu = import ./modules/variables.nix;

  in
{
  imports = [
    gnu.module.hardware-uuid
    gnu.module.network
    gnu.module.system
    gnu.module.user
    gnu.module.settings
    gnu.module.services
    gnu.module.security
    gnu.module.blacklist
    gnu.module.packages
    gnu.module.pipewire
    gnu.module.bluetooth
    gnu.module.sway
  ];
}
