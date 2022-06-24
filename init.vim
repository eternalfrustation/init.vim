set nu
set mouse=a
set clipboard^=unnamed,unnamedplus
set autochdir
if &compatible
  set nocompatible               " Be iMproved
endif
let g:SuperTabDefaultCompletionType="<C-x><C-o>"
let g:neovide_refresh_rate=30
let g:terminal_type="xterm"
let g:neovide_floating_blur_amount_x = 2.0
let g:neovide_floating_blur_amount_y = 2.0
" press <Tab> to expand or jump in a snippet. These can also be mapped separately
" via <Plug>luasnip-expand-snippet and <Plug>luasnip-jump-next.
imap <silent><expr> <Tab> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>' 
" -1 for jumping backwards.
inoremap <silent> <S-Tab> <cmd>lua require'luasnip'.jump(-1)<Cr>

snoremap <silent> <Tab> <cmd>lua require('luasnip').jump(1)<Cr>
snoremap <silent> <S-Tab> <cmd>lua require('luasnip').jump(-1)<Cr>

" For changing choices in choiceNodes (not strictly necessary for a basic setup).
imap <silent><expr> <C-E> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-E>'
smap <silent><expr> <C-E> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-E>'

" Required:
filetype plugin indent on
syntax enable
colorscheme dracula
set guifont=Hasklug\ NF:h13
let g:lightline = {
			\ 'colorscheme' : 'dracula'
			\}
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
lua << EOF
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

local on_attach = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  local bufopts = { noremap=true, silent=true, buffer=bufnr}
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<space>f', vim.lsp.buf.format, bufopts)
end
vim.cmd [[autocmd! ColorScheme * highlight NormalFloat guibg=#1f2335]]
vim.cmd [[autocmd! ColorScheme * highlight FloatBorder guifg=white guibg=#1f2335]]

local border = {
      {"🭽", "FloatBorder"},
      {"▔", "FloatBorder"},
      {"🭾", "FloatBorder"},
      {"▕", "FloatBorder"},
      {"🭿", "FloatBorder"},
      {"▁", "FloatBorder"},
      {"🭼", "FloatBorder"},
      {"▏", "FloatBorder"},
}
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = opts.border or border
  return orig_util_open_floating_preview(contents, syntax, opts, ...)
end
local servers = { "gopls", "rls" }
for _, lsp in ipairs(servers) do
  require('lspconfig')[lsp].setup {
    on_attach = on_attach,
    flags = lsp_flags
  }
end
require("nvim-tree").setup({
      auto_reload_on_write = true,
      hijack_cursor = true,
      hijack_netrw = true,
      update_cwd = true,
      open_on_setup_file = true,
      respect_buf_cwd = true,
      sort_by = "extension",
      update_focused_file = {
	      enable = true,
	      update_root = true,
      },
      view = {
        adaptive_size = true,
        mappings = {
          list = {
            { key = "u", action = "dir_up" },
          },
        },
      },
      renderer = {
        group_empty = true,
      },
      filters = {
        dotfiles = true,
      },
      actions = {
        use_system_clipboard = true,
        change_dir = {
          enable = true,
          global = false,
          restrict_above_cwd = false,
        },
        expand_all = {
          max_folder_discovery = 300,
        },
        open_file = {
          quit_on_open = false,
          resize_window = true,
          window_picker = {
            enable = true,
            chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
            exclude = {
              filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
              buftype = { "nofile", "terminal", "help" },
            },
          },
        },
        remove_file = {
          close_window = true,
        },
      },
})
EOF

