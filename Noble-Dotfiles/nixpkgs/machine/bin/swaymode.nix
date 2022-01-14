{ pkgs, ...}:
''
#!/bin/bash
USAGE=$(cat <<ENDSTR
Usage: swaymode <command> 
  Commands:

      1. windows /win   -  Windows 10 - like layout

      2. mac-os / mac   -  Mac OS like layout

      3. modular / mod  -  A custom layout made to fit my needs

      4. pop / cosmic   -  Pop OS Cosmic in SWAY-WM

      5. gnome / ub     -  Gnome like layout
-
ENDSTR
)

command="$1"
shift
case "$command" in

 help|--help)
         echo $VERSION
  echo "$USAGE"
  ;;
#...........................................
windows|win)
pkill swaybg && pkill waybar && ~/.config/nixpkgs/modes/windows/activate && sleep 0.3;clear
;;
mac-os|mac)
pkill swaybg && pkill waybar && ~/.config/nixpkgs/modes/mac-os/activate && sleep 0.3;clear
;;
modular|mod)
pkill swaybg && pkill waybar && ~/.config/nixpkgs/modes/custom/activate && sleep 0.3;clear
;;
cosmic|pop)
pkill swaybg && pkill waybar && ~/.config/nixpkgs/modes/pop-os/activate && sleep 0.3;clear
;;
gnome|ub)
pkill swaybg && pkill waybar && ~/.config/nixpkgs/modes/gnome/activate && sleep 0.3;clear
;;
#...........................................
	*)
		[ -z $command ] || echo Unknown command: $command
		echo "$USAGE"
		;;
  esac
  ''
