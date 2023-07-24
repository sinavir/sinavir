{...}: {
  users.mutableUsers = false;
  users.users.root = {
    openssh.authorizedKeys.keyFiles = [./pubkeys/maurice.keys];
    hashedPassword = "$6$BlPEVPOFNnvfTvLQ$o/GtstzjETp93MnTpEiYG664Einj4Ow7TQHi5ODv0gNhZdbWKhnQKai1eyBwUw/1bufx9SHd2RM9k1O3XjtNb.";
  };
}
