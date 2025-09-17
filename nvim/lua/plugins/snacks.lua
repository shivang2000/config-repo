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
      notifier = {
        enabled = true,
        timeout = 10000,
        width = { min = 40, max = 0.4 },
        height = { min = 1, max = 0.6 },
        -- Position options: "top", "bottom", "left", "right", "top_left", "top_right", "bottom_left", "bottom_right"
        margin = { top = 0, right = 1, bottom = 0 },
        padding = true,
        sort = { "level", "added" },
        level = vim.log.levels.TRACE,
        icons = {
          error = " ",
          warn = " ",
          info = " ",
          debug = " ",
          trace = " ",
        },
        style = "fancy", -- "compact" | "fancy" | "minimal"
        top_down = true, -- true for top-down, false for bottom-up
        date_format = "%R", -- timestamp format
        -- Change notification position here:
        anchor = "n", -- "nw" | "ne" | "sw" | "se" | "n" | "s" | "w" | "e"
        -- nw = top-left, ne = top-right, sw = bottom-left, se = bottom-right
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
