{ config, lib, pkgs, ... }:

{

##-------------------------------------------------------------------------
##-------------------------------- BOOT -----------------------------------
##-------------------------------------------------------------------------

  # Use the GRUB 2 boot loader.

  boot.loader.grub.splashImage = ./images/gnu.png;
  boot.loader.grub.gfxmodeBios = "1366x768";
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.loader.grub.device = "/dev/sda";
  boot.kernelModules = [ "tcp_bbr" ];

##-------------------------------------------------------------------------
##------------------------------ SYSTEM -----------------------------------
##-------------------------------------------------------------------------

  system.stateVersion = "21.11";
  xdg.portal.enable = true;
  xdg.portal.wlr = {
   enable = true;
  };

  nixpkgs.system = "x86_64-linux";
  qt5 = {
    enable = true;
    platformTheme = "gtk2";
    style = "gtk2";
  };

  powerManagement.enable = true;
  powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";
  hardware.cpu.intel.updateMicrocode = true;

##-------------------------------------------------------------------------
##---------------------------- NIX FLAKES ---------------------------------
##-------------------------------------------------------------------------

  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
   };

##------------------------------------------------------------------------
##----------- TO PREVENT COMPILATION OF ADDED OVERLAYS --------------------
##-------------------------------------------------------------------------

  nix = {
    binaryCaches = [
      "https://nix-community.cachix.org"
    ];

    binaryCachePublicKeys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];

};

##------------------------- NIX CONFIG ENDING -----------------------------

}
