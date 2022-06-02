syntax on
filetype plugin indent on

" plugin manager
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

let g:coc_global_extensions = [
\ 'coc-fzf-preview',
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

Plug 'christoomey/vim-tmux-navigator'
Plug 'tpope/vim-tbone'
Plug 'roxma/vim-tmux-clipboard'

" make vim understand file:line
Plug 'wsdjeg/vim-fetch'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'neoclide/coc.nvim', { 'branch': 'release' , 'do': { -> coc#util#install() } }

Plug 'mhinz/vim-signify'
Plug 'vim-airline/vim-airline'

" better detection of intendation
Plug 'tpope/vim-sleuth'

call plug#end()

" Automatically remove trailing whitespaces
autocmd BufWritePre * %s/\s\+$//e

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

" fix pink on pink popups with coc warnings/errors
highlight Pmenu ctermfg=15 ctermbg=0 guifg=#ffffff guibg=#000000

" vim-signify
let g:signify_sign_change = '~'

" coc.nvim
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" fzf
let g:fzf_preview_command = 'bat --color=always --plain {-1}' "

nmap <Leader>f [fzf-p]
xmap <Leader>f [fzf-p]

" mimic CtrlP
" nmap <C-P> :CocCommand fzf-preview.FromResources project_mru git<CR>
nmap <C-P> :CocCommand fzf-preview.GitFiles<CR>

nnoremap <silent> [fzf-p]p     :<C-u>CocCommand fzf-preview.FromResources project_mru git<CR>
nnoremap <silent> [fzf-p]gs    :<C-u>CocCommand fzf-preview.GitStatus<CR>
nnoremap <silent> [fzf-p]ga    :<C-u>CocCommand fzf-preview.GitActions<CR>
nnoremap <silent> [fzf-p]b     :<C-u>CocCommand fzf-preview.Buffers<CR>
nnoremap <silent> [fzf-p]B     :<C-u>CocCommand fzf-preview.AllBuffers<CR>
nnoremap <silent> [fzf-p]o     :<C-u>CocCommand fzf-preview.FromResources buffer project_mru<CR>
nnoremap <silent> [fzf-p]<C-o> :<C-u>CocCommand fzf-preview.Jumps<CR>
nnoremap <silent> [fzf-p]g;    :<C-u>CocCommand fzf-preview.Changes<CR>
nnoremap <silent> [fzf-p]/     :<C-u>CocCommand fzf-preview.Lines --add-fzf-arg=--no-sort --add-fzf-arg=--query="'"<CR>
nnoremap <silent> [fzf-p]*     :<C-u>CocCommand fzf-preview.Lines --add-fzf-arg=--no-sort --add-fzf-arg=--query="'<C-r>=expand('<cword>')<CR>"<CR>
nnoremap          [fzf-p]gr    :<C-u>CocCommand fzf-preview.ProjectGrep<Space>
xnoremap          [fzf-p]gr    "sy:CocCommand   fzf-preview.ProjectGrep<Space>-F<Space>"<C-r>=substitute(substitute(@s, '\n', '', 'g'), '/', '\\/', 'g')<CR>"
nnoremap <silent> [fzf-p]t     :<C-u>CocCommand fzf-preview.BufferTags<CR>
nnoremap <silent> [fzf-p]q     :<C-u>CocCommand fzf-preview.QuickFix<CR>
nnoremap <silent> [fzf-p]l     :<C-u>CocCommand fzf-preview.LocationList<CR>
