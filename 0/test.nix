let 
    nixpkgs = builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/master.tar.gz";
    pkgs = import nixpkgs {};
    someCPackage = pkgs.stdenv.mkDerivation {
      name = "someCPackage";
      src = ./src;
  };
in someCPackage
