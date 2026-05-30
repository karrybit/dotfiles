return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("gitsigns").setup({
      signs = {
        add          = { text = "+" },
        change       = { text = "~" },
        delete       = { text = "_" },
        topdelete    = { text = "‾" },
        changedelete = { text = "~" },
      },
      on_attach = function(bufnr)
        local gs   = package.loaded.gitsigns
        local opts = { buffer = bufnr, silent = true }
        local map  = function(lhs, rhs, desc)
          vim.keymap.set("n", lhs, rhs, vim.tbl_extend("force", opts, { desc = desc }))
        end

        map("]h", gs.next_hunk,    "Next git hunk")
        map("[h", gs.prev_hunk,    "Prev git hunk")
        map("<leader>hs", gs.stage_hunk,   "Stage hunk")
        map("<leader>hr", gs.reset_hunk,   "Reset hunk")
        map("<leader>hp", gs.preview_hunk, "Preview hunk")
        map("<leader>hb", gs.blame_line,   "Blame line")
      end,
    })
  end,
}
