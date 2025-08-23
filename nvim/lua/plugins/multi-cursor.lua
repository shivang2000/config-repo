return {
  {
    "mg979/vim-visual-multi",
    branch = "master",
    init = function()
      vim.g.VM_default_mappings = 0
      vim.g.VM_maps = {
        ["Find Under"]       = "<C-n>",
        ["Find Subword Under"] = "<C-n>",
        ["Select All"]       = "<C-a>",
        ["Skip"]             = "<C-x>",
        ["Remove Region"]    = "<C-q>",
        ["Undo"]             = "u",
        ["Redo"]             = "<C-r>",
      }
    end,
  },
}
