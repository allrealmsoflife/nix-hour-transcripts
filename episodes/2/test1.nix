let 
  pkgs = import <nixpkgs> {
    overlays = [
      (final: prev: {
        hello = prev.hello.override {
          fetchurl = throw "not fetchurl";
        };
      })
    ];
  };
in pkgs.hello
