{lib, ...}: {
  users.mutableUsers = false;
  users.users.borg = {
    isNormalUser = true;
    home = "/backups";
    createHome = true;
    openssh.authorizedKeys.keyFiles = [./../../shared/pubkeys/maurice.keys ./../../shared/pubkeys/borg.keys];
  };
}
