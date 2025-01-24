-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set
local unmap = vim.keymap.del
-- Restore gt/gT for navigating between tabs/buffers
map("n", "gt", "<cmd>BufferLineCycleNext<CR>", { desc = "Next Buffer" }) -- :bnext
map("n", "gT", "<cmd>BufferLineCyclePrev<CR>", { desc = "Prev Buffer" }) -- :bprev

-- Not in default vim, but useful
map("n", "<C-w>t", ":tabnew<CR>", { desc = "New Tab" })

-- Reset H/L
unmap("n", "H")
unmap("n", "L")
