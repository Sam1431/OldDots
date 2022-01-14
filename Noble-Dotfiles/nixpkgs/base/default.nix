{ config, pkgs, hostName, lib, ...}:
{
  imports = [ ./sway/options.nix
              ./user/home/environment.nix
            ];
}
