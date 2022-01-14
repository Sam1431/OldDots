{
 module.system = import ./system.nix;
 module.user = import ./user.nix;
 module.settings = import ./settings.nix;
 module.services = import ./services.nix;
 module.security = import ./security.nix;
 module.blacklist = import ./blacklist.nix;
 module.packages = import ./packages.nix;
 module.pipewire = import ./pipewire.nix;
 module.bluetooth = import ./bluetooth.nix;
 module.hardware = import ./hardware.nix;
 module.hardware-label = import ./hardware-label.nix;
 module.hardware-uuid = import ./hardware-uuid.nix;
 module.exwm = import ./exwm.nix;
 module.sway = import ./sway.nix;
 module.network = import ./network.nix;
}
