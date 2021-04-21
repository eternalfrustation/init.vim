set nu
set clipboard^=unnamed,unnamedplus
set autochdir
"dein Scripts-----------------------------
if &compatible
  set nocompatible               " Be iMproved
endif

" Required:
set runtimepath+=/root/.config/nvim/packages/repos/github.com/Shougo/dein.vim
" Required:
if dein#load_state('/root/.config/nvim/packages')
  call dein#begin('/root/.config/nvim/packages')

  " Let dein manage dein
  " Required:
  call dein#add('/root/.config/nvim/packages/repos/github.com/Shougo/dein.vim')

  " Add or remove your plugins here like this:
  "call dein#add('Shougo/neosnippet.vim')
  "call dein#add('Shougo/neosnippet-snippets')
  call dein#add('itchyny/lightline.vim')
  call dein#add('dracula/vim')
  call dein#add('Krasjet/auto.pairs')
  call dein#add('prabirshrestha/vim-lsp')
  call dein#add('Shougo/defx.nvim')
  call dein#add('ervandew/supertab')
  call dein#add('luochen1990/rainbow')
"  call dein#add('ryanoasis/vim-devicons')
  " Required:
  call dein#end()
  call dein#save_state()
endif
let g:SuperTabDefaultCompletionType="<C-x><C-o>"
" Required:
filetype plugin indent on
syntax enable

" If you want to install not installed plugins on startup.
"if dein#check_install()
"  call dein#install()
"endif
"End dein Scripts-------------------------
augroup LspGo
  au!
  autocmd User lsp_setup call lsp#register_server({
      \ 'name': 'go-lang',
      \ 'cmd': {server_info->['gopls']},
      \ 'whitelist': ['go'],
      \ })
  autocmd FileType go setlocal omnifunc=lsp#complete
  autocmd FileType go nmap <buffer> gd <plug>(lsp-definition)
  autocmd FileType go nmap <buffer> ,n <plug>(lsp-next-error)
  autocmd FileType go nmap <buffer> ,p <plug>(lsp-previous-error)
if executable('rls')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'rls',
        \ 'cmd': {server_info->['rustup', 'run', 'stable', 'rls']},
        \ 'workspace_config': {'rust': {'clippy_preference': 'on'}},
        \ 'whitelist': ['rust'],
        \ })
endif
augroup ENDcolorscheme landscape
colorscheme dracula
set guifont=Hack
let g:lightline = {
			\ 'colorscheme' : 'dracula'
			\}
let g:rainbow_active=1
let g:netrw_banner=0
let g:netrw_liststyle=3
let g:netrw_browse_split=4
let g:netrw_winsize=25
let g:netrw_altv=1
nnoremap <C-e> :Vex<CR>
set noshowmode
