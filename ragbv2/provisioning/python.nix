{ lib, python3, debug ? false }:
let
  python = python3.override {
    packageOverrides = self: super: {
      django = super.django_4;
      authens = self.callPackage ./authens.nix { };
      pythoncas = self.callPackage ./python-cas.nix { };
      pyjecteur = self.callPackage ../../pyjecteur/pyjecteur.nix { };
    };
  };
in
python.withPackages (ps: [
  ps.django
  ps.gunicorn
  ps.requests
  ps.authens
  ps.pyjwt
  ps.pyjecteur
  ps.colour
  ps.django-debug-toolbar
] ++ lib.optionals debug [
  ps.black
  ps.isort
])
