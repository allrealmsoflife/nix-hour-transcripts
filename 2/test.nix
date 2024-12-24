
let
  pkgs = import <nixpkgs> {
    overlays = [
      (final: prev: {
        hello = (prev.hello.override {
          }).overrideAttrs (finalAttrs: {
            version = "2.12";

            nativeBuildInputs = (finalAttrs.nativeBuildInputs or []) ++ [
              final.jq
            ];
          }); 
        })
    ];
  };
in 
pkgs.hello
