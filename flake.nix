{
  description = "hyperq's Linux server environment (home-manager standalone)";

  inputs = {
    # Use USTC mirror for nixpkgs (official China mirror)
    nixpkgs.url = "git+https://mirrors.ustc.edu.cn/nix-channels/nixpkgs-unstable?shallow=1";

    home-manager = {
      url = "git+https://ghproxy.link/https://github.com/nix-community/home-manager?ref=master&shallow=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    homeConfigurations.server = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [ ./home.nix ];
    };
  };
}
