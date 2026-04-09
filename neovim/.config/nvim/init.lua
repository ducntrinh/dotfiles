-- Vim configs
-- Map leader
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
-- Enable nerd font
vim.g.have_nerd_font = true
-- Show line number
vim.o.number = true
-- Use system clipboard
vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)
-- Show more color
vim.o.termguicolors = true
-- Enable hidden buffer
vim.o.hidden = true
-- Use spaces instead of tabs
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.smartindent = true
-- Disable mouse
vim.o.mouse = ''
-- Enable diagnostic virtual lines
vim.diagnostic.config({
  virtual_text = false,
  virtual_lines = {
    current_line = true,
  },
  severity_sort = true,
})

-- Bootstrap lazy
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- lazy.nvim configs
require('lazy').setup({
  {
    '3rd/image.nvim',
    build = false, -- so that it doesn't build the rock https://github.com/3rd/image.nvim/issues/91#issuecomment-2453430239
    opts = {},
  },
  {
    'catppuccin/nvim',
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd('colorscheme catppuccin')
    end,
  },
  {
    'nvim-mini/mini.nvim',
    event = 'VeryLazy',
    version = false,
    config = function(_, _)
      require('mini.cursorword').setup()
      require('mini.hipatterns').setup({
        highlighters = {
          -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
          fixme = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
          hack = { pattern = '%f[%w]()HACK()%f[%W]', group = 'MiniHipatternsHack' },
          todo = { pattern = '%f[%w]()TODO()%f[%W]', group = 'MiniHipatternsTodo' },
          note = { pattern = '%f[%w]()NOTE()%f[%W]', group = 'MiniHipatternsNote' },

          -- Highlight hex color strings (`#rrggbb`) using that color
          hex_color = require('mini.hipatterns').gen_highlighter.hex_color(),
        },
      })
      require('mini.icons').setup()
      require('mini.indentscope').setup()
      require('mini.pairs').setup()
      require('mini.statusline').setup()
      require('mini.surround').setup()
      require('mini.trailspace').setup()
    end,
  },
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    opts = {},
    keys = {
      {
        '<leader>?',
        function()
          require('which-key').show({ global = false })
        end,
        desc = 'Buffer Local Keymaps (which-key)',
      },
    },
  },
  {
    'm4xshen/hardtime.nvim',
    lazy = false,
    dependencies = { 'MunifTanjim/nui.nvim' },
    opts = {},
  },
  {
    'lewis6991/gitsigns.nvim',
    opts = {},
  },
  {
    'mfussenegger/nvim-lint',
    opts = {},
    config = function()
      require('lint').linters_by_ft = {
        proto = { 'protolint' },
      }

      vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
        callback = function()
          require('lint').try_lint()
          require('lint').try_lint('typos')
        end,
      })
    end,
  },
  {
    'neovim/nvim-lspconfig',
    init = function()
      local lspConfigPath = require('lazy.core.config').options.root .. '/nvim-lspconfig'
      vim.opt.runtimepath:append(lspConfigPath)
    end,
  },
  {
    'NMAC427/guess-indent.nvim',
    opts = {},
  },
  {
    'nvim-neo-tree/neo-tree.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
    },
    cmd = 'Neotree',
    keys = {
      { '<Leader>fe', '<cmd>Neotree toggle<cr>', desc = 'NeoTree' },
    },
    deactivate = function()
      vim.cmd([[Neotree close]])
    end,
    init = function()
      if vim.fn.argc() == 1 then
        local stat = vim.uv.fs_stat(vim.fn.argv(0))
        if stat and stat.type == 'directory' then
          require('neo-tree')
        end
      end
    end,
    opts = {
      filesystem = {
        bind_to_cwd = false,
        follow_current_file = { enable = true },
        use_libuv_file_watcher = true,
      },
      window = {
        mappings = {
          ['<space>'] = 'none',
        },
      },
      default_component_configs = {
        indent = {
          with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
          expander_collapsed = '',
          expander_expanded = '',
          expander_highlight = 'NeoTreeExpander',
        },
        git_status = {
          symbols = {
            unstaged = '󰄱',
            staged = '󰱒',
          },
        },
      },
    },
    config = function(_, opts)
      require('neo-tree').setup(opts)
      vim.api.nvim_create_autocmd('TermClose', {
        pattern = '*lazygit',
        callback = function()
          if package.loaded['neo-tree.sources.git_status'] then
            require('neo-tree.sources.git_status').refresh()
          end
        end,
      })
    end,
  },
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      { 'BurntSushi/ripgrep' },
    },
    keys = {
      {
        '<Leader>ff',
        function()
          require('telescope.builtin').find_files()
        end,
        desc = 'Find Files',
      },
      {
        '<Leader>fg',
        function()
          require('telescope.builtin').live_grep()
        end,
        desc = 'Grep',
      },
      {
        '<Leader>fb',
        function()
          require('telescope.builtin').buffers()
        end,
        desc = 'Buffers',
      },
      {
        '<Leader>fh',
        function()
          require('telescope.builtin').help_tags()
        end,
        desc = 'Help Pages',
      },
    },
    opts = {},
  },
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    build = ':TSUpdate',
    lazy = false,
    config = function()
      local ensure_installed = { 'go', 'rust', 'yaml', 'lua', 'python', 'java' }
      require('nvim-treesitter').install(ensure_installed)

      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('TreeSitterFileType', { clear = true }),
        callback = function(args)
          local language = vim.treesitter.language.get_lang(args.match) or args.match
          if not vim.treesitter.language.add(language) then
            return
          end

          -- highlighting
          vim.treesitter.start(args.buf, language)

          -- folds
          vim.wo.foldenable = false
          vim.wo.foldmethod = 'expr'
          vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'

          -- indents
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },
  {
    'saghen/blink.cmp',
    version = '1.*',
    event = 'InsertEnter',
    opts = {
      keymap = {
        preset = 'super-tab',
      },
      appearance = {
        nerd_font_variant = 'mono',
      },
      completion = {
        documentation = {
          auto_show = false,
        },
      },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
      },
      fuzzy = {
        implementation = 'prefer_rust_with_warning',
      },
    },
    opts_extend = { 'sources.default' },
  },
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    opts = {
      formatters_by_ft = {
        lua = { 'stylua' },
        python = { 'ruff_format', 'ruff_organize_imports' },
        javascript = { 'biome', 'biome-organize-imports' },
        typescript = { 'biome', 'biome-organize-imports' },
        typescriptreact = { 'biome', 'biome-organize-imports' },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
    },
  },
}, {})

-- LSP configs
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspAttach', {}),
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    if
      not client:supports_method('textDocument/willSaveWaitUntil')
      and client:supports_method('textDocument/formatting')
    then
      vim.api.nvim_clear_autocmds({ group = 'UserLspAttach', buffer = args.buf })
      vim.api.nvim_create_autocmd('BufWritePre', {
        group = vim.api.nvim_create_augroup('UserLspAttach', { clear = false }),
        buffer = args.buf,
        callback = function()
          vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
        end,
      })
    end
  end,
})

vim.lsp.config['yamlls'] = {
  settings = {
    -- https://github.com/redhat-developer/vscode-redhat-telemetry#how-to-disable-telemetry-reporting
    redhat = { telemetry = { enabled = false } },
  },
}

vim.lsp.config['lua_ls'] = {
  settings = {
    Lua = {
      hint = {
        enable = true,
      },
      completion = {
        callSnippet = 'Replace',
      },
      telemetry = {
        enable = false,
      },
      format = {
        enable = false,
      },
    },
  },
  on_init = function(client)
    local path = client.workspace_folders[1].name
    if vim.uv.fs_stat(path .. '/.luarc.json') or vim.loop.fs_stat(path .. '/.luarc.jsonc') then
      return
    end

    client.config.settings.Lua = vim.tbl_deep_extend('force', client.settings, {
      runtime = {
        -- Tell the language server which version of Lua you're using
        -- (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
      },
      -- Make the server aware of Neovim runtime files
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
          -- Depending on the usage, you might want to add additional paths here.
          '${3rd}/luv/library',
          -- "${3rd}/busted/library",
        },
        -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
        -- library = vim.api.nvim_get_runtime_file("", true)
      },
    })
  end,
}

vim.lsp.config['ts_ls'] = {
  on_attach = function(client, _)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end,
}

vim.lsp.enable({
  'clangd',
  'dockerls',
  'gopls',
  'lua_ls',
  'pyright',
  'rust_analyzer',
  'ts_ls',
  'yamlls',
})

vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { noremap = true, silent = true })
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { noremap = true, silent = true })
