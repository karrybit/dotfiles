local languages = {
  "bash",
  "c",
  "css",
  "dockerfile",
  "go",
  "gomod",
  "graphql",
  "html",
  "javascript",
  "json",
  "lua",
  "markdown",
  "markdown_inline",
  "python",
  "regex",
  "ruby",
  "rust",
  "sql",
  "terraform",
  "toml",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
  "yaml",
}

return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = function()
    require("nvim-treesitter").install(languages):wait(300000)
  end,
  config = function()
    require("nvim-treesitter").setup()

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("UserTreesitter", { clear = true }),
      pattern = languages,
      callback = function()
        pcall(vim.treesitter.start)
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end,
}
