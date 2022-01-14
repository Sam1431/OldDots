{ config, lib, pkgs, ... }:

{
  services = {
     resolved = { 
        enable = true;
	dnssec = "true";
        fallbackDns =  [ "8.8.8.8" ];
      };

     tor.enable = true;
  #   emacs.enable = true;
  #   gnunet.enable = true;
  #  zeronet.install = true;
  };
}
