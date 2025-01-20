{
  system ? builtins.currentSystem,
  sources ? import ./npins,
}:
let
  pkgs = import /shed/Projects/nixhome/nixpkgs/master {
    config = { };
    overlays = [ ];
    inherit system;
  };
  inherit (pkgs) lib;
in
lib.makeScope pkgs.newScope (final: {

  signal = pkgs.callPackage ./signal.nix { };

  shell = pkgs.mkShell {
    packages = [
      pkgs.npins
    ];
  };

  inherit pkgs;
})
