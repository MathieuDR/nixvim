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

    # lexical = {
    #   url = "github:lexical-lsp/lexical";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs = {
    nixpkgs,
    nixvim,
    # lexical,
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
        lexicalPackage = pkgs.lexical.override {
          elixir = pkgs.beam.packages.erlang_27.elixir_1_17;
        };
        # .overrideAttrs (old: {
        #   # Remove the postInstall since we're using preFixup
        #   postInstall = "";
        #   preFixup = let
        #     activate_version_manager = pkgs.writeScript "activate_version_manager.sh" ''
        #       true
        #     '';
        #   in ''
        #     substituteInPlace "$out/bin/start_lexical.sh" \
        #       --replace-fail 'elixir_command=' 'elixir_command="${pkgs.beam.packages.erlang_27.elixir_1_17}/bin/"'
        #     rm -f "$out/bin/activate_version_manager.sh"
        #     ln -s ${activate_version_manager} "$out/bin/activate_version_manager.sh"
        #
        #     mv "$out/bin" "$out/libexec"
        #
        #     makeWrapper "$out/libexec/start_lexical.sh" "$out/bin/lexical" \
        #       --set RELEASE_COOKIE lexical
        #   '';
        # });
        # lexicalPackage = lexical.packages.${system}.default;
        # lexicalPackage = lexical.packages.${system}.default.override {
        #   elixir = pkgs.beam.packages.erlang_26.elixir_1_17;
        # };
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
