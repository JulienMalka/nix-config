{ pkgs, config, ... }:
let
    dusk-vim = pkgs.vimUtils.buildVimPlugin {
        name = "dusk-vim";
        src = pkgs.fetchFromGitHub {
            owner = "notusknot";
            repo = "dusk-vim";
            rev = "8eb71f092ebfa173a6568befbe522a56e8382756";
            sha256 = "09l4hda5jnyigc2hhlirv1rc8hsnsc4zgcv4sa4br8fryi73nf4g";
        };
    };


in
{
    enable = true;
    package = pkgs.neovim-unwrapped;
    plugins = with pkgs.vimPlugins; [
        # File tree
        nvim-web-devicons 
        nvim-tree-lua
        # LSP
        nvim-lspconfig
        # Languages
        vim-nix

        # Eyecandy 
        nvim-treesitter
        bufferline-nvim
        galaxyline-nvim
        nvim-colorizer-lua
        pears-nvim
        dusk-vim

        # Lsp and completion
        nvim-lspconfig
        nvim-compe

        # Telescope
        telescope-nvim

        # Indent lines
        indent-blankline-nvim
    ];
    extraPackages = with pkgs; [
        gcc
    	rnix-lsp
        tree-sitter
	sumneko-lua-language-server
    ];
        extraConfig = ''
          luafile ${./lua}/lsp.lua
          luafile ${./lua}/nvim-tree.lua
          luafile ${./lua}/galaxyline.lua
          luafile ${./lua}/settings.lua
    '';
}
