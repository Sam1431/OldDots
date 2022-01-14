{ pkgs, ... }:

''


USAGE=$(cat <<ENDSTR
Commands:

  gix switch      - rebuild NixOS
  gix edit        - edit System Config
  gix flake-edit  - edit Flake config
  gix home-dir    - go to Home-Manager Dir
  gix up-flake    - update root flake
  gix gc          - clean nix store home
  gix gc-root     - clean nix store root
  gix gcd         - clean all gen nix store in home
  gix gcd-root    - clean all gen nix store in root
  gix switch-home - rebuild Home-Manager
  gix upgrade     - Upgrade NixOS
  gix rec-lock    - recreate system flake lock [ not available ]
  gix install     - install package
  gix pull        - update repo
  gix env         - nix-env
  gix remove      - remove packages
  gix snap        - take a file snapshot of current home-manager role/profile
 
ENDSTR
)

sudo=$(which sudo 2> /dev/null|cut -d ':' -f 2)
if [ $(id -u) -eq 0 ]; then sudo=""; fi

command="$1"
shift
case "$command" in

 help|--help)
         echo $VERSION
  echo "$USAGE"
  ;;

#...........................................
env)
nix-env
;;

install)
nix-env -iA nixos.$@
;;

remove)
nix-env -e $@
;;

pull)
nix-channel --update
;;

snap)
snapshot_wrap
;;

switch)
$sudo nixos-rebuild switch --flake /etc/nixos
;;

edit)
$sudo vim /etc/nixos/config.nix
;;

home-dir)
broot /home/shiva/.config/nixpkgs
;;

flake-edit)
$sudo vim /etc/nixos/flake.nix
;;

flake-up)
$sudo nix flake update /etc/nixos
;;

gc)
nix-collect-garbage
;;

gcd)
nix-collect-garbage
;;

gc-root)
$sudo nix-collect-garbage
;;

gcd-root)
$sudo nix-collect-garbage -d
;;

home-switch)
home-manager switch
;;

upgrade)
$sudo nixos-rebuild switch --upgrade --flake /etc/nixos
;;

manuals)
macho
;;
#...........................................
 *)
  [ -z $command ] || echo Unknown command: $command
  echo "$USAGE"
  ;;
esac

''
