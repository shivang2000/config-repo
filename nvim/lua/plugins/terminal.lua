return {
  -- disable toggleterm
  {
    "akinsho/toggleterm.nvim",
    enabled = false,
  },

  -- enable snacks terminal
  {
    "folke/snacks.nvim",
    opts = {
      terminal = {
        enabled = true,
      },
    },
    keys = {
      {
        "<leader>ft",
        function()
          require("snacks").terminal.toggle("bottom")
        end,
        desc = "Toggle Terminal (bottom)",
      },
      {
        "<leader>fT",
        function()
          require("snacks").terminal.toggle("float")
        end,
        desc = "Toggle Terminal (float)",
      },
      {
        "<leader>fr",
        function()
          require("snacks").terminal.toggle("right")
        end,
        desc = "Toggle Terminal (right split)",
      },
    },
  },
}
