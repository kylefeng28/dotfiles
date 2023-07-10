" ~/.vimrc

" General
set nocompatible " it's not the 1970s anymore, so kick vim a couple decades into the new millenium
set number " show line number
set wrap " wrap lines
set backspace=indent,eol,start " make backspace key work

set mouse=a " comment out if causing issues

let mapleader="\<Space>"

" Search
set incsearch hlsearch
set ignorecase smartcase
set showmatch

" Make j and k navigate visual lines (i.e. when a line is wrapped)
noremap j gj
noremap k gk
noremap gj j
noremap gk k

" Paste
nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>
set showmode

filetype plugin indent on

" Plugins {{{
" Automatically install vim-plug
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()

" vim-oscyank: Copy lines to clipboard
Plug 'ojroques/vim-oscyank'
nmap <Leader>c <Plug>OSCYankOperator
nmap <Leader>cc <Leader>c_
vmap <Leader>c <Plug>OSCYankVisual

call plug#end()

" }}}
