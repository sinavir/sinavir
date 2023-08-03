[
  (self: super: {
    ws-scraper = self.python310Packages.callPackage ./ws-scraper.nix {
      aiosqlite = super.python310Packages.aiosqlite.overrideAttrs (old: {
        propagatedBuildInputs =
          old.propagatedBuildInputs
          ++ [self.python310Packages.typing-extensions];
      });
    };
  })
  (self: super: {
    agenix = self.callPackage ((import ../npins).agenix + "/pkgs/agenix.nix") {};
  })
  (self: super: {
    nixosAnywhere = self.callPackage (
      (import ../npins).nixos-anywhere + "/src"
    ) {};
  })
  (self: super: {
    josh = self.callPackage ../../josh-nix/josh.nix {};
  })
]
