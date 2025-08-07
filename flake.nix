{
  description = "NeoVim configuration using Nixvim";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lexical = {
      # So I can overwrite the FOD hash
      url = "github:ffloyd/lexical";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    nixvim,
    lexical,
    flake-parts,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = nixpkgs.lib.systems.flakeExposed;

      perSystem = {
        pkgs,
        system,
        ...
      }: let
        nixvimLib = nixvim.lib.${system};
        nixvim' = nixvim.legacyPackages.${system};

        otp = pkgs.beam.packages.erlang_26;
        elixir = otp.elixir_1_17;
        lexicalPackage = (lexical.lib.mkLexical {erlang = otp;}).override {
          inherit elixir;
          fodHash = "sha256-g6BZGJ33oBDXmjbb/kBfPhart4En/iDlt4yQJYeuBzw=";
        };
        nvim = nixvim'.makeNixvimWithModule {
          inherit pkgs;
          module = import ./config {inherit lexicalPackage pkgs;};
        };
      in {
        packages = {
          # Lets you run `nix run .` to start nixvim
          default = nvim;
          inherit lexicalPackage;
        };

        formatter = pkgs.alejandra;

        checks = {
          # Run `nix flake check .` to verify that your config is not broken
          default = nixvimLib.check.mkTestDerivationFromNvim {
            inherit nvim;
            name = "A nixvim configuration";
          };
        };
      };
    };
}
