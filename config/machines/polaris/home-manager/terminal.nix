{
  programs.alacritty = {
    enable = true;
    settings = {
      import = [
        ./alacritty.toml
      ];
    };
  };
  programs.starship = {
    enable = true;
  };
}
