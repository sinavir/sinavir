# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [(modulesPath + "/installer/scan/not-detected.nix")];

  boot.supportedFilesystems = [ "ntfs" ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "nvme"
    "usb_storage"
    "sd_mod"
    "sr_mod"
    "rtsx_usb_sdmmc"
  ];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-intel"];
  boot.extraModulePackages = [];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/eeb7e860-a8b2-4dfc-b118-721563d8667e";
    fsType = "btrfs";
    options = ["subvol=root"];
  };

  boot.initrd.luks.devices."mainfs".device = "/dev/disk/by-uuid/261bfe2b-331c-4733-9998-ab57daa2c5b4";
  environment.etc."crypttab".text = "hdd UUID=7411abc3-c477-4cf4-8892-d2264f43e880 /secrets/hddkey"; # dont use builtin stuff because it is too early

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/eeb7e860-a8b2-4dfc-b118-721563d8667e";
    fsType = "btrfs";
    options = ["subvol=nix"];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/cabb6a0f-a8ee-4c6c-b276-1f221922ad96";
    fsType = "btrfs";
    options = ["subvol=home"];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/8FF8-A675";
    fsType = "vfat";
  };

  fileSystems."/mnt/btrfs-root-top-lvl" = {
    device = "/dev/disk/by-uuid/eeb7e860-a8b2-4dfc-b118-721563d8667e";
    fsType = "btrfs";
  };

  fileSystems."/mnt/btrfs-home-top-lvl" = {
    device = "/dev/disk/by-uuid/cabb6a0f-a8ee-4c6c-b276-1f221922ad96";
    fsType = "btrfs";
  };

  fileSystems."/swap" = {
    device = "/dev/disk/by-uuid/eeb7e860-a8b2-4dfc-b118-721563d8667e";
    fsType = "btrfs";
    options = ["subvol=swap"];
  };

  swapDevices = [
    {
      device = "/swap/swapfile";
      size = 10240;
    }
  ];
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;
}
