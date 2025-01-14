
let 
  pkgs = import <nixpkgs> {
    overlays = [
      (final: prev: {
        hello = (prev.hello.override {
          fetchurl = throw "not fetchurl";
        }).overrideAttrs (oldAttrs: {
          src = oldAttrs.src;
          
          nativeBuildInputs = oldAttrs.nativeBuildInputs or [] ++ [
            final.jq
          ];
        });
      })
    ];
  };
in pkgs.hello
