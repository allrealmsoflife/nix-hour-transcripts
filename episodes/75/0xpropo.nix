{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "0x-propo";
  version = "1.100";

  src = fetchFromGitHub {
    owner = "0xType";
    repo = "0xPropo";
    rev = version;
    hash = "sha256-PCSx0LbV7qDrWgWcaRs1sAr3GUcU6Kw2q7HgAh8BnGA=";
  };

  meta = with lib; {
    description = "Proportional version of 0xProto";
    homepage = "https://github.com/0xType/0xPropo";
    changelog = "https://github.com/0xType/0xPropo/blob/${src.rev}/CHANGELOG.md";
    license = licenses.ofl;
    maintainers = with maintainers; [ ];
    platforms = lib.platforms.all;
  };
}
