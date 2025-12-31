return {
  {
    "folke/snacks.nvim",
    opts = {
      -- Disable input UI override since dressing.nvim handles it (for avante.nvim)
      input = { enabled = false },
      explorer = {
        hidden = true, -- always show dotfiles (e.g. .gitignore, .env)
        ignored = true, -- also show gitignored files
      },
      picker = {
        sources = {
          files = { hidden = true, ignored = true },
          grep = { hidden = true, ignored = true },
        },
        -- Don't override vim.ui.select since dressing.nvim handles it
        ui_select = false,
      },
      -- Disable notifier since noice.nvim + nvim-notify handle notifications
      notifier = { enabled = false },
    },
    keys = {
      {
        "<space>e",
        function()
          -- force these on every open, ignoring any weird defaults
          Snacks.explorer({ hidden = true, ignored = true, follow = true })
        end,
        desc = "Explorer (Snacks)",
      },
    },
  },
}
