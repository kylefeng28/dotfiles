-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.autoformat = false -- disable format on save. default: true
vim.g.snacks_animate = false -- disable animations. default: true

local opt = vim.opt
opt.autowrite = false -- default: false
opt.clipboard = "" -- don't yank to system clipboard
opt.confirm = false -- don't prompt Y/N to save changes on exit (use default vim prompt)

-- Don't display whitespace characters by default; we can toggle with backslash (\)
opt.list = false
vim.cmd [[
set listchars=eol:¬,tab:⇥\ ,trail:·,extends:›,precedes:‹,space:␣
nmap \ :set list!<CR>
]]
