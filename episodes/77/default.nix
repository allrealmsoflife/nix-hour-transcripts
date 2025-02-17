{
  system ? builtins.currentSystem,
  sources ? import ./npins,
}:
let
  pkgs = import sources.nixpkgs {
    config = { };
    overlays = [ ];
    inherit system;
  };
  inherit (pkgs) lib;
in
lib.makeScope pkgs.newScope (final: {

  signal = pkgs.callPackage ./signal.nix { };

})
