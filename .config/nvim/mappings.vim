" Set leader key as space
let mapleader="\<Space>"
" map <Space> <Leader>
" nnoremap <Space> <Nop>

" Recover from <CR>, <C-u>, and <C-w> in insert mode
inoremap <CR> <C-g>u<CR>
inoremap <C-u> <C-g>u<C-u>
inoremap <C-w> <C-g>u<C-w>

inoremap <C-g><CR> <CR>
inoremap <C-g><C-u> <C-u>
inoremap <C-g><C-w> <C-w>

" Make j and k navigate visual lines
noremap j gj
noremap k gk
noremap gj j
noremap gk k

" Toggle paste mode
" Usually, it's preferred to use the + register to paste
set pastetoggle=<F2>

" Tabs
noremap <C-w>t :tabnew<CR>
noremap <C-w><C-t> :tabnew<CR>
noremap <C-w><C-w> :tabclose<CR>

" CUA keybindings
nmap <C-S-s> :w<CR>
imap <C-S-s> <C-o>:w<CR>

" OS X keybindings (not currently supported)
nmap <D-S> :w<CR>
imap <D-S> <C-o>:w<CR>

" Tab movement
nmap <S-D-{> gT
nmap <S-D-}> gt

" Reloads .vimrc
nmap <Leader>R :source $MYVIMRC<CR>

" Opens .vimrc for editing
nmap <Leader>E :edit $MYVIMRC<CR>
nmap <Leader>M :edit ~/.vim/mappings.vim<CR>

" vim-tmux-navigator
" Window navigation
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l

" Mac OS X clipboard integration
" NO!!! Don't do this!! Pasting directly from the clipboard is dangerous!
" Instead, use the + register to copy/paste from the clipboard
" See this: https://security.stackexchange.com/questions/39118/how-can-i-protect-myself-from-this-kind-of-clipboard-abuse
" nmap <leader>cp :set paste<CR>:r !pbpaste<CR>:set nopaste<CR>
" nmap <leader>cc :w !pbcopy<CR><CR>

" Yank to clipboard register (shortcut since "+ is hard to type)
map gc "+

" Copy buffer to clipboard
" This is cross platform and should be safer
nmap <Leader>cc :%y+<CR>

" Trash register shortcut
nnoremap _ "_
vnoremap _ "_

" Mark location before search
nnoremap / ms/
nnoremap ? ms?

" Clear search results
nnoremap <silent> <Leader>/ :nohlsearch<CR>

" Easy line copying
" https://www.reddit.com/r/vim/comments/1yfzg2/does_anyone_actually_use_easymotion/cfkaxw5/
cnoremap /$y <CR>:y<CR>`s
cnoremap /$t <CR>:t's<CR>
cnoremap /$T <CR>:T's<CR>
cnoremap /$m <CR>:m's<CR>
cnoremap /$M <CR>:M's<CR>
cnoremap /$d <CR>:d<CR>`s

vnoremap <Leader>y :y<CR>`s
vnoremap <Leader>t :t's<CR>
vnoremap <Leader>m :m's<CR>

" Terminal mode
" Map escape to normal mode
if exists(':terminal')
	tnoremap <Esc> <C-\><C-n>
endif
