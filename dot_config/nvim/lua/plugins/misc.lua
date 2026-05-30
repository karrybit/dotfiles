return {
  -- Surround (replaces vim-surround)
  {
    "kylechui/nvim-surround",
    version = "*",
    event   = "VeryLazy",
    config  = function() require("nvim-surround").setup({}) end,
  },

  -- Comment (replaces vim-commentary)
  {
    "numToStr/Comment.nvim",
    event  = { "BufReadPost", "BufNewFile" },
    config = function() require("Comment").setup({}) end,
  },

  -- Visually expand selection region
  { "terryma/vim-expand-region", event = "VeryLazy" },

  -- CamelCase / snake_case motions
  -- <leader>w, <leader>b, <leader>e mapped by plugin when camelcasemotion_key is set
  -- Using "," to avoid conflict with <leader>w (save file)
  {
    "bkad/CamelCaseMotion",
    event  = "VeryLazy",
    config = function() vim.g.camelcasemotion_key = "," end,
  },

  -- camelize / decamelize operator
  {
    "tyru/operator-camelize.vim",
    dependencies = { "kana/vim-operator-user" },
    event = "VeryLazy",
  },

  -- Git
  { "tpope/vim-fugitive", cmd = { "Git", "G" } },
  { "tpope/vim-rhubarb",  dependencies = { "tpope/vim-fugitive" } },

  -- GraphQL syntax
  { "jparise/vim-graphql", ft = { "graphql", "gql" } },

  -- Icons (shared dependency)
  { "nvim-tree/nvim-web-devicons", lazy = true },
}
