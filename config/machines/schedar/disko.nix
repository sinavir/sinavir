_:

let
  luksName = "mainfs";
in
{
  boot.initrd.luks.devices.${luksName} = {
    keyFile = "/dev/zero";
    keyFileSize = 1;
  };
  disko.devices = {
    disk = {
      sda = {
        device = "/dev/sda";
        type = "disk";
        content = {
          type = "table";
          format = "gpt";
          partitions = [
            {
              name = "boot";
              start = "0";
              end = "1M";
              flags = [ "bios_grub" ];
            }
            {
              name = "ESP";
              start = "1MiB";
              end = "512MiB";
              bootable = true;
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            }
            {
              name = "luks";
              start = "512MiB";
              end = "-4GiB";
              content = rec {
                type = "luks";
                name = luksName;
                extraOpenArgs = [ "--keyfile-size=1" ];
                extraFormatArgs = extraOpenArgs;
                keyFile = "/dev/zero";
                content = {
                  type = "btrfs";
                  mountpoint = "/mnt/btrfs-root";
                  subvolumes = {
                    "/rootfs" = {
                      mountpoint = "/";
                      mountOptions = [ "compress=zstd" ];
                    };
                    "/home" = {
                      mountOptions = [ "compress=zstd" ];
                      mountpoint = "/home";
                    };
                    "/var-lib" = {
                      mountpoint = "/var/lib";
                    };
                    "/var-log" = {
                      mountOptions = [ "compress=zstd" ];
                      mountpoint = "/var/log";
                    };
                    "/nix" = {
                      mountOptions = [ "noatime" "compress=zstd" ];
                      mountpoint = "/nix";
                    };
                  };
                };
              };
            }
            {
              name = "swap";
              start = "-4GiB";
              end = "100%";
              content = {
                type = "swap";
                randomEncryption = true;
              };
            }
          ];
        };
      };
    };
  };
}
