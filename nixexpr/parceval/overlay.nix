final: prev: {
  pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
    (
      python-final: python-prev: {
        parceval-quandela = python-final.callPackage ./parceval-quandela.nix {};
        exqalibur = python-final.callPackage ./exqalibur.nix {};
        drawsvg = python-final.callPackage ./drawsvg.nix {};
      }
    )
  ];
}
