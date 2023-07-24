{...}: {
  services.syncthing = {
    user = "maurice";
    group = "maurice";
    dataDir = "/home/maurice";
    openDefaultPorts = true;
  };
}
