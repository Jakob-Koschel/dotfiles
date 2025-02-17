syntax on
filetype plugin indent on

let g:coc_global_extensions = [
\ 'coc-json',
\ 'coc-tsserver',
\ 'coc-html',
\ 'coc-css',
\ 'coc-yaml',
\ 'coc-clangd',
\ 'coc-pyright',
\ 'coc-ltex',
\ ]

lua << EOF
require("config.lazy")
EOF

lua << EOF
require("mason").setup()
EOF

colorscheme vim

" Softtabs, 2 spaces
set tabstop=2
set shiftwidth=2
set shiftround
set expandtab

" Make it obvious where 120 characters is
set textwidth=80
set formatoptions=qrn1
set wrapmargin=0
set colorcolumn=+1

" Always show signcolumn (git diffs & linter errors) to avoid shifting to the right)
set signcolumn=yes

" latex files should only have a width of 80
autocmd Filetype tex set textwidth=80

" Numbers
set number
set numberwidth=5

" remap <leader> to ,
let mapleader = ","

" disable mouse
set mouse=

" Open new split panes to right and bottom, which feels more natural
" set splitbelow
set splitright

"Use enter to create new lines w/o entering insert mode
nnoremap <CR> o

"Use mac clipboard
set clipboard=unnamed

"Use UTF-8
set encoding=utf-8

" use zsh internally
set shell=zsh

set termguicolors

" pasting over a selection should not change the buffer (to paste the same thing again later)
vnoremap p "_dP

" fix pink on pink popups with coc warnings/errors
highlight Pmenu ctermfg=15 ctermbg=0 guifg=#ffffff guibg=#000000

" vim-signify
let g:signify_sign_change = '~'

" coc.nvim
let g:coc_config_home = '~/.config/coc'

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Remap keys for applying code actions at the cursor position
nmap <leader>ac  <Plug>(coc-codeaction-cursor)

" use arrow keys for resizing
nnoremap <Up>    :resize -2<CR>
nnoremap <Down>  :resize +2<CR>
nnoremap <Left>  :vertical resize -2<CR>
nnoremap <Right> :vertical resize +2<CR>

" fzf
let g:fzf_preview_command = 'bat --color=always --plain {-1}' "

" mimic CtrlP
nmap <C-P> :FZF<CR>

" set background black for VimR
highlight Normal guibg=black guifg=white

" if Session.vim exists, please restore it
fu! RestoreSession()
if filereadable(getcwd() . '/Session.vim')
    execute 'so ' . getcwd() . '/Session.vim'
endif
endfunction

autocmd VimEnter * nested if eval("@%") == "" | call RestoreSession() | endif
