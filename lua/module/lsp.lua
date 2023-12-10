local base = require('base')
local bindings = require('module.bindings')
local M = {}

local function _lsp_clangd(on_attach, capabilities)
  local function _clangd_on_attach(client, buffer)
    local caps = client.server_capabilities
    if caps.semanticTokensProvider and caps.semanticTokensProvider.full then
      local augroup = vim.api.nvim_create_augroup('SemanticTokens', {})
      vim.api.nvim_create_autocmd('TextChanged', {
        group = augroup,
        buffer = buffer,
        callback = function()
          vim.lsp.buf.semantic_tokens_full()
        end,
      })
      -- fire it first time on load as well
      vim.lsp.buf.semantic_tokens_full()
    end
    on_attach(client, buffer)
  end

  local function _ext_clangd_on_attach(client, buffer)
    require('clangd_extensions.inlay_hints').setup_autocmd()
    require('clangd_extensions.inlay_hints').set_inlay_hints()
    on_attach(client, buffer)
  end

  -- Set .bashrc/.zshrc/.profile/.zprofile path
  --   export PATH="$PATH:/home/yanchcore/Code/llvm/llvm/bin"
  --
  -- clangd load configuration order
  --   .clangd
  --   ~/.config/clangd/config.yaml
  --   compile_commands.json

  local bin = 'clangd'
  if base.is_kernel() then
    bin = '/home/yanchcore/Code/llvm/llvm/bin/clangd'
  end
  local opts = {
    -- https://github.com/llvm/llvm-project/commit/ca13f5595ae8dc7326f29c8658de70bbc1854db0
    -- https://github.com/nvim-telescope/telescope.nvim/pull/1336/files
    -- https://github.com/clangd/clangd/issues/707
    -- '--limit-results=1000'
    -- '--limit-results=1000000'
    cmd = {
      bin,
      '--background-index',
      -- '--header-insertion=never',
      '--header-insertion=iwyu',
      '--header-insertion-decorators',
      '--limit-references=0',
      '--completion-style=detailed',
      '--function-arg-placeholders',
      '--fallback-style=llvm',
      '--cross-file-rename',
      '--all-scopes-completion',
      '--pch-storage=memory',
      '--clang-tidy',
      -- '--clang-tidy=0', -- disable clang-tidy
      '--clang-tidy-checks=-*,llvm-*,clang-analyzer-*',
      '--clang-tidy-checks=*',
    },
    flags = { allow_incremental_sync = true, debounce_text_changes = 500 },
    -- cmd = { 'clangd', '--header-insertion=never' },
    filetypes = { 'c', 'cpp' },
    -- root_dir = function(fname) return require('lspconfig.util').find_git_ancestor(fname) end,
    on_attach = _ext_clangd_on_attach,
    capabilities = vim.tbl_deep_extend('error', capabilities, {
      offsetEncoding = { 'utf-16' },
      -- offsetEncoding = { 'utf-8', 'utf-16' },
      textDocument = {
        completion = {
          editsNearCursor = true,
        },
      },
    }),
    root_dir = function(...)
      -- using a root .clang-format or .clang-tidy file messes up projects, so remove them
      return require('lspconfig.util').root_pattern('.clangd', 'compile_commands.json', 'compile_flags.txt', 'configure.ac', '.git')(...)
    end,
    init_options = {
      clangdFileStatus = true,
      usePlaceholders = true,
      completeUnimported = true,
    },
  }
  local extensions = {
    -- defaults:
    -- Automatically set inlay hints (type hints)
    autoSetHints = true,
    -- These apply to the default ClangdSetInlayHints command
    inlay_hints = {
      -- https://github.com/neovim/neovim/pull/20130
      -- https://github.com/p00f/clangd_extensions.nvim/pull/34
      -- https://github.com/p00f/clangd_extensions.nvim/commit/6d0bf36870d15c0c2284f4b6693a66552a6bf127
      -- https://github.com/neovim/neovim/issues/18086#issuecomment-1095937211
      inline = vim.fn.has('nvim-0.10') == 1,
      -- Options other than `highlight' and `priority' only work
      -- if `inline' is disabled
      -- Only show inlay hints for the current line
      only_current_line = false,
      -- Event which triggers a refersh of the inlay hints.
      -- You can make this "CursorMoved" or "CursorMoved,CursorMovedI" but
      -- not that this may cause higher CPU usage.
      -- This option is only respected when only_current_line and
      -- autoSetHints both are true.
      only_current_line_autocmd = { 'CursorHold' },
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
      -- role_icons = {
      --   type = '🄣',
      --   declaration = '🄓',
      --   expression = '🄔',
      --   statement = ';',
      --   specifier = '🄢',
      --   ['template argument'] = '🆃',
      -- },
      -- kind_icons = {
      --   Compound = '🄲',
      --   Recovery = '🅁',
      --   TranslationUnit = '🅄',
      --   PackExpansion = '🄿',
      --   TemplateTypeParm = '🅃',
      --   TemplateTemplateParm = '🅃',
      --   TemplateParamObject = '🅃',
      -- },
      -- These require codicons (https://github.com/microsoft/vscode-codicons)
      role_icons = {
        type = '',
        declaration = '',
        expression = '',
        specifier = '',
        statement = '',
        ['template argument'] = '',
      },
      kind_icons = {
        Compound = '',
        Recovery = '',
        TranslationUnit = '',
        PackExpansion = '',
        TemplateTypeParm = '',
        TemplateTemplateParm = '',
        TemplateParamObject = '',
      },
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
  }
  require('lspconfig').clangd.setup(opts)
  require('clangd_extensions').setup(extensions)
end

local function _lsp_cpp(on_attach, capabilities)
  _lsp_clangd(on_attach, capabilities)
end

local function _lsp_handlers()
  -- severity.WARN
  -- severity.ERROR
  local diagnostics = {
    virtual_text = false,
    -- virtual_text = {
    --   -- severity_limit = 'Error',
    --   severity = { min = vim.diagnostic.severity.ERROR, max = vim.diagnostic.severity.ERROR },
    --   spacing = 4,
    --   prefix = '●',
    -- },
    -- virtual_lines = false,
    virtual_lines = {
      severity = { min = vim.diagnostic.severity.ERROR, max = vim.diagnostic.severity.ERROR },
      only_current_line = true,
    },
    -- virtual_improved = false,
    virtual_improved = {
      severity = { min = vim.diagnostic.severity.ERROR, max = vim.diagnostic.severity.ERROR },
      -- severity_limit = 'Error',
      -- spacing = 4,
      -- prefix = '●',
      -- code = false,
      current_line = 'hide', -- only hide default
    },
    signs = false,
    float = {
      source = 'always',
    },
    update_in_insert = false,
    underline = {
      severity_limit = 'Error',
    },
    severity_sort = true,
    right_align = true,
  }
  -- Use Noice hover, fix rainbow pairs in hover window
  -- vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'rounded' })
  vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, diagnostics)
  vim.diagnostic.config(diagnostics)
end

local function _lsp_client_preferences()
  local function on_attach(client, buffer)
    bindings.lsp(client, buffer)
  end
  -- nvim\share\nvim\runtime\lua\vim\lsp\protocol.lua
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  -- Update existing capabilities
  capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
  return on_attach, capabilities
end

local function _lsp_clients()
  local on_attach, capabilities = _lsp_client_preferences()
  _lsp_cpp(on_attach, capabilities)
  on_attach = _with_inlay(on_attach)
  on_attach = _with_virtype(on_attach)
end

local function _lsp_semantic_syntax()
  --[[
    https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#textDocument_semanticTokens
    export enum SemanticTokenTypes {
      namespace = 'namespace',
      /**
      * Represents a generic type. Acts as a fallback for types which
      * can't be mapped to a specific type like class or enum.
      */
      type = 'type',
      class = 'class',
      enum = 'enum',
      interface = 'interface',
      struct = 'struct',
      typeParameter = 'typeParameter',
      parameter = 'parameter',
      variable = 'variable',
      property = 'property',
      enumMember = 'enumMember',
      event = 'event',
      function = 'function',
      method = 'method',
      macro = 'macro',
      keyword = 'keyword',
      modifier = 'modifier',
      comment = 'comment',
      string = 'string',
      number = 'number',
      regexp = 'regexp',
      operator = 'operator',
      /**
      * @since 3.17.0
      */
      decorator = 'decorator'
    }
    ------------------------------------------------------------------------------
    export enum SemanticTokenModifiers {
      declaration = 'declaration',
      definition = 'definition',
      readonly = 'readonly',
      static = 'static',
      deprecated = 'deprecated',
      abstract = 'abstract',
      async = 'async',
      modification = 'modification',
      documentation = 'documentation',
      defaultLibrary = 'defaultLibrary'
    }
  ]]
  --[[
    nvim\share\nvim\runtime\doc\lsp.txt
    ------------------------------------------------------------------------------
    LSP SEMANTIC HIGHLIGHTS                               *lsp-semantic-highlight*
    hi @lsp.type.namespace guifg=Yellow       " function names are yellow
    hi @lsp.type.function guifg=Yellow        " function names are yellow
    hi @lsp.type.variable.lua guifg=Green     " variables in lua are green
    hi @lsp.mod.deprecated gui=strikethrough  " deprecated is crossed out
    hi @lsp.typemod.function.async guifg=Blue " async functions are blue
    ------------------------------------------------------------------------------
    @lsp.type.class         Structure
    @lsp.type.decorator     Function
    @lsp.type.enum          Structure
    @lsp.type.enumMember    Constant
    @lsp.type.function      Function
    @lsp.type.interface     Structure
    @lsp.type.macro         Macro
    @lsp.type.method        Function
    @lsp.type.namespace     Structure
    @lsp.type.parameter     Identifier
    @lsp.type.property      Identifier
    @lsp.type.struct        Structure
    @lsp.type.type          Type
    @lsp.type.typeParameter TypeDef
    @lsp.type.variable      Identifier
  ]]
  --[[
    lazy\vim-lsp-cxx-highlight\syntax\lsp_cxx_highlight.vim
    if g:lsp_cxx_hl_light_bg
        hi default LspCxxHlGroupEnumConstant ctermfg=Magenta guifg=#573F54 cterm=none gui=none
        hi default LspCxxHlGroupNamespace ctermfg=Yellow guifg=#3D3D00 cterm=none gui=none
        hi default LspCxxHlGroupMemberVariable ctermfg=Black guifg=Black
    else
        hi default LspCxxHlGroupEnumConstant ctermfg=Magenta guifg=#AD7FA8 cterm=none gui=none
        hi default LspCxxHlGroupNamespace ctermfg=Yellow guifg=#BBBB00 cterm=none gui=none
        hi default LspCxxHlGroupMemberVariable ctermfg=White guifg=White
    endif
  ]]
  --[[
    Visual Assist X Dark
    #FFD700   Classes,structs, enums, interfaces, typedefs
    #BDB76B   variables
    #BD63C5   Preprocessor macros
    #B9771E   Enum members
    #FF8000   Functions / methods
    #B8D7A3   Namespaces
    -------------------------------------------------------
    Visual Assist X Blue
    #216F85   Classes, structs, enums, interfaces, typedefs
    #000080   Variables
    #6F008A   Preprocessor macros
    #2F4F4F   Enum members
    #880000   Functions / methods
    #216F85   Namespaces
  ]]
  local function dark()
    local cs = vim.api.nvim_cmd({ cmd = 'colorscheme' }, { output = true })
    local schemes = {
      { 'tokyonight', not require('tokyonight.config').is_day() },
    }
    for i, v in ipairs(schemes) do
      if v[1] == cs then
        return v[2]
      end
    end
    return true
  end
  if dark() then
    vim.cmd([[
      hi @lsp.type.namespace ctermfg=Yellow guifg=#BBBB00 cterm=none gui=none
      hi @lsp.type.type ctermfg=Yellow guifg=#FFD700 cterm=none gui=none
      " hi @lsp.type.enumMember ctermfg=Magenta guifg=#AD7FA8 cterm=none gui=none
      " hi @lsp.mod.defaultLibrary ctermfg=Yellow guifg=#FF8000 cterm=none gui=none
      " hi @lsp.typemod.class.defaultLibrary ctermfg=Yellow guifg=#FF8000 cterm=none gui=none
      " hi @lsp.typemod.type.defaultLibrary ctermfg=Yellow guifg=#FF8000 cterm=none gui=none
    ]])
  else
    vim.cmd([[
      hi @lsp.type.namespace ctermfg=Yellow guifg=#3D3D00 cterm=none gui=none
      hi @lsp.type.enumMember ctermfg=Magenta guifg=#573F54 cterm=none gui=none
    ]])
  end
end
M.lsp_semantic_syntax = _lsp_semantic_syntax

function M.lsp()
  vim.lsp.set_log_level('OFF')
  _lsp_handlers()
  _lsp_clients()
  _lsp_semantic_syntax()
end

return M
