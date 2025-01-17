let 
  pkgs = import /home/stablejoy/src/nixpkgs {
    overlays = [
      (final: prev: {
        hello = prev.hello.overrideAttrs (finalAttrs: {
            version = "2.12";

            # For now this is probably the best general approach
            src = final.fetchurl {
            url = finalAttrs.src.url;
            hash = "sha256-zwSvhtwIUmjF9EcPuuSbGK+8Iht4CWqrhC2TSna60Ks=";
            };

          nativebuildinputs = (finalAttrs.nativebuildinputs or []) ++ [
            final.jq
          ];
        });
      })
    ];
  };
in pkgs.hello
