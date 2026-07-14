{ config, pkgs, ... }:
{
  home.username = "rusu";	home.homeDirectory = "/home/rusu";
  home.stateVersion = "26.05";

  nixpkgs.config.allowUnfree = true;
  
  home.packages = with pkgs; [
	fastfetch
	quickshell
	kitty
	helix
	firefox
	kdePackages.dolphin
	unrar
	brightnessctl
	localsend
	adwaita-icon-theme
	jmtpfs #for switch`s MTP
  ];

#home.pointerCursor = {
#    name = "Adwaita";
#    package = pkgs.adwaita-icon-theme;
#    size = 24;
#    gtk.enable = true;
#  };

  home.file = {
#    ".config/niri/config.kdl".source = ./niri.kdl;
  };

  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  programs.home-manager.enable = true;

  wayland.windowManager.hyprland = {
    enable = true;
	systemd.enable = false;
    xwayland.enable = true;
  };
	
  programs.git = {
  	enable = true;
  	settings = {
  		user.name = "example";
  		user.email = "example@example.com";
  		init.defaultBranch = "main";
  	};
  };
  
  programs.fish = {
	enable = true;
	shellAliases = {
		nixos = "sudo nixos-rebuild switch --flake ~/.dotfiles";
		flake = "nix flake update";
		home = "home-manager switch --flake ~/.dotfiles";
	};
	shellInit = ''
		set fish_greeting
        '';
  };  
}
