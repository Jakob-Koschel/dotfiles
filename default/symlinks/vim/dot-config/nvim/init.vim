syntax on
filetype plugin indent on

" plugin manager
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

let g:coc_global_extensions = [
\ 'coc-json',
\ 'coc-tsserver',
\ 'coc-html',
\ 'coc-css',
\ 'coc-yaml',
\ 'coc-clangd',
\ 'coc-pyright',
\ ]

call plug#begin()

Plug 'tpope/vim-sensible'
Plug 'tpope/vim-fugitive'

" keep session files to restore sessions after tmux restart
Plug 'tpope/vim-obsession'

Plug 'christoomey/vim-tmux-navigator'
Plug 'tpope/vim-tbone'
Plug 'Jakob-Koschel/vim-tmux-clipboard'

" make vim understand file:line
Plug 'wsdjeg/vim-fetch'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'neoclide/coc.nvim', { 'branch': 'release' , 'do': { -> coc#util#install() } }

Plug 'mhinz/vim-signify'
Plug 'vim-airline/vim-airline'

" better detection of intendation
Plug 'tpope/vim-sleuth'

Plug 'ahf/cocci-syntax'

Plug 'lervag/vimtex'

" add editorconfig (should be builtin with neovim 0.9)
Plug 'gpanders/editorconfig.nvim'

" split text by sentences and length
Plug 'whonore/vim-sentencer'

call plug#end()

" Softtabs, 2 spaces
set tabstop=2
set shiftwidth=2
set shiftround
set expandtab

" Make it obvious where 120 characters is
set textwidth=120
set formatoptions=qrn1
set wrapmargin=0
set colorcolumn=+1

" latex files should only have a width of 80
autocmd Filetype tex set textwidth=80

" Numbers
set number
set numberwidth=5

" Open new split panes to right and bottom, which feels more natural
" set splitbelow
set splitright

"Use enter to create new lines w/o entering insert mode
nnoremap <CR> o

"Use mac clipboard
set clipboard=unnamed

"Use UTF-8 for YouCompleteMe
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
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

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
