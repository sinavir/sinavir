{pkgs}: {
  proxy = ./proxy.conf;
  location = ./authelia-location.conf;
  authrequest = ./authelia-authrequest.conf;
  location-basic = ./authelia-location-basic.conf;
  authrequest-basic = ./authelia-authrequest-basic.conf;
}
