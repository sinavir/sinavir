final: prev: {
  nerd-dictation = final.callPackage ./nerd-dict.nix {};
  vosk = final.callPackage ./vosk.nix { kaldi = final.voskKaldi; };
  voskKaldi = final.callPackage ./kaldi.nix {};
  pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
    (
      python-final: python-prev: {
        vosk-api = python-final.callPackage ./vosk-api.nix {};
      }
    )
  ];
}
