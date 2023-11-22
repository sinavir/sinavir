{...}: {
  users.groups.maurice.gid = 1000;
  users.users.maurice = {
    uid = 1000;
    group = "maurice";
    home = "/home/maurice";
    isNormalUser = true;
    extraGroups = [ "libvirtd" "wheel" "dialout" "networkmanager"];
    hashedPassword = "$6$0g0qYLeYeYt/.CCJ$ZCUiB/oV65XX1pu40.Ldq9zCxqIqeIInqZ2EcLES6AZ7bXQZvQAyBJ1gx7uMXgWjrB7JibO/uaYf.yOyKI0JS1";
    openssh.authorizedKeys.keyFiles = [./../../shared/pubkeys/maurice.keys];
  };
}
