{ lib, pkgs, ... }:
{
  boot.loader.grub.device = "nodev";
  fileSystems."/".device = "/devst";
  system.stateVersion = "23.11";

  environment.systemPackages = [ pkgs.curl ];
}
