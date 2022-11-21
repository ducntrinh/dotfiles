-- Packer configs
require('packer').startup(function(use)
  use('L3MON4D3/LuaSnip')
  use('akinsho/nvim-toggleterm.lua')
  use('aklt/plantuml-syntax')
  use('editorconfig/editorconfig-vim')
  use('ellisonleao/gruvbox.nvim')
  use('folke/neodev.nvim')
  use('hoob3rt/lualine.nvim')
  use('hrsh7th/cmp-nvim-lsp')
  use('hrsh7th/nvim-cmp')
  use('kyazdani42/nvim-tree.lua')
  use('kyazdani42/nvim-web-devicons')
  use('lewis6991/gitsigns.nvim')
  use('neovim/nvim-lspconfig')
  use('numToStr/Comment.nvim')
  use('nvim-lua/plenary.nvim')
  use('nvim-lua/popup.nvim')
  use('nvim-telescope/telescope.nvim')
  use({
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
  })
  use('jose-elias-alvarez/null-ls.nvim')
  use('ray-x/go.nvim')
  use('saadparwaiz1/cmp_luasnip')
  use('tpope/vim-surround')
  use('vimwiki/vimwiki')
  use('wbthomason/packer.nvim')
end)

-- Vim configs
-- Show line number
vim.o.number = true
-- Use system clipboard
vim.o.clipboard = 'unnamedplus'
-- Show more color
vim.o.termguicolors = true
-- Enable hidden buffer
vim.o.hidden = true
-- Use spaces instead of tabs
vim.o.tabstop = 4
vim.o.shiftwidth = 4
-- Set leader to Space
vim.g.mapleader = ' '
-- Set SQL dialect to MySQL
vim.g.sql_type_default = 'mysql'
-- Setup VimWiki
vim.g.vimwiki_list = { { path = '~/vimwiki/', syntax = 'markdown', ext = '.md' } }
vim.g.vimwiki_global_ext = 0
-- Theme configs
vim.o.background = 'light'
vim.cmd([[colorscheme gruvbox]])

-- neodev configs
require('neodev').setup({})

-- LSP configs
local capabilities = require('cmp_nvim_lsp').default_capabilities()

local augroup = vim.api.nvim_create_augroup('LspFormatting', {})
local on_attach = function(client, bufnr)
  if client.supports_method('textDocument/formatting') then
    vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
    vim.api.nvim_create_autocmd('BufWritePre', {
      group = augroup,
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format({ bufnr = bufnr })
      end,
    })
  end
end

require('lspconfig').gopls.setup({
  capabilities = capabilities,
  on_attach = on_attach,
})
require('lspconfig').yamlls.setup({
  capabilities = capabilities,
  on_attach = on_attach,
})
require('lspconfig').dockerls.setup({
  capabilities = capabilities,
  on_attach = on_attach,
})
require('lspconfig').clangd.setup({
  capabilities = capabilities,
  on_attach = on_attach,
})
require('lspconfig').rust_analyzer.setup({
  capabilities = capabilities,
  on_attach = on_attach,
})
require('lspconfig').pyright.setup({
  capabilities = capabilities,
  on_attach = on_attach,
})

require('lspconfig').sumneko_lua.setup({
  settings = {
    Lua = {
      workspace = {
        checkThirdParty = false,
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
  capabilities = capabilities,
})

vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { noremap = true, silent = true })
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { noremap = true, silent = true })
vim.keymap.set('n', 'gr', vim.lsp.buf.references, { noremap = true, silent = true })
vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { noremap = true, silent = true })
vim.keymap.set('n', 'K', vim.lsp.buf.hover, { noremap = true, silent = true })
vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, { noremap = true, silent = true })
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { noremap = true, silent = true })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>rn', vim.lsp.buf.rename, { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>ca', vim.lsp.buf.code_action, { noremap = true, silent = true })

-- Treesitter configs
require('nvim-treesitter.configs').setup({
  ensure_installed = { 'go', 'rust', 'yaml', 'lua', 'python' },
  highlight = {
    enable = true,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = 'gnn',
      node_incremental = 'grn',
      scope_incremental = 'grc',
      node_decremental = 'grm',
    },
  },
  indent = {
    enable = true,
  },
})

-- nvim-cmp configs
local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0
    and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end

local cmp = require('cmp')
local luasnip = require('luasnip')

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body) -- For `luasnip` users.
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' }, -- For luasnip users.
  }, {
    { name = 'buffer' },
  }),
})

-- Lualine configs
require('lualine').setup({
  options = {
    theme = 'material',
  },
})

-- gitsigns configs
require('gitsigns').setup()

-- Telescope configs
vim.keymap.set('n', '<Leader>ff', require('telescope.builtin').find_files, { noremap = true })
vim.keymap.set('n', '<Leader>fg', require('telescope.builtin').live_grep, { noremap = true })
vim.keymap.set('n', '<Leader>fb', require('telescope.builtin').buffers, { noremap = true })
vim.keymap.set('n', '<Leader>fh', require('telescope.builtin').help_tags, { noremap = true })

-- nvim-tree configs
require('nvim-tree').setup()
vim.keymap.set('n', '<C-n>', ':NvimTreeToggle<CR>', { noremap = true })
vim.keymap.set('n', '<Leader>tr', ':NvimTreeRefresh<CR>', { noremap = true })
vim.keymap.set('n', '<Leader>tf', ':NvimTreeFindFile<CR>', { noremap = true })

-- nvim-toggleterm configs
require('toggleterm').setup({
  direction = 'float',
  open_mapping = [[<c-\>]],
})

-- go.nvim configs
require('go').setup()

-- null-ls configs
local null_ls = require('null-ls')
null_ls.setup({
  sources = {
    null_ls.builtins.formatting.stylua,
  },
  on_attach = on_attach,
})

-- Comment.nvim configs
require('Comment').setup()
