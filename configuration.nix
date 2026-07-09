{ config, pkgs, ... }:
{
  imports = [
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true; #Bootloader
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest; # Use latest kernel

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  networking.networkmanager.enable = true;
  networking.firewall.allowedTCPPorts = [ 53317 ];
  hardware.bluetooth.enable = false;

  time.timeZone = "Europe/Moscow";

  i18n.defaultLocale = "en_US.UTF-8"; # Select internationalisation properties

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ru_RU.UTF-8";
    LC_IDENTIFICATION = "ru_RU.UTF-8";
    LC_MEASUREMENT = "ru_RU.UTF-8";
    LC_MONETARY = "ru_RU.UTF-8";
    LC_NAME = "ru_RU.UTF-8";
    LC_NUMERIC = "ru_RU.UTF-8";
    LC_PAPER = "ru_RU.UTF-8";
    LC_TELEPHONE = "ru_RU.UTF-8";
    LC_TIME = "ru_RU.UTF-8";
  };

  services.xserver = {
    xkb.layout = "us,ru";
    xkbVariant = "";
    xkbOptions = "grp:win_space_toggle";
  };

  users.users."rusu" = {
    isNormalUser = true;
    description = "rusu";
    extraGroups = [ "networkmanager" "wheel" "gamemode" ];
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [];

  environment.shells = with pkgs; [fish];
  users.defaultUserShell = pkgs.fish;
  
  programs.fish.enable = true; 
  programs.niri.enable = true;
  programs.steam.enable = true;
  programs.gamemode.enable = true;  
  programs.amnezia-vpn.enable = true;

  # List services that you want to enable:
  services.gvfs.enable = true;
  services.tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

        CPU_MIN_PERF_ON_AC = 0;
        CPU_MAX_PERF_ON_AC = 100;
        CPU_MIN_PERF_ON_BAT = 0;
        CPU_MAX_PERF_ON_BAT = 20;

       #Optional helps save long term battery health
       START_CHARGE_THRESH_BAT0 = 79; # 79 and below it starts to charge
       STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging

      };
};
  services.greetd = {
  	enable = true;
  	settings = {
		default_session = {
			command = "${config.programs.niri.package}/bin/niri-session";
			user = "rusu";
		};
	};
  };
  systemd.user.services.niri.enableDefaultPath = false;  
  services.upower.enable = true;
  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "26.05"; # Did you read the comment?
  nix.settings.experimental-features = ["nix-command" "flakes"];
}
