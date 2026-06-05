return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    bigfile = { enabled = true },
    explorer = { enabled = true },
    input = { enabled = true },
    notifier = { enabled = true },
    picker = {
      enabled = true,
      sources = {
        explorer = {
          hidden = true,
          ignored = true,
        },
        files = {
          hidden = true,
        },
      },
    },
    quickfile = { enabled = true },
    terminal = {
      enabled = true,
      win = {
        position = "bottom",
        height = 12,
      },
    },
    words = { enabled = true },
  },
  config = function(_, opts)
    require("snacks").setup(opts)
    vim.ui.input = Snacks.input.input
    vim.ui.select = Snacks.picker.select
  end,
  keys = {
    { "<leader>e", function() Snacks.explorer.open() end, desc = "Explorer" },
    { "<leader>E", function() Snacks.explorer.reveal() end, desc = "Reveal file" },
    { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
    { "<leader>ff", function() Snacks.picker.files() end, desc = "Find files" },
    { "<leader>fg", function() Snacks.picker.grep() end, desc = "Grep" },
    { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
    { "<leader>fh", function() Snacks.picker.help() end, desc = "Help" },
    { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent files" },
    { "<leader>o", function() Snacks.picker.lsp_symbols() end, desc = "Document symbols" },
    { "<leader>s", function() Snacks.picker.lsp_workspace_symbols() end, desc = "Workspace symbols" },
    { "<leader>t", function() Snacks.terminal.toggle() end, desc = "Terminal", mode = { "n", "t" } },
  },
}
