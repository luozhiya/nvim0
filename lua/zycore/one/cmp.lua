vim.cmd([[packadd nvim-cmp]])

local cmp = require('cmp')
local luasnip = require('luasnip')
local lspkind = require('lspkind')

local style_constexpr = require('zycore.base.style_constexpr')

luasnip.setup({ region_check_events = 'InsertEnter', delete_check_events = 'InsertEnter' })
require('luasnip/loaders/from_vscode').lazy_load()

vim.cmd([[packadd cmp-under-comparator]])
vim.cmd([[packadd conjure]])

local check_backspace = function()
  local col = vim.fn.col('.') - 1
  return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s')
end

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end

local kind_icons = style_constexpr.lsp.kinds

local ELLIPSIS_CHAR = '…'
local MAX_LABEL_WIDTH = 25
local MAX_KIND_WIDTH = 14

local get_ws = function(max, len)
  return (' '):rep(max - len)
end

local Native = {
  fields = { 'kind', 'abbr', 'menu' },
  format = function(entry, vim_item)
    -- Kind icons
    vim_item.kind = string.format('%s', kind_icons[vim_item.kind])
    vim_item.menu = ({
      nvim_lsp = '[LSP]',
      conjure = '[Conjure]',
      luasnip = '[Snippet]',
      buffer = '[Buffer]',
      path = '[Path]',
      calc = '[Calc]',
      vsnip = '[Vsnip]',
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
    before = function(entry, vim_item)
      return vim_item
    end,
  }),
}

local wbthomason = {
  fields = { 'kind', 'abbr', 'menu' },
  format = function(entry, vim_item)
    local kind = require('lspkind').cmp_format({ mode = 'symbol_text', maxwidth = 50 })(entry, vim_item)
    local strings = vim.split(kind.kind, '%s', { trimempty = true })
    -- print(vim.inspect(strings))
    kind.kind = ' ' .. strings[1] .. ' '
    if vim.tbl_count(strings) == 2 then
      kind.menu = '    (' .. strings[2] .. ')'
    end
    return kind
  end,
}

local opts = {
  completion = { completeopt = 'menu,menuone,noinsert' },
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<C-k>'] = cmp.mapping.select_prev_item(),
    ['<C-j>'] = cmp.mapping.select_next_item(),
    ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-1), { 'i', 'c' }),
    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(1), { 'i', 'c' }),
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    ['<C-y>'] = cmp.config.disable,
    ['<C-e>'] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    -- Accept currently selected item. If none selected, `select` first item.
    -- Set `select` to `false` to only confirm explicitly selected items.
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<Tab>'] = cmp.mapping(function(fallback)
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
      'i',
      's',
    }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, {
      'i',
      's',
    }),
  },
  formatting = wbthomason,
  sources = {
    { name = 'nvim_lsp_signature_help' },
    { name = 'nvim_lsp' },
    { name = 'conjure' },
    { name = 'luasnip' },
    { name = 'buffer' },
    { name = 'path' },
    { name = 'nvim_lua' },
    { name = 'calc' },
    { name = 'vsnip' },
  },
  sorting = {
    comparators = {
      -- function(entry1, entry2)
      --   local score1 = entry1.completion_item.score
      --   local score2 = entry2.completion_item.score
      --   if score1 and score2 then
      --     return (score1 - score2) < 0
      --   end
      -- end,

      -- The built-in comparators:
      cmp.config.compare.offset,
      cmp.config.compare.exact,
      cmp.config.compare.recently_used,
      cmp.config.compare.score,
      require('clangd_extensions.cmp_scores'),
      require('cmp-under-comparator').under,
      cmp.config.compare.kind,
      cmp.config.compare.sort_text,
      cmp.config.compare.length,
      cmp.config.compare.order,
    },
  },
  confirm_opts = {
    behavior = cmp.ConfirmBehavior.Replace,
    select = false,
  },
  window = {
    -- completion = cmp.config.window.bordered(),
    -- documentation = cmp.config.window.bordered(),
    documentation = {
      border = style_constexpr.border.round,
    },
    completion = {
      winhighlight = 'Normal:Pmenu,FloatBorder:Pmenu,Search:None',
      col_offset = -3,
      side_padding = 0,
    },
  },
  experimental = {
    ghost_text = true,
    native_menu = false,
  },
}

cmp.setup(opts)

cmp.setup.cmdline('/', {
  sources = { { name = 'buffer' } },
  mapping = cmp.mapping.preset.cmdline({}),
})

cmp.setup.cmdline(':', {
  sources = cmp.config.sources({ { name = 'path' } }, { { name = 'cmdline' } }),
  mapping = cmp.mapping.preset.cmdline({}),
})
