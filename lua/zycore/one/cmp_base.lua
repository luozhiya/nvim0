local M = {}

M.Native = {
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

M.VS = {
  format = require('lspkind').cmp_format({
    mode = 'symbol', -- show only symbol annotations
    maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)

    -- The function below will be called before any actual modifications from lspkind
    -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
    before = function(entry, vim_item)
      return vim_item
    end,
  }),
}

M.wbthomason = {
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

return M
