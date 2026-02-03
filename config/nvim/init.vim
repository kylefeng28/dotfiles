" ~/.vim/init.vim
" ~/.config/nvim/init.vim

" Disable netrw in favor of nvim-tree
let g:loaded_netrw = 1
let g:loaded_netrwPlugin = 1

let $VIM_CONFIG = has('nvim') ? stdpath('config') : '~/.vim'

source $VIM_CONFIG/settings.vim " generic Vim/Neovim settings
source $VIM_CONFIG/mappings.vim " key mappings

filetype plugin indent on

" Plugin configuration: See ~/.vim/lua/plugins.lua
" Don't load for git commit messages / rebase and in VS code
if !empty($GIT_EXEC_PATH) || !exists('g:vscode')
  lua require('plugins')
endif

" Convenient vimrc commands
nmap <Leader>E :edit $MYVIMRC<CR>
nmap <Leader>R :source $MYVIMRC<CR>
nmap <Leader>P :edit $VIM_CONFIG/lua/plugins.lua<CR>
nmap <Leader>M :edit $VIM_CONFIG/mappings.vim<CR>
nmap <Leader>I :Lazy<CR>

" Execute selection as vim command
command! -bar -range VimEval execute <line1> . ',' . <line2> . 'y|@"'
command! -bar -range LuaEval <line1>,<line2> call s:luaeval_selection(<line1>, <line2>)

function! s:luaeval_selection(start, end) range
	let s = join(getline(a:start, a:end), '\n')
	let command = "lua << EOF\n" . s . "\nEOF"
	echo command
	redir => result
	execute command
	redir END
	echo result
endfunction

" Filetypes {{{
augroup Filetypes
	autocmd!
	" 'ts'='tabstop', 'sts'='softtabstop', 'sw'='shiftwidth'

	" Indent-sensitive languages have cursor column highlighting
	autocmd BufNewFile,BufRead *.yaml,*.yml,*.py setlocal cursorcolumn

	" ES6 and Vue syntax hack
	autocmd BufNewFile,BufRead *.es6 setfiletype javascript
	autocmd BufNewFile,BufRead *.vue setfiletype html

	" .md files are markdown files
	autocmd BufNewFile,BufRead *.md setlocal ft=markdown

	" Treat .rss files as XML
	autocmd BufNewFile,BufRead *.rss setfiletype xml

	" .twig files use HTML syntax
	" autocmd BufNewFile,BufRead *.twig setlocal ft=html

	" .styl files use Stylus syntax
	autocmd BufNewFile,BufReadPost *.styl setlocal ft=stylus
	autocmd BufNewFile,BufReadPost *.css setlocal ft=css
	autocmd BufNewFile,BufRead *.styl setlocal ft=stylus

	" .pde files use Processing syntax
	autocmd BufNewFile,BufRead *.pde setlocal ft=processing

	" Treat .vs and .fs files GLSL shaders
	autocmd BufNewFile,BufRead *.vs,*.fs setlocal ft=processing

	" Support JSONC (JSON w/ comments)
	autocmd FileType json syntax match Comment +\/\/.\+$+
augroup END
" }}}

" Sources
" https://github.com/SirVer/ultisnips/issues/509#issuecomment-109661711
