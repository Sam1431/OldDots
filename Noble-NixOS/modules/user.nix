{ config, lib, pkgs, ... }:

{

## USER CONFIG

  users.users.shiva = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "users" "audio" "sudo" ];
  };
}
