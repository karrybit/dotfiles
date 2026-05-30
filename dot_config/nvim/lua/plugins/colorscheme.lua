return {
  "ellisonleao/gruvbox.nvim",
  priority = 1000,
  config = function()
    vim.opt.background    = "dark"
    vim.opt.termguicolors = true
    require("gruvbox").setup({})
    vim.cmd("colorscheme gruvbox")
  end,
}
