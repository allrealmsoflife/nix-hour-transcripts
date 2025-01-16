let 
  pkgs = import /home/stablejoy/src/nixpkgs {
    overlays = [
      (final: prev: {
        hello = (prev.hello.override {
          #fetchurl = throw "not fetchurl";
        }).overrideAttrs (finalAttrs: {
            version = "2.12";
            sha256 = "";

            #src = final.fetchurl {
            #url = finalAttrs.src.url;
            #hash = "sha256-jzkukv2sv28wsm18tcqnxoczmlxdyh2idh9rlibh2ya=";
            #};

            # Not working
            #src = finalAttrs.src.overrideAttrs (finalAttrs': {
            #outputHash = "";
            #});

          nativebuildinputs = (finalAttrs.nativebuildinputs or []) ++ [
            final.jq
          ];
        });
      })
    ];
  };
in pkgs.hello
