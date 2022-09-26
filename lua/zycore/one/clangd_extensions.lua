local ok, clangd_extensions = pcall(require, 'clangd_extensions')
if not ok then
  return
end

local server_clangd = {}
local cxx_lsp = require('zycore.goforit').cxx_lsp
if vim.tbl_contains(cxx_lsp, 'clangd') and vim.tbl_count(cxx_lsp) == 1 then
  server_clangd = {
    -- options to pass to nvim-lspconfig
    -- i.e. the arguments to require("lspconfig").clangd.setup({})
    on_attach = require('zycore.lsp.handler').on_attach,
    capabilities = require('zycore.lsp.handler').capabilities,
  }
end

local opts = {
  server = server_clangd,
  extensions = {
    -- defaults:
    -- Automatically set inlay hints (type hints)
    autoSetHints = true,
    -- These apply to the default ClangdSetInlayHints command
    inlay_hints = {
      -- Only show inlay hints for the current line
      only_current_line = false,
      -- Event which triggers a refersh of the inlay hints.
      -- You can make this "CursorMoved" or "CursorMoved,CursorMovedI" but
      -- not that this may cause  higher CPU usage.
      -- This option is only respected when only_current_line and
      -- autoSetHints both are true.
      only_current_line_autocmd = 'CursorHold',
      -- whether to show parameter hints with the inlay hints or not
      show_parameter_hints = true,
      -- prefix for parameter hints
      parameter_hints_prefix = '<- ',
      -- prefix for all the other hints (type, chaining)
      other_hints_prefix = '=> ',
      -- whether to align to the length of the longest line in the file
      max_len_align = false,
      -- padding from the left if max_len_align is true
      max_len_align_padding = 1,
      -- whether to align to the extreme right or not
      right_align = false,
      -- padding from the right if right_align is true
      right_align_padding = 7,
      -- The color of the hints
      highlight = 'Comment',
      -- The highlight group priority for extmark
      priority = 100,
    },
    ast = {
      -- These are unicode, should be available in any font
      role_icons = {
        type = '🄣',
        declaration = '🄓',
        expression = '🄔',
        statement = ';',
        specifier = '🄢',
        ['template argument'] = '🆃',
      },
      kind_icons = {
        Compound = '🄲',
        Recovery = '🅁',
        TranslationUnit = '🅄',
        PackExpansion = '🄿',
        TemplateTypeParm = '🅃',
        TemplateTemplateParm = '🅃',
        TemplateParamObject = '🅃',
      },
      --[[ These require codicons (https://github.com/microsoft/vscode-codicons)
            role_icons = {
                type = "",
                declaration = "",
                expression = "",
                specifier = "",
                statement = "",
                ["template argument"] = "",
            },

            kind_icons = {
                Compound = "",
                Recovery = "",
                TranslationUnit = "",
                PackExpansion = "",
                TemplateTypeParm = "",
                TemplateTemplateParm = "",
                TemplateParamObject = "",
            }, ]]

      highlights = {
        detail = 'Comment',
      },
    },
    memory_usage = {
      border = 'none',
    },
    symbol_info = {
      border = 'none',
    },
  },
}

if vim.tbl_contains(cxx_lsp, 'clangd') then
  clangd_extensions.setup(opts)
end