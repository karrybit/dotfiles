return {
  {
    "mason-org/mason.nvim",
    build = ":MasonUpdate",
    opts = { ui = { border = "rounded" } },
  },

  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local ok, blink = pcall(require, "blink.cmp")
      if ok then
        capabilities = blink.get_lsp_capabilities(capabilities)
      end

      vim.lsp.config("*", { capabilities = capabilities })

      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            workspace = {
              checkThirdParty = false,
              library = vim.api.nvim_get_runtime_file("", true),
            },
          },
        },
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
        callback = function(event)
          local opts = { buffer = event.buf, silent = true }
          local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, vim.tbl_extend("force", opts, { desc = desc }))
          end

          map("n", "gd", vim.lsp.buf.definition, "Go to definition")
          map("n", "gy", vim.lsp.buf.type_definition, "Go to type definition")
          map("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
          map("n", "gr", vim.lsp.buf.references, "Find references")
          map("n", "K", vim.lsp.buf.hover, "Hover docs")
          map("n", "[g", vim.diagnostic.goto_prev, "Prev diagnostic")
          map("n", "]g", vim.diagnostic.goto_next, "Next diagnostic")
          map("n", "<leader>d", vim.diagnostic.open_float, "Show diagnostics")
          map("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
          map({ "n", "x" }, "<leader>a", vim.lsp.buf.code_action, "Code actions")
          map("n", "<leader>f", function()
            vim.lsp.buf.format({ async = true })
          end, "Format buffer")
        end,
      })

      vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        underline = true,
        severity_sort = true,
        float = { border = "rounded" },
      })
    end,
  },

  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    opts = {
      ensure_installed = { "lua_ls", "rust_analyzer", "ts_ls", "graphql" },
      automatic_enable = true,
    },
  },
}
