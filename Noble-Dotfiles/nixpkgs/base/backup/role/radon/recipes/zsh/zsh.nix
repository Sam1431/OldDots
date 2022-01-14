{ config, pkgs, lib, ... }:

{
  programs.zsh = { 
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    shellAliases = import ./alias.nix;
    autocd =true;
    dotDir = ".config/zsh";
    oh-my-zsh = {
       enable = true;
       plugins = [ "themes" ];
       theme = "alanpeabody";
     };
  };
}
