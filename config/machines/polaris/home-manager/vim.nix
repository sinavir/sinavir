{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.vim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      vim-go
      vim-airline
      vim-airline-themes
      ultisnips
      vimtex
      vim-fugitive
      zig-vim
      base16-vim
      vim-wayland-clipboard
      vim-svelte
      ale
      (pkgs.vimUtils.buildVimPluginFrom2Nix {
        pname = "vim-lark-syntax";
        version = "2020-09-18";
        src = pkgs.fetchFromGitHub {
          owner = "lark-parser";
          repo = "vim-lark-syntax";
          rev = "80891559f5686b5d2a897cc25628fdf5a2d0aff0";
          sha256 = "sha256-FlgguTfMbhh4q1f+eVnb+Q9OmlSM+w148ZJp4t6zdYo=";
        };
      })
    ];
    settings = {number = true;};
    extraConfig = ''
      set termguicolors
      colorscheme base16-bright
      let g:airline_theme='base16_bright'

      set noesckeys
      set incsearch

      set mouse=""

      let g:vimtex_view_method = 'zathura'
      let g:vimtex_quickfix_ignore_filters = [
          \ "Underfull",
          \ "Overfull",
          \ "Package siunitx Warning: Detected the \"physics\" package",
          \ "float specifier changed to"
          \]
      let g:ale_fixers = {
      \   'python': [
      \       'black',
      \       'isort',
      \   ],
      \   'rust': [
      \       'rustfmt',
      \       'trim_whitespace',
      \       'remove_trailing_lines',
      \   ] ,
      \   'haskell': [
      \       'floskell',
      \       'trim_whitespace',
      \       'remove_trailing_lines',
      \   ] ,
      \}

      let g:ale_linters = {
      \   'rust': [
      \       'analyzer',
      \   ],
      \   'python': [
      \       'ruff',
      \   ],
      \   'sh': ['language_server'],
      \}

      let g:ale_fix_on_save = 1

    '';
  };
  home.file = let
    nicetabs = pkgs.writeText "nicetabs.vim" ''
      setlocal expandtab
      setlocal shiftwidth=2
      setlocal softtabstop=2
    '';
  in {
    ".vim/UltiSnips/".source = pkgs.fetchFromGitHub {
      owner = "sinavir";
      repo = "ultisnip-snippets";
      rev = "09b4d4a720cb780a156fd487188bf192b58aa174";
      sha256 = "0l39gf0aivdbsqr3dqqa4mql8kkypggy3z0bgpzr96z17b6ylwj4";
    };
    ".vim/after/ftplugin/javascript.vim".source = nicetabs;
    ".vim/after/ftplugin/html.vim".source = nicetabs;
    ".vim/after/ftplugin/svelte.vim".source = nicetabs;
  };
}
