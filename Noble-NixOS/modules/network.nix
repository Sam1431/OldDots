{ config, lib, pkgs, ... }:

{

## NETWORKING

  networking.hostName = "nixos";
  networking.useDHCP = false;
  networking.interfaces.eno1.useDHCP = true;
  networking.interfaces.wlp2s0.useDHCP = true;
  services.connman.enable = true;
  networking.wireless.enable = true;
  networking.wireless.userControlled.enable = true;
  networking.wireless.interfaces = [ "wlp2s0" ];

}

