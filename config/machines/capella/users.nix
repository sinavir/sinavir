{lib, ...}: {
  users.mutableUsers = false;
  users.users.borg = {
    isNormalUser = true;
    home = "/backups";
    createHome = true;
    openssh.authorizedKeys.keyFiles = [./../../shared/pubkeys/borg.keys];
  };
}
