return {
  -- Surround (replaces vim-surround)
  {
    "kylechui/nvim-surround",
    version = "*",
    event   = "VeryLazy",
    config  = function() require("nvim-surround").setup({}) end,
  },

  -- Git
  { "tpope/vim-fugitive", cmd = { "Git", "G" } },
  { "tpope/vim-rhubarb",  dependencies = { "tpope/vim-fugitive" } },

  -- Icons (shared dependency)
  { "nvim-tree/nvim-web-devicons", lazy = true },
}
