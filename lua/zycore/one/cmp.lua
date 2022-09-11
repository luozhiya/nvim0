local cmp_ok, cmp = pcall(require, "cmp")
if not cmp_ok then
  return
end

local lua_ok, luasnip = pcall(require, "luasnip")
if not lua_ok then
  return 
end

local lspkind_ok, lspkind = pcall(require, "lspkind")
if not lspkind_ok then
  return 
end

require("luasnip/loaders/from_vscode").lazy_load()

local check_backspace = function()
  local col = vim.fn.col "." -1
  return col == 0 or vim.fn.getline("."):sub(col, col):match "%s"
end

local kind_icons = {
  Text = "",
  Method = "m",
  Function = "",
  Constructor = "",
  Field = "",
  Variable = "",
  Class = "",
  Interface = "",
  Module = "",
  Property = "",
  Unit = "",
  Value = "",
  Enum = "",
  Keyword = "",
  Snippet = "",
  Color = "",
  File = "",
  Reference = "",
  Folder = "",
  EnumMember = "",
  Constant = "",
  Struct = "",
  Event = "",
  Operator = "",
  TypeParameter = "",
}

local ELLIPSIS_CHAR = '…'
local MAX_LABEL_WIDTH = 25
local MAX_KIND_WIDTH = 14

local get_ws = function (max, len)
  return (" "):rep(max - len)
end

local M = {
  fields = { "kind", "abbr", "menu" },
  format = function(entry, vim_item)
    -- Kind icons
    vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
    vim_item.menu = ({
      nvim_lsp = "[LSP]",
      luasnip = "[Snippet]",
      buffer = "[Buffer]",
      path = "[Path]",
    })[entry.source.name]
    local content = vim_item.abbr
    if #content > MAX_LABEL_WIDTH then
      vim_item.abbr = vim.fn.strcharpart(content, 0, MAX_LABEL_WIDTH) .. ELLIPSIS_CHAR
    else
      vim_item.abbr = content .. get_ws(MAX_LABEL_WIDTH, #content)
    end
    return vim_item
  end,
}

local VS = {
  format = lspkind.cmp_format({
    mode = 'symbol', -- show only symbol annotations
    maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)

    -- The function below will be called before any actual modifications from lspkind
    -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
    before = function (entry, vim_item)
      return vim_item
    end
  })
}

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = {
    ["<C-k>"] = cmp.mapping.select_prev_item(),
    ["<C-j>"] = cmp.mapping.select_next_item(),
    ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
    ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
    ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
    ["<C-y>"] = cmp.config.disable,
    ["<C-e>"] = cmp.mapping {
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    },
    -- Accept currently selected item. If none selected, `select` first item.
    -- Set `select` to `false` to only confirm explicitly selected items.
    ["<CR>"] = cmp.mapping.confirm { select = true },
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expandable() then
        luasnip.expand()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif check_backspace() then
        fallback()
      else
        fallback()
      end
    end, {
      "i",
      "s",
    }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, {
      "i",
      "s",
    }),    
  },
  formatting = VS,
  sources = {
    { name = 'nvim_lsp' },
    { name = "luasnip" },
    { name = "buffer" },
    { name = "path" },
  },  
  -- source = {
  --   {name = "nvim_lsp"},
  --   {name = "luasnip"},
  --   {name = "buffer"},
  --   {name = "path"},
  -- },
  confirm_opts = {
    behavior = cmp.ConfirmBehavior.Replace,
    select = false,
  },
  window = {
    -- completion = cmp.config.window.bordered(),
    -- documentation = cmp.config.window.bordered(),    
    -- documentation = {
    --   border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
    -- },
  },
  experimental = {
    ghost_text = false,
    native_menu = false,
  },
}
