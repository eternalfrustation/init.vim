#!/bin/bash
plugin_dir=~/.local/share/nvim/site/pack/frustated/start/
rm -rf $plugin_dir
git clone --depth 1 https://github.com/nvim-lualine/lualine.nvim "${plugin_dir}lualine/"
git clone --depth 1 https://github.com/dracula/vim "${plugin_dir}dracula/"
git clone --depth 1 https://github.com/neovim/nvim-lspconfig "${plugin_dir}lspconfig/"
git clone --depth 1 https://github.com/Krasjet/auto.pairs "${plugin_dir}auto-pairs/"
git clone --depth 1 https://github.com/luochen1990/rainbow "${plugin_dir}rainbow/"
git clone --depth 1 https://github.com/kyazdani42/nvim-web-devicons "${plugin_dir}devicons/"
git clone --depth 1 https://github.com/kyazdani42/nvim-tree.lua "${plugin_dir}nvim-tree/"
git clone --depth 1 https://github.com/nvim-treesitter/nvim-treesitter "${plugin_dir}nvim-treesitter/"
git clone --depth 1 https://github.com/lervag/vimtex "${plugin_dir}vimtex/"
git clone --depth 1 https://github.com/neovim/nvim-lspconfig "${plugin_dir}nvim-lspconfig/"
git clone --depth 1 https://github.com/hrsh7th/cmp-nvim-lsp "${plugin_dir}cmp-nvim-lsp/"
git clone --depth 1 https://github.com/hrsh7th/cmp-buffer "${plugin_dir}cmp-buffer/"
git clone --depth 1 https://github.com/hrsh7th/cmp-path "${plugin_dir}cmp-path/"
git clone --depth 1 https://github.com/hrsh7th/cmp-cmdline "${plugin_dir}cmp-cmdline/"
git clone --depth 1 https://github.com/hrsh7th/cmp-omni "${plugin_dir}cmp-omni/"
git clone --depth 1 https://github.com/hrsh7th/nvim-cmp "${plugin_dir}nvim-cmp/"
git clone --depth 1 https://github.com/dcampos/nvim-snippy "${plugin_dir}nvim-snippy/"
git clone --depth 1 https://github.com/dcampos/cmp-snippy "${plugin_dir}cmp-snippy/"
git clone --depth 1 https://github.com/rmagatti/auto-session "${plugin_dir}auto-session/"
git clone --depth 1 https://github.com/ray-x/cmp-treesitter "${plugin_dir}cmp-treesitter/"
