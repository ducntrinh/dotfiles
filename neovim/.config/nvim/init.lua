-- Packer configs
require('packer').startup(function()
  use 'Mofiqul/dracula.nvim'
  use 'akinsho/nvim-toggleterm.lua'
  use 'aklt/plantuml-syntax'
  use 'hoob3rt/lualine.nvim'
  use 'hrsh7th/nvim-compe'
  use 'kyazdani42/nvim-tree.lua'
  use 'kyazdani42/nvim-web-devicons'
  use 'lewis6991/gitsigns.nvim'
  use 'marko-cerovac/material.nvim'
  use 'neovim/nvim-lspconfig'
  use 'nvim-lua/plenary.nvim'
  use 'nvim-lua/popup.nvim'
  use 'nvim-telescope/telescope.nvim'
  use {
    'nvim-treesitter/nvim-treesitter',
    branch = '0.5-compat',
    run = ':TSUpdate',
  }
  use 'tpope/vim-surround'
  use 'vimwiki/vimwiki'
  use 'wbthomason/packer.nvim'
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
-- Enable syntax and index by plugins
vim.cmd('syntax enable')
vim.cmd('filetype plugin indent on')
-- Set SQL dialect to MySQL
vim.g.sql_type_default = 'mysql'
-- Setup VimWiki
vim.g.vimwiki_list = {{ path = '~/vimwiki/', syntax = 'markdown', ext = '.md' }}
vim.g.vimwiki_global_ext = 0

-- Theme configs
vim.g.material_style = 'palenight'
vim.cmd[[colorscheme dracula]]

-- LSP configs
require'lspconfig'.gopls.setup{}
require'lspconfig'.yamlls.setup{}
require'lspconfig'.dockerls.setup{}
require'lspconfig'.clangd.setup{}
require'lspconfig'.rust_analyzer.setup{}
require'lspconfig'.pyright.setup{}

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

require'lspconfig'.sumneko_lua.setup {
  cmd = { "lua-language-server", "-E", "/usr/share/lua-language-server/main.lua" };
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Setup your lua path
        path = runtime_path,
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {'vim'},
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
}

vim.api.nvim_set_keymap('n', 'gd', [[<cmd>lua vim.lsp.buf.definition()<CR>]], { noremap = true, silent = true } )
vim.api.nvim_set_keymap('n', 'gD', [[<cmd>lua vim.lsp.buf.declaration()<CR>]], { noremap = true, silent = true } )
vim.api.nvim_set_keymap('n', 'gr', [[<cmd>lua vim.lsp.buf.references()<CR>]], { noremap = true, silent = true } )
vim.api.nvim_set_keymap('n', 'gi', [[<cmd>lua vim.lsp.buf.implementation()<CR>]], { noremap = true, silent = true } )
vim.api.nvim_set_keymap('n', 'K', [[<cmd>lua vim.lsp.buf.hover()<CR>]], { noremap = true, silent = true } )
vim.api.nvim_set_keymap('n', '<C-k>', [[<cmd>lua vim.lsp.buf.signature_help()<CR>]], { noremap = true, silent = true } )
vim.api.nvim_set_keymap('n', '<C-n>', [[<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>]], { noremap = true, silent = true } )
vim.api.nvim_set_keymap('n', '<C-p>', [[<cmd>lua vim.lsp.diagnostic.goto_next()<CR>]], { noremap = true, silent = true } )
vim.api.nvim_set_keymap('n', '<Space>rn', [[<cmd>lua vim.lsp.buf.rename()<CR>]], { noremap = true, silent = true } )
vim.api.nvim_set_keymap('n', '<Space>ca', [[<cmd>lua vim.lsp.buf.code_action()<CR>]], { noremap = true, silent = true } )

-- Treesitter configs
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "go", "rust", "yaml", "lua", "python" },
  highlight = {
    enable = true,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
  indent = {
    enable = true,
  },
}

-- Compe configs
vim.o.completeopt = "menuone,noselect"

require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = true;

  source = {
    path = true;
    buffer = true;
    calc = true;
    nvim_lsp = true;
    nvim_lua = false;
    vsnip = false;
    omni = false;
  };
}

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
    local col = vim.fn.col('.') - 1
    return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
end

_G.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-n>"
  elseif vim.fn['vsnip#available'](1) == 1 then
    return t "<Plug>(vsnip-expand-or-jump)"
  elseif check_back_space() then
    return t "<Tab>"
  else
    return vim.fn['compe#complete']()
  end
end
_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-p>"
  elseif vim.fn['vsnip#jumpable'](-1) == 1 then
    return t "<Plug>(vsnip-jump-prev)"
  else
    -- If <S-Tab> is not working in your terminal, change it to <C-h>
    return t "<S-Tab>"
  end
end

vim.api.nvim_set_keymap('i', '<C-Space>', 'compe#complete()', { noremap = true, silent = true, expr = true } )
vim.api.nvim_set_keymap('i', '<CR>', "compe#confirm('<CR>')", { noremap = true, silent = true, expr = true } )
vim.api.nvim_set_keymap('i', '<C-e>', "compe#close('<C-e>')", { noremap = true, silent = true, expr = true } )
vim.api.nvim_set_keymap('i', '<C-f>', "compe#scroll({ 'delta': +4 })", { noremap = true, silent = true, expr = true } )
vim.api.nvim_set_keymap('i', '<C-d>', "compe#scroll({ 'delta': -4 })", { noremap = true, silent = true, expr = true } )
vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})

-- Lualine configs
require('lualine').setup{
  options = {
    theme = 'material'
  }
}

-- gitsigns configs
require('gitsigns').setup()


-- Telescope configs
vim.api.nvim_set_keymap('n', '<Leader>ff', [[<cmd>lua require('telescope.builtin').find_files()<CR>]], { noremap = true } )
vim.api.nvim_set_keymap('n', '<Leader>fg', [[<cmd>lua require('telescope.builtin').live_grep()<CR>]], { noremap = true } )
vim.api.nvim_set_keymap('n', '<Leader>fb', [[<cmd>lua require('telescope.builtin').buffers()<CR>]], { noremap = true } )
vim.api.nvim_set_keymap('n', '<Leader>fh', [[<cmd>lua require('telescope.builtin').help_tags()<CR>]], { noremap = true } )

-- nvim-tree configs
vim.api.nvim_set_keymap('n', '<C-n>', ":NvimTreeToggle<CR>", { noremap = true } )
vim.api.nvim_set_keymap('n', '<Leader>r', ":NvimTreeRefresh<CR>", { noremap = true } )
vim.api.nvim_set_keymap('n', '<Leader>n', ":NvimTreeFindFile<CR>", { noremap = true } )

-- nvim-toggleterm configs
require("toggleterm").setup{
  direction = 'float',
  open_mapping = [[<c-\>]],
}
