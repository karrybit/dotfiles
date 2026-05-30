local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Full-width space highlight
local function setup_zenkaku_space()
  vim.api.nvim_set_hl(0, "ZenkakuSpace", { reverse = true, ctermfg = "DarkMagenta", fg = "DarkMagenta" })
end

augroup("ZenkakuSpace", { clear = true })
autocmd("ColorScheme", {
  group = "ZenkakuSpace",
  callback = setup_zenkaku_space,
})
autocmd({ "VimEnter", "WinEnter" }, {
  group = "ZenkakuSpace",
  callback = function()
    setup_zenkaku_space()
    vim.fn.matchadd("ZenkakuSpace", "　")
  end,
})

-- Git commit comment highlight
autocmd("FileType", {
  pattern = "gitcommit",
  callback = function()
    vim.cmd([[syntax match gitcommitComment /^[>"].*/]])
  end,
})

-- :SyntaxInfo command
vim.api.nvim_create_user_command("SyntaxInfo", function()
  local function get_syn_id(transparent)
    local synid = vim.fn.synID(vim.fn.line("."), vim.fn.col("."), 1)
    return transparent and vim.fn.synIDtrans(synid) or synid
  end
  local function get_syn_attr(synid)
    return {
      name    = vim.fn.synIDattr(synid, "name"),
      ctermfg = vim.fn.synIDattr(synid, "fg", "cterm"),
      ctermbg = vim.fn.synIDattr(synid, "bg", "cterm"),
      guifg   = vim.fn.synIDattr(synid, "fg", "gui"),
      guibg   = vim.fn.synIDattr(synid, "bg", "gui"),
    }
  end
  local function fmt(attr)
    return string.format("name: %s ctermfg: %s ctermbg: %s guifg: %s guibg: %s",
      attr.name, attr.ctermfg, attr.ctermbg, attr.guifg, attr.guibg)
  end
  print(fmt(get_syn_attr(get_syn_id(false))))
  print("link to")
  print(fmt(get_syn_attr(get_syn_id(true))))
end, {})
