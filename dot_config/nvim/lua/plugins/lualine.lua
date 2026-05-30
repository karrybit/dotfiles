return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  event = "VimEnter",
  config = function()
    require("lualine").setup({
      options = {
        theme = "gruvbox",
        component_separators = "|",
        section_separators   = { left = "", right = "" },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { "filename" },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
      tabline = {
        lualine_a = { { "buffers", show_filename_only = true, mode = 3 } },
        lualine_z = { "tabs" },
      },
    })
  end,
}
