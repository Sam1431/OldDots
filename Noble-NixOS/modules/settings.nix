{ config, lib, pkgs, ... }:

{

  ## SETTINGS

  ## INTERNATIONALISATION
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  ## TIMEZONE
  time.timeZone = "Asia/Kolkata";

#------------------------------------------------------------
#  ## AUDIO / BLUETOOTH
#  sound.enable = true;
#  hardware.pulseaudio = {
#    enable = true;
#    extraModules = [ pkgs.pulseaudio-modules-bt ];
#    package = pkgs.pulseaudioFull;
#  };
#  hardware.bluetooth.enable = true;
#------------------------------------------------------------

# AUDIO

security.rtkit.enable = true;
services.pipewire = {
  enable = true;
  alsa.enable = true;
  alsa.support32Bit = true;
  pulse.enable = true;
  # If you want to use JACK applications, uncomment this
  # jack.enable = true;
  # media-session.enable = true;
};

services.pipewire  = {
  media-session.config.bluez-monitor.rules = [
    {
      # Matches all cards
      matches = [ { "device.name" = "~bluez_card.*"; } ];
      actions = {
        "update-props" = {
          "bluez5.reconnect-profiles" = [ "hfp_hf" "hsp_hs" "a2dp_sink" ];
          # mSBC is not expected to work on all headset + adapter combinations.
          "bluez5.msbc-support" = true;
          # SBC-XQ is not expected to work on all headset + adapter combinations.
          "bluez5.sbc-xq-support" = true;
        };
      };
    }
    {
      matches = [
        # Matches all sources
        { "node.name" = "~bluez_input.*"; }
        # Matches all outputs
        { "node.name" = "~bluez_output.*"; }
      ];
      actions = {
        "node.pause-on-idle" = false;
      };
    }
  ];
};

}
