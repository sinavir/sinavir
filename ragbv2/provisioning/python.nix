{ lib, python3, debug ? false }:
let
  python = python3.override {
    packageOverrides = self: super: {
      django = super.django_4;
      authens = self.callPackage ./authens.nix { };
      pythoncas = self.callPackage ./python-cas.nix { };
      django-solo = self.callPackage ./django-solo.nix { };
      pyjecteur = self.callPackage ../../pyjecteur/pyjecteur.nix { };
    };
  };
in
python.withPackages (ps: [
  ps.django
  ps.gunicorn
  ps.djangorestframework
  ps.authens
  ps.requests
  ps.pyjecteur
  ps.python-dotenv
  ps.websockets
  ps.pyyaml
  ps.uritemplate
  ps.colour
  ps.django-solo
  ps.django-redis
  ps.aioredis
  ps.psycopg
  ps.django-debug-toolbar
] ++ lib.optionals debug [
  ps.black
  ps.isort
])
