let 
  pkgs = import /home/stablejoy/src/nixpkgs {
    overlays = [
      (final: prev: {
        hello = (prev.hello.override {
          fetchurl = throw "not fetchurl";
        }).overrideAttrs (finalAttrs: {
            version = "2.12";

            # For now this is probably the best general approach
            #src = final.fetchurl {
            #url = finalAttrs.src.url;
            #hash = "";
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
