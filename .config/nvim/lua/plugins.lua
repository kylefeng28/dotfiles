-- See: https://github.com/nanotee/nvim-lua-guide

-- Install lazy.nvim
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  vim.fn.system({ 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- Small shim to help migrate packer.nvim to lazy.nvim
function setup_plugins()
  plugins = {}
  function use(plugin_spec)
    plugins[#plugins + 1] = plugin_spec
  end

  -- in Tim Pope we trust
  use 'tpope/vim-sensible'     -- better default settings
  use 'tpope/vim-unimpaired'   -- better default mappings
  use 'tpope/vim-surround'     -- quoting/parenthesizing made simple
  use 'tpope/vim-repeat'       -- required to support `.` with some plugins
  use 'tpope/vim-characterize' -- `ga` gets the Unicode description of a char

  use 'tpope/vim-eunuch'
  vim.g.eunuch_no_maps = 1
  use 'tpope/vim-fugitive'

  use 'nvim-lua/plenary.nvim'

  use 'sbulav/nredir.nvim'

  -- Highlight yank
  -- Formerly provided by https://github.com/machakann/vim-highlightedyank
  -- Highlight groups: Visual or IncSearch. Some themes use HighlightedyankRegion
  vim.cmd [[
    autocmd TextYankPost * silent! lua vim.highlight.on_yank { 'Visual', timeout=200 }
  ]]

  -- Highlight undo/redo
  -- Highlight groups: HighlightUndo, HighlightRedo
  use { 'tzachar/highlight-undo.nvim',
    config = function() require('highlight-undo').setup({
      duration = 300
    })
    end,
    keys = { { 'u' }, { '<C-r>' }, { 'p' }, { 'P' } }
  }

  -- start screen
  use 'mhinz/vim-startify'
  vim.g.startify_session_persistence = 1

  -- Local vimrc
  use 'embear/vim-localvimrc'
  vim.g.localvimrc_persistent = 1

  -- Undotree
  use 'mbbill/undotree'

  -- Search Index
  use 'google/vim-searchindex'
  -- use 'henrik/vim-indexed-search'

  -- nvim-tree
  use { 'nvim-tree/nvim-tree.lua',
    cmd = { 'NvimTreeToggle', 'NvimTreeOpen', 'NvimTreeFocus', 'NvimTreeFindFileToggle' },
    event = 'User DirOpened',
    config = function()
      require('nvim-tree').setup {
        filters = {
          dotfiles = true,
        },
      }
    end
  }

  vim.keymap.set('n', '<C-n>', '<cmd>NvimTreeToggle<CR>', {})
  vim.keymap.set('n', '<Leader>e', '<cmd>NvimTreeFocus<CR>', {})

  -- NERD Commenter
  use 'scrooloose/nerdcommenter'
  vim.g.NERDCreateDefaultMappings = 0
  vim.g.NERDSpaceDelims = 1
  vim.g.NERDCompactSexyComs = 1
  vim.g.NERDDefaultAlign = 'left'
  -- <C-/>
  vim.cmd [[
  map <C-_> <Plug>NERDCommenterToggle
  imap <C-_> <C-o><Plug>NERDCommenterToggle
  ]]
 
  -- telescope
  use { 'nvim-telescope/telescope.nvim', tag = '0.1.6',
    config = function()
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<Leader>:', builtin.commands, {})
      vim.keymap.set('n', '<Leader>?', builtin.help_tags, {})
      vim.keymap.set('n', '<C-t>', builtin.find_files, {})
      vim.keymap.set('n', '<C-x>b', builtin.buffers, {})
    end
  }

  -- harpoon
  use { 'ThePrimeagen/harpoon', branch = 'harpoon2' }

  -- fzf
  use { 'junegunn/fzf', build = ':call fzf#install()' }
  use { 'junegunn/fzf.vim' }

  vim.cmd [[
  nmap <C-t> :Files<CR>
  nmap <C-x>b :Buffers<CR>

  " Mapping selecting mappings
  nmap <Leader><Tab> <Plug>(fzf-maps-n)
  xmap <Leader><Tab> <Plug>(fzf-maps-x)
  omap <Leader><Tab> <Plug>(fzf-maps-o)

  " Advanced customization using autoload functions
  inoremap <expr> <c-x><c-k> fzf#vim#complete#word({'down': '15%'})
  ]]

  -- Git Gutter
  use 'airblade/vim-gitgutter'

  use 'w0rp/ale'

  use 'easymotion/vim-easymotion'
  vim.g.EasyMotion_do_mapping = 0
  vim.cmd [[
  map <Leader>jj <Plug>(easymotion-bd-f)
  nmap <Leader>jj <Plug>(easymotion-overwin-f)

  map <Leader>jl <Plug>(easymotion-lineforward)
  map <Leader>jh <Plug>(easymotion-linebackward)
  ]]

  -- Colors
  use { 'catppuccin/nvim', name = 'catppuccin', priority = 900 }

  -- Lualine
  use { 'nvim-lualine/lualine.nvim',
    dependencies = {
      'nvim-tree/nvim-web-devicons'
    },

    config = function()
      require('lualine').setup {
        options = {
          theme = 'catppuccin'
        }
      }
    end
  }

  use 'christoomey/vim-tmux-navigator' -- tmux integration

  use { 'windwp/nvim-autopairs',
    -- Some weird interaction happens between vim-eunuch and nvim-autopairs when using <CR> in insert mode
    -- - Using map_cr = false fixes this
    -- https://github.com/hrsh7th/nvim-cmp/issues/871
    -- https://github.com/hrsh7th/nvim-cmp/issues/858
    config = function() require('nvim-autopairs').setup { map_cr = false } end
  }

  use 'editorconfig/editorconfig-vim'
  use 'bkad/CamelCaseMotion'
  vim.g.camelcasemotion_key = ','

  -- Treesitter
  use { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' }
  use 'p00f/nvim-ts-rainbow' -- Rainbow parentheses

  -- vimwiki
  use { 'vimwiki/vimwiki', keys = { { '<Leader>ww', '<Plug>VimwikiIndex<CR>' } } }
  vim.cmd [[
  let g:vimwiki_list = [{'path': '~/vimwiki/', 'syntax': 'markdown', 'ext': '.wiki'}]
  autocmd FileType vimwiki syntax on
  ]]

  -- Indent level lines
  use { 'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    config = function()
      require('ibl').setup {
        scope = {
          enabled = true,
          show_end = true
        }
      }
    end
  }

-- Damian Conway -- More Instantly Better Vim
-- https://www.youtube.com/watch?v=aHm36-na4-4
-- 'dir': '~/.vim/bundle/morevim'
--
-- TODO FIXME
-- use 'thoughtstream/Damian-Conway-s-Vim-Setup', { 'rtp': 'plugin' }

  use 'Mariappan/vim-dragvisuals'
  vim.cmd [[
  vmap <expr> <Left>  DVB_Drag('left')
  vmap <expr> <Right> DVB_Drag('right')
  vmap <expr> <Down>  DVB_Drag('down')
  vmap <expr> <Up>    DVB_Drag('up')
  vmap <expr> D       DVB_Duplicate()
  ]]

  -- plist editor (macOS only)
  if vim.fn.has('mac') == 1 then
    use 'darfink/vim-plist'
    vim.g.plist_display_format = 'xml'
  end

  -- Polyglot - A collection of language packs for Vim
  use 'sheerun/vim-polyglot'
  vim.opt.shortmess:remove('A') -- workaround for https://github.com/sheerun/vim-polyglot/issues/765

  return plugins
end

require('lazy').setup(setup_plugins())

require('nvim-treesitter.configs').setup {
  ensure_installed = { 'c', 'lua', 'vim' },
  sync_install = false,

  highlight = {
    enable = true
  },
  rainbow = {
    enable = true,
    extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
    max_file_lines = nil, -- Do not enable for files with more than n lines, int
  }
}

vim.cmd.colorscheme 'catppuccin-frappe'
