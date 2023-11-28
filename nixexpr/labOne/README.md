# Zurich Instruments' LabOne and python API

## LabOne

```
nix-build -A labOne
```

## python with `zhinst` module

```
nix-build -A python
```

## Add to nixos:

```
{ pkgs, ... }:
{
  nixpkgs.overlays = [ (import path/to/this/repo/overlay.nix) ];
  services.udev.packages = [ pkgs.labOne ];
}
```

## TODO

- [ ] Split labOne in multiple derivations
- [ ] Add a script to install temporary udev rules (Don't know how to do that)
