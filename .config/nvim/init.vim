" ~/.vim/init.vim
" ~/.config/nvim/init.vim
"
" Disable netrw in favor of nvim-tree
let g:loaded_netrw = 1
let g:loaded_netrwPlugin = 1

source ~/.vim/settings.vim " generic Vim/Neovim settings
source ~/.vim/mappings.vim " key mappings

filetype plugin indent on

" Plugin configuration
lua << EOF
require('plugins') -- See ~/.vim/lua/plugins.lua
EOF

nmap <Leader>P :edit ~/.vim/lua/plugins.lua<CR>
nmap <Leader>I :Lazy<CR>

" Execute selection as vim command
command! -bar -range VimEval execute <line1> . ',' . <line2> . 'y|@"'

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
