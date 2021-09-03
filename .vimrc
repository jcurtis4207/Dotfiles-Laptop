let mapleader = " "
" Beginning of line
nnoremap <Leader>a ^
" Call Tabularize and take single character parameter
xnoremap <Leader>b :call Tabular()<CR>
" End of line
nnoremap <Leader>e $
" Display vimrc bindings
nnoremap <Leader>kk :! less ~/.vimrc<CR>
" Open file in new split
nnoremap <Leader>o :vs 
" Save and exit
nnoremap <Leader>q :wq<CR>
" Run shellcheck on current file
map <Leader>s :!clear && shellcheck %<CR>
" Toggle line wrapping
nnoremap <Leader>t :call ToggleWrap()<CR>
" Open vifm and open in split
nnoremap <Leader>vo :Vifm<CR>
nnoremap <Leader>vs :VsplitVifm<CR>
" Save
nnoremap <Leader>w :w<CR>
" Better Escape
inoremap jf <Esc>
" Move lines
vnoremap <leader>j :m '>+1<CR>gv=gv
vnoremap <leader>k :m '<-2<CR>gv=gv
nnoremap <leader>j :m .+1<CR>==
nnoremap <leader>k :m .-2<CR>==
" Control + hjkl in Insert Mode
inoremap <C-k> <up>
inoremap <C-j> <down>
inoremap <C-h> <left>
inoremap <C-l> <right>
" Demap arrow keys and scroll
nnoremap <Up> <nop>
nnoremap <Down> <nop>
nnoremap <Left> <nop>
nnoremap <Right> <nop>
inoremap <Up> <nop>
inoremap <Down> <nop>
inoremap <Left> <nop>
inoremap <Right> <nop>

" gcc comments a line
" space+c comments a paragraph or highlighted section
nmap <Leader>c gcap
vmap <Leader>c gc

" Tabs
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
set autoindent

syntax enable   " syntax highlighting
"set number      " line numbers
set number relativenumber " relative numbers
set scrolloff=8 " scroll offset
set incsearch   " search as you type
set nowrap      " default wrapping off

set nocompatible
filetype indent on
filetype on
filetype plugin indent on

" Install Plugins
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'itchyny/lightline.vim'
Plugin 'vifm/vifm.vim'
Plugin 'ap/vim-css-color'
Plugin 'tpope/vim-commentary'
Plugin 'godlygeek/tabular'
Plugin 'junegunn/rainbow_parentheses.vim'
call vundle#end()

" Setup Rainbow
let g:rainbow#max_level = 16
let g:rainbow#blacklist = ['SlateBlue']
let g:rainbow#pairs = [['(', ')'], ['[', ']'], ['{', '}']]
autocmd VimEnter * RainbowParentheses

" Setup Lightline
set laststatus=2
let g:lightline = {
	\ 'colorscheme': 'wombat',
	\ }

" Splits Navigation
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
set splitbelow
set splitright

" Toggle Line Wrapping
function ToggleWrap()
    if (&wrap == 1)
        set nowrap
    else
        set wrap
    endif
endfunction

" Call difficult-to-type-ass Tabularize and take delimiter input
function Tabular() range
     let c = getchar()
     execute ':Tabularize /' . nr2char(c)
endfunction
