return {
  "nvim-tree/nvim-tree.lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  lazy = false,
  config = function()
    require("nvim-tree").setup({
      view    = { width = 40 },
      filters = { dotfiles = false },
      renderer = { group_empty = true },
    })

    -- Auto-open when nvim is launched with no file arguments
    vim.api.nvim_create_autocmd("VimEnter", {
      callback = function()
        if vim.fn.argc() == 0 then
          require("nvim-tree.api").tree.open()
        end
      end,
    })
  end,
}
