
let
  pkgs = import <nixpkgs> {
    overlays = [
      (final: prev: {
        hello = (prev.hello.override {
          }).overrideAttrs (finalAttrs: {
            version = "2.12";

            src = finalAttrs.src.overrideAttrs (finalAttrs': {
              sha256 = "00000000000000000000000000000000000000000000000000000000000000000";
            });

            nativeBuildInputs = (finalAttrs.nativeBuildInputs or []) ++ [
              final.jq
            ];
          }); 
        })
      ];
    };
in
pkgs.hello
