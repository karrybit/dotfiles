return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  cmd  = "Telescope",
  keys = {
    { "<leader>ff", "<cmd>Telescope find_files<cr>",              desc = "Find files" },
    { "<leader>fg", "<cmd>Telescope live_grep<cr>",               desc = "Live grep" },
    { "<leader>fb", "<cmd>Telescope buffers<cr>",                 desc = "Buffers" },
    { "<leader>fh", "<cmd>Telescope help_tags<cr>",               desc = "Help tags" },
    { "<leader>fr", "<cmd>Telescope oldfiles<cr>",                desc = "Recent files" },
    { "<leader>o",  "<cmd>Telescope lsp_document_symbols<cr>",   desc = "Document symbols" },
    { "<leader>s",  "<cmd>Telescope lsp_workspace_symbols<cr>",  desc = "Workspace symbols" },
  },
  config = function()
    local telescope = require("telescope")
    telescope.setup({
      defaults = {
        layout_strategy = "horizontal",
        layout_config   = { preview_width = 0.55 },
        file_ignore_patterns = { "node_modules", ".git/" },
      },
    })
    pcall(telescope.load_extension, "fzf")
  end,
}
