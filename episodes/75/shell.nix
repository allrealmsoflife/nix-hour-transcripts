# myfile.nix
{
  system ? builtins.currentSystem,
}:
let
  nixpkgsSrc = builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/refs/heads/nixos-unstable.tar.gz";
  treefmt-nixSrc = builtins.fetchTarball "https://github.com/numtide/treefmt-nix/archive/refs/heads/master.tar.gz";
  nixpkgs = import nixpkgsSrc { inherit system; };
  treefmt-nix = import treefmt-nixSrc;
in
nixpkgs.mkShell {
  packages = [
    (treefmt-nix.mkWrapper nixpkgs {
      # Used to find the project root
      projectRootFile = ".git/config";
      # Enable the terraform formatter
      programs.nixfmt-rfc-style.enable = true;
      programs.jsonfmt.enable = true;
    })
  ];
}
