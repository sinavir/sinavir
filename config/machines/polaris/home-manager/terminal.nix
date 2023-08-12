{
  programs.alacritty = {
    enable = true;
    settings = {
      import = [
        ./alacritty.yml
      ];
    };
  };
  programs.starship = {
    enable = true;
  };
}
