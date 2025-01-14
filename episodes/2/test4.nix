let 
  pkgs = import <nixpkgs> {
    overlays = [
      (final: prev: {
        hello = (prev.hello.override {
          #fetchurl = throw "not fetchurl";
        }).overrideAttrs (oldAttrs: {
          version = "2.12";
          # src = fetchurl {
          #url = "mirror://gnu/hello/hello-${finalattrs.version}.tar.gz";
          #hash = "sha256-jzkukv2sv28wsm18tcqnxoczmlxdyh2idh9rlibh2ya=";
          #};

          nativebuildinputs = (oldAttrs.nativebuildinputs or []) ++ [
            final.jq
          ];
        });
      })
    ];
  };
in pkgs.hello
