{
  programs.alacritty = {
    enable = true;
    settings = {
      import = [
        ./alacritty.yml
      ];
    };
  };
}
