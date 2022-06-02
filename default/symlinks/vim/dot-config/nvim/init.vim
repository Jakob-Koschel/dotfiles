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

Plug 'christoomey/vim-tmux-navigator'
Plug 'tpope/vim-tbone'
Plug 'roxma/vim-tmux-clipboard'

" make vim understand file:line
Plug 'wsdjeg/vim-fetch'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'neoclide/coc.nvim', { 'branch': 'release' , 'do': { -> coc#util#install() } }

Plug 'yuki-yano/fzf-preview.vim', { 'branch': 'release/rpc' }

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

let s:fzf_preview_current_preview = ''
let s:valid_fzf_previews = [
\ 'FZF',
\ 'FzfPreviewProjectFiles',
\ 'FzfPreviewGitFilesRpc',
\ 'FzfPreviewFromResourcesRpc project_mru git',
\ 'FzfPreviewProjectGrepRpc rg',
\ 'FzfPreviewGitStatusRpc'
\ ]
function! <SID>fzf_preview_open(command) abort
  if index(s:valid_fzf_previews, a:command) >= 0
    let s:fzf_preview_current_preview = a:command
    execute a:command
  endif
endfunction

function! <SID>fzf_preview_toggle_next_preview() abort
    execute "q"

    let l:index = 0
    if s:fzf_preview_current_preview != ''
      let l:index = index(s:valid_fzf_previews, s:fzf_preview_current_preview)+1
      " rotate back once end is reached
      if l:index >= len(s:valid_fzf_previews)
        let l:index = 0
      endi
    endif
    call <SID>fzf_preview_open(s:valid_fzf_previews[l:index])
endfunction

" mimic CtrlP
nmap <C-P> :call <SID>fzf_preview_open('FZF')<CR>
" toggle to next preview
autocmd FileType fzf tnoremap <silent> <C-P> <C-\><C-n>:call <SID>fzf_preview_toggle_next_preview()<CR>

nnoremap <silent> [fzf-p]p     :<C-u>FzfPreviewFromResourcesRpc project_mru git<CR>
nnoremap <silent> [fzf-p]gs    :<C-u>FzfPreviewGitStatusRpc<CR>
nnoremap <silent> [fzf-p]ga    :<C-u>FzfPreviewGitActionsRpc<CR>
nnoremap <silent> [fzf-p]b     :<C-u>FzfPreviewBuffersRpc<CR>
nnoremap <silent> [fzf-p]B     :<C-u>FzfPreviewAllBuffersRpc<CR>
nnoremap <silent> [fzf-p]o     :<C-u>FzfPreviewFromResourcesRpc buffer project_mru<CR>
nnoremap <silent> [fzf-p]<C-o> :<C-u>FzfPreviewJumpsRpc<CR>
nnoremap <silent> [fzf-p]g;    :<C-u>FzfPreviewChangesRpc<CR>
nnoremap <silent> [fzf-p]/     :<C-u>FzfPreviewLinesRpc --add-fzf-arg=--no-sort --add-fzf-arg=--query="'"<CR>
nnoremap <silent> [fzf-p]*     :<C-u>FzfPreviewLinesRpc --add-fzf-arg=--no-sort --add-fzf-arg=--query="'<C-r>=expand('<cword>')<CR>"<CR>
nnoremap          [fzf-p]gr    :<C-u>FzfPreviewProjectGrepRpc<Space>
xnoremap          [fzf-p]gr    "sy:FzfPreviewProjectGrepRpc<Space>-F<Space>"<C-r>=substitute(substitute(@s, '\n', '', 'g'), '/', '\\/', 'g')<CR>"
nnoremap <silent> [fzf-p]t     :<C-u>FzfPreviewBufferTagsRpc<CR>
nnoremap <silent> [fzf-p]q     :<C-u>FzfPreviewQuickFixRpc<CR>
nnoremap <silent> [fzf-p]l     :<C-u>FzfPreviewLocationListRpc<CR>
