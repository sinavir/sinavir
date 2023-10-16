{ lib, python3, debug ? false }:
let
  python = python3.override {
    packageOverrides = self: super: {
      django = super.django_4;
      authens = self.callPackage ./authens.nix { };
      pythoncas = self.callPackage ./python-cas.nix { };
      django-solo = self.callPackage ./django-solo.nix { };
    };
  };
in
python.withPackages (ps: [
  ps.django
  ps.gunicorn
  ps.djangorestframework
  ps.authens
  ps.python-dotenv
  ps.websockets
  ps.pyyaml
  ps.uritemplate
  ps.django-solo
  ps.django-redis
  ps.aioredis
] ++ lib.optionals debug [
  ps.django-debug-toolbar
  ps.black
  ps.isort
])
