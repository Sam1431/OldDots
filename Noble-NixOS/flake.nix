{
  description = "LOL CONFIG";

  inputs ={
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager.url = "github:rycee/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
};

  outputs = { self, nixpkgs, home-manager, ... }:
  let
   system = "x86_64-linux";   
   pkgs = import nixpkgs {
       inherit system;
       config = { allowUnfree = true; };
   };


 lib = nixpkgs.lib;

  in {     
  homeManagerConfigurations = {
      shiva = home-manager.lib.homeManagerConfiguration {
        inherit system pkgs;
        username = "shiva";
        homeDirectory = "/home/shiva";
      };
    };

    nixosConfigurations = {
      nixos = lib.nixosSystem {
        inherit system;

 modules = [ 
 ./config.nix
 ];
      };
    };
  };
}
