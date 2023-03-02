set nu
set mouse=a
set clipboard+=unnamedplus
set autoread
set completeopt=menu,menuone,noselect
let g:neovide_transparency=0.7
if &compatible
  set nocompatible               " Be iMproved
endif

let g:SuperTabDefaultCompletionType="<C-x><C-o>"
let g:neovide_refresh_rate=30
let g:terminal_type="xterm"
let g:neovide_floating_blur_amount_x = 2.0
let g:neovide_floating_blur_amount_y = 2.0
" Required:
filetype plugin indent on
syntax enable
colorscheme dracula
highlight Normal ctermbg=NONE guibg=NONE
set guifont=FantasqueSansMono\ Nerd\ Font:h13
let g:rainbow_active=1
set noshowmode
nnoremap <C-n> :NvimTreeToggle<CR>
nnoremap <leader>r :NvimTreeRefresh<CR>
nnoremap <leader>n :NvimTreeFindFile<CR>
function! ToggleTerminal(height, width)
  let found_winnr = 0
  for winnr in range(1, winnr('$'))
    if getbufvar(winbufnr(winnr), '&buftype') == 'terminal'
      let found_winnr = winnr
    endif
  endfor

  if found_winnr > 0
    if &buftype == 'terminal'
        " if current window is the terminal window, close it
        execute found_winnr . ' wincmd q'
    else
        " if current window is not terminal, go to the terminal window
        execute found_winnr . ' wincmd w'
    endif
  else
    let found_bufnr = 0
    for bufnr in filter(range(1, bufnr('$')), 'bufexists(v:val)')
      let buftype = getbufvar(bufnr, '&buftype')
      if buftype == 'terminal'
        let found_bufnr = bufnr
      endif
    endfor

    if g:terminal_type == 'floating'
      call s:openTermFloating(found_bufnr, a:height, a:width)
    else
      call s:openTermNormal(found_bufnr, a:height, a:width)
    endif
  endif
endfunction

function! s:openTermFloating(found_bufnr, height, width) abort
  let [row, col, vert, hor] = s:getWinPos(a:width, a:height)
  let opts = {
    \ 'relative': 'cursor',
    \ 'width': a:width,
    \ 'height': a:height,
    \ 'col': col,
    \ 'row': row,
    \ 'anchor': vert . hor,
    \ 'style': 'minimal'
  \ }

  if a:found_bufnr == 0
    let bufnr = nvim_create_buf(v:false, v:true)
    call nvim_open_win(bufnr, 1, opts)
    terminal
    autocmd TermClose <buffer> if &buftype=='terminal' | wincmd c | endif
  else
    call nvim_open_win(a:found_bufnr, 1, opts)
  endif

  setlocal winblend=30
  setlocal foldcolumn=1
  setlocal bufhidden=hide
  setlocal signcolumn=no
  setlocal nobuflisted
  setlocal nocursorline
  setlocal nonumber
  setlocal norelativenumber
endfunction

function! s:openTermNormal(found_bufnr, height, width)
  if a:found_bufnr > 0
    if &lines > 30
      execute 'botright ' . a:height . 'split'
      execute 'buffer ' . a:found_bufnr
    else
      botright split
      execute 'buffer ' . a:found_bufnr
    endif
  else
    if &lines > 30
      if has('nvim')
        execute 'botright ' . a:height . 'split term://' . &shell
      else
        botright terminal
        resize a:height
      endif
    else
      if has('nvim')
        execute 'botright split term://' . &shell
      else
        botright terminal
      endif
    endif
  endif
endfunction

function! s:getWinPos(width, height) abort
    let bottom_line = line('w0') + winheight(0) - 1
    let curr_pos = getpos('.')
    let rownr = curr_pos[1]
    let colnr = curr_pos[2]
    " a long wrap line
    if colnr > &columns
        let colnr = colnr % &columns
        let rownr += colnr / &columns
    endif

    if rownr + a:height <= bottom_line
        let vert = 'N'
        let row = 1
    else
        let vert = 'S'
        let row = 0
    endif

    if colnr + a:width <= &columns
        let hor = 'W'
        let col = 0
    else
        let hor = 'E'
        let col = 1
    endif

    return [row, col, vert, hor]
endfunction
nnoremap <C-A> :call ToggleTerminal(&columns - 5, 20)<CR>
let g:tex_flavor='latex'
let g:vimtex_view_method='zathura'
let g:vimtex_quickfix_mode=0
set conceallevel=1
let g:tex_conceal='abdmg'
let g:vimtex_view_method = 'sioyek'
let g:vimtex_compiler_method = 'tectonic'


lua << EOF
require("snips")
require("lua_conf")
EOF
function DetectGoHtmlTmpl()
    if expand('%:e') == "html" && search("{{") != 0
        setfiletype gohtmltmpl
    endif
endfunction

augroup filetypedetect
    " gohtmltmpl
    au BufRead,BufNewFile *.html call DetectGoHtmlTmpl()
augroup END

