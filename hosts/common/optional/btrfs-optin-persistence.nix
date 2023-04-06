{ lib, config, ... }:
let
  hostname = config.networking.hostName;
in
{
  boot.initrd.supportedFilesystems = [ "btrfs" ];

  fileSystems = {
    "/" = {
      device = "none";
      fsType = "tmpfs";
    };
    "/nix" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
      options = [ "subvol=nix" "noatime" "compress=zstd" ];
    };

    "/persist" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
      options = [ "subvol=persist" "compress=zstd" ];
      neededForBoot = true;
    };

    "/swap" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
      options = [ "subvol=swap" "noatime" ];
    };
  };

}
