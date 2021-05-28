let mapleader = " "
" Open file in new split
nnoremap <Leader>o :vs 
" Toggle line wrapping
nnoremap <Leader>t :call ToggleWrap()<CR>
" Remap beginning/end of line keys
nnoremap <Leader>a ^
nnoremap <Leader>e $
" Open vifm and open in split
nnoremap <Leader>vv :Vifm<CR>
nnoremap <Leader>vs :VsplitVifm<CR>
" Remap save and exit
nnoremap <Leader>w :w<CR>
nnoremap <Leader>q :wq<CR>
" Remap arrow keys and better escape
nnoremap <Up> <nop>
nnoremap <Down> <nop>
nnoremap <Left> <nop>
nnoremap <Right> <nop>
inoremap jf <Esc>

" gcc comments a line
" gc comments a highlighted section
" space+c comments a paragraph
nmap <Leader>c gcap

nnoremap <C-p> :Files<CR>

" Tabs
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
set autoindent

syntax enable " syntax highlighting
set number " line numbers
set scrolloff=8 " scroll offset
set incsearch " search as you type
set nowrap " default wrapping off

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
Plugin 'Raimondi/delimitMate'
call vundle#end()

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
