{
  lexicalPackage,
  pkgs,
  ...
}: {
  imports = [
    ./base.nix
    ./keymaps.nix
    ./helpers.nix
    (import ./lsp.nix {inherit lexicalPackage;})
    (import ./custom-packages.nix {inherit pkgs;})
    # ./autoformat.nix
    ./git.nix
    ./whichkey.nix
    ./fs.nix
    ./comments.nix
    ./undotree.nix
    ./telescope.nix
    ./trouble.nix
    ./markview.nix
    ./ufo.nix
    ./layout.nix
  ];
}
