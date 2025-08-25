-- lua/plugins/colors.lua (or any Lazy spec file)
return {
  {
    "EdenEast/nightfox.nvim",
    lazy = false,
    priority = 1000, -- load before others
    opts = {
      options = {
        transparent = true, -- <-- correct place for Nightfox
        terminal_colors = true,
        dim_inactive = false,
        styles = { comments = "italic" }, -- optional
      },
      -- Make common UI groups transparent
      groups = {
        all = {
          Normal = { bg = "NONE" },
          NormalNC = { bg = "NONE" },
          NormalFloat = { bg = "NONE" },
          FloatBorder = { bg = "NONE" },
          SignColumn = { bg = "NONE" },
          VertSplit = { bg = "NONE" },
          StatusLine = { bg = "NONE" },
          StatusLineNC = { bg = "NONE" },
          EndOfBuffer = { bg = "NONE" },
          CursorLine = { bg = "NONE" },
          CursorLineNr = { bg = "NONE" },
          LineNr = { bg = "NONE" },
          Pmenu = { bg = "NONE" },
          PmenuSel = { bg = "NONE" },
          TelescopeNormal = { bg = "NONE" },
          TelescopeBorder = { bg = "NONE" },
          NeoTreeNormal = { bg = "NONE" },
          NeoTreeNormalNC = { bg = "NONE" },
          LazyNormal = { bg = "NONE" },
          MasonNormal = { bg = "NONE" },
        },
      },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "carbonfox" },
  },
}
