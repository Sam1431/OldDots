{ pkgs, ... }:

''

USAGE=$(cat <<ENDSTR
Usage - 
    
  snap [ role name ] <name-of-snapshots>   -  Create new snap shot of a role / profile
  snap rm-<role name> snapshot             -  Remove a created snap shot
  snap rm-all                              -  Remove all snapshot

Roles Available - 
   
   helium   - xmonad - horizon
   neon     - xmonad - gruvbox
   argon    - WIP
   krypton  - WIP
   xenon    - emacs-exwm ( custom )
   radon    - sway - onedark 


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

helium | -h)
$sudo cp /home/shiva/.config/nixpkgs/roles/helium -r /etc/nixos/snapshots/helium/
;;
neon | -n)
$sudo cp /home/shiva/.config/nixpkgs/roles/neon -r /etc/nixos/snapshots/neon/
;;
argon | -a)
$sudo cp /home/shiva/.config/nixpkgs/roles/argon -r /etc/nixos/snapshots/argon/
;;
krypton | -k)
$sudo cp /home/shiva/.config/nixpkgs/roles/krypton -r /etc/nixos/snapshots/krypton/
;;
xenon | -x)
$sudo cp /home/shiva/.config/nixpkgs/roles/xenon -r /etc/nixos/snapshots/xenon/
;;
radon | -r | current)
$sudo cp /home/shiva/.config/nixpkgs/roles/radon -r /etc/nixos/snapshots/radon/
;;


rm-helium)
$sudo rm -r /etc/nixos/snapshots/helium/*
;;
rm-neon)
$sudo rm -r /etc/nixos/snapshots/neon/*
;;
rm-argon)
$sudo rm -r /etc/nixos/snapshots/argon/*
;;
rm-krypton)
$sudo rm -r /etc/nixos/snapshots/krypton/*
;;
rm-xenon)
$sudo rm -r /etc/nixos/snapshots/xenon/*
;;
rm-radon)
$sudo rm -r /etc/nixos/snapshots/radon/*
;;


rm-all)
$sudo rm -r /etc/nixos/snapshots/radon/* \
rm -r /etc/nixos/snapshots/xenon/* \
rm -r /etc/nixos/snapshots/krypton/* \
rm -r /etc/nixos/snapshots/argon/* \
rm -r /etc/nixos/snapshots/neon/* \
rm -r /etc/nixos/snapshots/helium/*
;;


#...........................................
 *)
  [ -z $command ] || echo Unknown command: $command
  echo "$USAGE"
  ;;
esac

''
