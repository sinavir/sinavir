{ lib, python3, debug ? false }:
let
  python = python3.override {
    packageOverrides = self: super: {
      django = super.django_4;
    };
  };
in
python.withPackages (ps: [
  ps.django
  ps.gunicorn
  ps.djangorestframework
] ++ lib.optionals debug [
  ps.django-debug-toolbar
  ps.black
  ps.isort
])
