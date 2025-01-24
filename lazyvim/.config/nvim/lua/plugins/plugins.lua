local function disable(plugin_name)
  return { plugin_name, enabled = false }
end

return {
  -- Configure LazyVim to load Catppuccin
  { "catppuccin/nvim", name = "catppuccin", priority = 900 },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },

  -- Use mini.starter instead of alpha
  { import = "lazyvim.plugins.extras.ui.mini-starter" },

  -- Add jsonls and schemastore packages, and setup treesitter for json, json5 and jsonc
  { import = "lazyvim.plugins.extras.lang.json" },

  -- Disable default LazyVim plugins
  disable "folke/noice.nvim", -- no floating cmdline (use regular ex mode)
  disable "folke/flash.nvim", -- restore "s" for changing a single character

  -- Highlight undo/redo: Extremely useful in conjunction with builtin vim.highlight.on_yank
  -- Highlight groups for yank: Visual or IncSearch (Some themes use HighlightedyankRegion)
  -- Highlight groups for undo/redo: HighlightUndo, HighlightRedo
  {
    "tzachar/highlight-undo.nvim",
    config = function() require("highlight-undo").setup({
      duration = 300
    })
    end,
    keys = { { "u" }, { "<C-r>" }, { "p" }, { "P" } }
  },

}

