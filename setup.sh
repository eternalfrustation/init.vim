plugin_dir=~/.local/share/nvim/site/pack/frustated/start/
rm -rf $plugin_dir
git clone --depth 1 https://github.com/itchyny/lightline.vim "${plugin_dir}lightline/"
git clone --depth 1 https://github.com/dracula/vim "${plugin_dir}dracula/"
git clone --depth 1 https://github.com/neovim/nvim-lspconfig "${plugin_dir}lspconfig/"
git clone --depth 1 https://github.com/Krasjet/auto.pairs "${plugin_dir}auto-pairs/"
git clone --depth 1 https://github.com/ervandew/supertab "${plugin_dir}supertab/"
git clone --depth 1 https://github.com/luochen1990/rainbow "${plugin_dir}rainbow/"
git clone --depth 1 https://github.com/kyazdani42/nvim-web-devicons "${plugin_dir}devicons/"
git clone --depth 1 https://github.com/kyazdani42/nvim-tree.lua "${plugin_dir}nvim-tree/"
