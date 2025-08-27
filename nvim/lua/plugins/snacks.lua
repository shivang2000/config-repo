return {
  {
    "folke/snacks.nvim",
    opts = {
      explorer = {
        hidden = true, -- always show dotfiles (e.g. .gitignore, .env)
        ignored = true, -- also show gitignored files
      },
      picker = {
        sources = {
          files = { hidden = true, ignored = true },
          grep = { hidden = true, ignored = true },
        },
      },
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
