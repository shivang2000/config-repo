return {
  {
    "EdenEast/nightfox.nvim",
    opts = {
      transparent = true, -- removes background
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
    },
  },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "carbonfox",
    },
  },

  -- Ensure Normal highlight group is transparent
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      options = { theme = "auto" },
    },
  },

  -- Extra highlight override
  {
    "folke/tokyonight.nvim",
    opts = function(_, opts)
      vim.cmd([[
        hi Normal guibg=NONE ctermbg=NONE
        hi NormalFloat guibg=NONE ctermbg=NONE
        hi SignColumn guibg=NONE
      ]])
    end,
  },
}
