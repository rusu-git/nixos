{ config, pkgs, quickshell, qml-niri, ... }:
{
  home.username = "rusu";	home.homeDirectory = "/home/rusu";
  home.stateVersion = "26.05";

  nixpkgs.config.allowUnfree = true;
  
  home.packages = with pkgs; [
	fastfetch
	kitty
	firefox
	micro
	kdePackages.dolphin
	unrar
	brightnessctl
	localsend
	(qml-niri.packages.${pkgs.system}.quickshell)
	jmtpfs #for switch`s MTP
  ];

  home.file = {
    ".config/niri/config.kdl".source = ./niri.kdl;
  };

  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  programs.home-manager.enable = true;

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
