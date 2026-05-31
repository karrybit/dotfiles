return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  config = function()
    local wk = require("which-key")
    wk.setup({ preset = "modern" })
    wk.add({
      { "<leader>e",  group = "explorer" },
      { "<leader>f",  group = "find / format" },
      { "<leader>h",  group = "git hunk" },
      { "<leader>r",  group = "rename" },
      { "<leader>t",  group = "terminal" },
    })
  end,
}
