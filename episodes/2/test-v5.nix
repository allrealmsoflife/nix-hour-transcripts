let 
  pkgs = import <nixpkgs> {
    overlays = [
      (final: prev: {
        hello = (prev.hello.override {
          #fetchurl = throw "not fetchurl";
        }).overrideAttrs (finalAttrs: {
          version = "2.12";
          # src = final.fetchurl {
          #url = finalAttrs.src.url;
          #hash = "sha256-jzkukv2sv28wsm18tcqnxoczmlxdyh2idh9rlibh2ya=";
          #};

          nativebuildinputs = (finalAttrs.nativebuildinputs or []) ++ [
            final.jq
          ];
        });
      })
    ];
  };
in pkgs.hello
