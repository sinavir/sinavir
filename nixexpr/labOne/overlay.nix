final: prev: {
  labOne = final.callPackage ./labOne.nix {};
  pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
    (
      python-final: python-prev: {
        zhinst-core = python-final.callPackage ./zhinst-core.nix {};
        zhinst-toolkit = python-final.callPackage ./zhinst-toolkit.nix {};
        zhinst-utils = python-final.callPackage ./zhinst-utils.nix {};
        zhinst-meta = python-final.callPackage ./zhinst-meta.nix {};
        gwyfile = python-final.callPackage ./gwyfile.nix {};
      }
    )
  ];
}
