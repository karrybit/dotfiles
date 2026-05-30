return {
  -- LSP server manager
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    config = function()
      require("mason").setup({ ui = { border = "rounded" } })
    end,
  },

  -- Bridge between mason and nvim-lspconfig
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed    = { "ts_ls", "graphql", "rust_analyzer", "lua_ls" },
        automatic_installation = true,
      })
    end,
  },

  -- nvim-lspconfig
  {
    "neovim/nvim-lspconfig",
    dependencies = { "williamboman/mason-lspconfig.nvim", "hrsh7th/cmp-nvim-lsp" },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lspconfig   = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      local on_attach = function(_, bufnr)
        local opts = { buffer = bufnr, silent = true }
        local map  = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, vim.tbl_extend("force", opts, { desc = desc }))
        end

        -- Navigation
        map("n", "gd",          vim.lsp.buf.definition,      "Go to definition")
        map("n", "gy",          vim.lsp.buf.type_definition, "Go to type definition")
        map("n", "gi",          vim.lsp.buf.implementation,  "Go to implementation")
        map("n", "gr",          vim.lsp.buf.references,      "Find references")
        map("n", "K",           vim.lsp.buf.hover,           "Hover docs")

        -- Diagnostics
        map("n", "[g", vim.diagnostic.goto_prev,  "Prev diagnostic")
        map("n", "]g", vim.diagnostic.goto_next,  "Next diagnostic")
        map("n", "<leader>d", vim.diagnostic.open_float, "Show diagnostics")

        -- Actions
        map("n",        "<leader>rn", vim.lsp.buf.rename,       "Rename symbol")
        map({ "n", "x" }, "<leader>a", vim.lsp.buf.code_action, "Code actions")
        map("n", "<leader>f", function()
          vim.lsp.buf.format({ async = true })
        end, "Format buffer")
      end

      require("mason-lspconfig").setup_handlers({
        function(server_name)
          lspconfig[server_name].setup({ capabilities = capabilities, on_attach = on_attach })
        end,
        ["lua_ls"] = function()
          lspconfig.lua_ls.setup({
            capabilities = capabilities,
            on_attach    = on_attach,
            settings     = {
              Lua = {
                diagnostics = { globals = { "vim" } },
                workspace   = { library = vim.api.nvim_get_runtime_file("", true), checkThirdParty = false },
              },
            },
          })
        end,
      })

      vim.diagnostic.config({
        virtual_text   = true,
        signs          = true,
        underline      = true,
        severity_sort  = true,
        float          = { border = "rounded" },
      })
    end,
  },

  -- Completion engine
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp     = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args) luasnip.lsp_expand(args.body) end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"]      = cmp.mapping.confirm({ select = true }),
          ["<C-f>"]     = cmp.mapping.scroll_docs(4),
          ["<C-b>"]     = cmp.mapping.scroll_docs(-4),
          ["<C-e>"]     = cmp.mapping.abort(),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
        }, {
          { name = "buffer" },
          { name = "path" },
        }),
        window = {
          completion    = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
      })
    end,
  },
}
