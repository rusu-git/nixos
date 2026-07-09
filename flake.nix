{
 description = "flake";
 inputs = {
	nixpkgs.url = "nixpkgs/nixos-26.05";
	home-manager = {
		url = "github:nix-community/home-manager/release-26.05";
		inputs.nixpkgs.follows = "nixpkgs";
	};
	noctalia = {
		url = "github:noctalia-dev/noctalia";
      		inputs.nixpkgs.follows = "nixpkgs";
    	};
 };
 outputs = {self, nixpkgs, home-manager, noctalia, ...}:
 let
	lib = nixpkgs.lib;
	system = "x86_64-linux";
	pkgs = nixpkgs.legacyPackages.${system};
 in {
	nixosConfigurations = {
		nixos = lib.nixosSystem {
			inherit system;
			modules = [./configuration.nix];
		};
	};
	homeConfigurations = {
		rusu = home-manager.lib.homeManagerConfiguration {
			inherit pkgs;
			modules = [
				./home.nix
				noctalia.homeModules.default
			];
		};
	};
 };
}
