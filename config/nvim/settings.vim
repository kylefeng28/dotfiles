" Core {{{
" No vi compatibility
set nocompatible

" Support all three file formats
set fileformats=unix,dos,mac

" Use UTF-8 by default
set fileencoding=utf8

" Split below and right
set splitbelow splitright

" Edit files in place
set backupcopy=yes

" Allow mouse functionality (only for vanilla vim)
set mouse=a
if !has('nvim')
	set ttymouse=xterm2
endif

" Persistent undo
if has('persistent_undo')
	set undodir=~/.local/share/nvim/undo
	set undofile
endif

" Spell check
if has('spell')
	set spelllang=en
	set spellfile=$HOME/spell/en.utf-8.add
	set spell
endif
" }}}

" Visual {{{
" Redraw only when needed
set lazyredraw

" Syntax highlighting
syntax enable

" Display keystrokes
set showcmd

" Folds
set foldmethod=marker

" Line numbers (hybrid mode)
set number relativenumber

" True colors
if has('termguicolors')
	set termguicolors
endif

" Conceal
if has('conceal')
	set concealcursor=c
	set conceallevel=2
endif

" Disable relative numbering when in insert mode and when lost focus
augroup HybridNumbering
	autocmd!
	autocmd InsertEnter * set norelativenumber number
	autocmd FocusLost   * set norelativenumber number
	autocmd CursorHold  * set norelativenumber number
	autocmd WinLeave    * set norelativenumber number

	autocmd FocusGained * set relativenumber number
	autocmd InsertLeave * set relativenumber number
	autocmd CursorMoved * set relativenumber number
	autocmd WinEnter    * set relativenumber number
augroup END

" Highlight current line
set cursorline

" Keep at least 5 lines around the cursor
set scrolloff=5

" Show statusline always
set laststatus=2

" Better display for messages
set cmdheight=2

" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=1000

" Don't give |ins-completion-menu| messages.
set shortmess+=c

" Show whitespace
if v:version >= 703
	set listchars=eol:¬,tab:⇥\ ,trail:·,extends:›,precedes:‹,space:␣
else
	set listchars=tab:..,trail:_,extends:>,precedes:<
endif
nmap \ :set list!<CR>

" Highlight trailing whitespace
highlight def link ExtraWhitespace Error
augroup ExtraWhitespace
	autocmd!
	autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
	autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
	autocmd InsertLeave * match ExtraWhitespace /\s\+$/
	autocmd BufWinLeave * call clearmatches()
augroup END

" Highlight todo, fixme
" highlight def MyTodo ctermfg=15 ctermbg=9 guifg=White guibg=Red
highlight def link MyTodo Error
" TODO Why doesn't this work?
syntax match MyTodo contained "\<\(FIXME\|NOTE\|TODO\|OPTIMIZE\|HACK\|REVIEW\|XXX\)"

" TODO
" https://stackoverflow.com/a/30552423
augroup vimrc_todo
	au!
	au Syntax * syn match MyTodo /\v<(FIXME|NOTE|TODO|OPTIMIZE|XXX)/
				\ containedin=.*Comment,vimCommentTitle
augroup END
hi def link MyTodo Todo

" }}}

" Searching {{{
" Incremental search and highlight all matches
set incsearch hlsearch

" Be smart about case
set ignorecase smartcase
" }}}

" Command line {{{
" Bash-style completion
set wildmenu
set wildmode=list:longest,full
" }}}

" Text editing {{{
" Tabs
set tabstop=4
set shiftwidth=4
set noexpandtab

" Auto indent
set autoindent

" Make every line break break the undo sequence
" In other words, undo 1 line at a time "
inoremap <CR> <C-g>u<CR>

" Yank without jank in visual mode
" Thanks to https://ddrscott.github.io/blog/2016/yank-without-jank/
vnoremap <expr>y "my\"" . v:register . "y`y"
vnoremap <expr>Y "my\"" . v:register . "Y`y"

" Enter select mode
imap <S-Left> <Esc>gh
imap <S-Right> <Esc>lgh<Right>
imap <S-Up> <Esc>gh<Up>
imap <S-Down> <Esc>gh<Down>

" }}}
