" ~/.vimrc

" General
set nocompatible
set number
set wrap

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
