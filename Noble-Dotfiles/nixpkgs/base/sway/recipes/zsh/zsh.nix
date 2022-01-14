{ config, pkgs, lib, ... }:

{
  programs.zoxide = { 
    enable = true;
    enableZshIntegration = true;
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = false;
     };
  };

  programs.zsh = { 
    enable = true;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    enableCompletion = true;
    shellAliases = import ./alias.nix;
    autocd = true;
    dotDir = ".config/zsh";
   #  oh-my-zsh = {
   #     enable = true;
   #     plugins = [ "themes" ];
   #     theme = "fishy";
   #   };
  };
}
