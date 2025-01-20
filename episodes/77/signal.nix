{
  mkYarnPackage,
  yarn2nix-moretea,
  fetchFromGitHub,
}:

mkYarnPackage rec {
  pname = "signalapp";
  version = "7.12.0";

  src = fetchFromGitHub {
    owner = "signalapp";
    repo = "Signal-Desktop";
    rev = "ccad9a8f0137941f6f69eadc02e0fe718709a503";
    hash = "sha256-FRVlOxqnvYl5cujio9WOD9Vs6XiLBn3KGNWRNy5vSaQ=";
    fetchSubmodules = true;
  };

  yarnNix = ./yarn.nix;
}
