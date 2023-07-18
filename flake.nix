{
  description = "West's MacOS Config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = {
    nixpkgs,
    home-manager,
    darwin,
    ...
  } @ inputs: {
    packages = nixpkgs.lib.genAttrs ["aarch64-darwin" "x86_64-darwin"] (system: {
      debugserver = nixpkgs.legacyPackages.${system}.callPackage ./pkgs/debugserver {};
    });
    darwinConfigurations = {
      "Mains-MacBook-Pro" = darwin.lib.darwinSystem {
        system = "x86_64-darwin";
        inherit inputs;
        pkgs = import nixpkgs {
          system = "x86_64-darwin";
          config = {
            allowUnfree = true;
          };
        };
        modules = [
          ./modules/darwin
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.main.imports = [./modules/home-manager];
              extraSpecialArgs = {inherit inputs;};
            };
          }
        ];
      };
    };
  };
}
