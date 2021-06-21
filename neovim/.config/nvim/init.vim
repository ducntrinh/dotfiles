call plug#begin('~/.vim/plugged')

Plug 'aklt/plantuml-syntax'
Plug 'hoob3rt/lualine.nvim'
Plug 'hrsh7th/nvim-compe'
Plug 'kyazdani42/nvim-tree.lua'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'lewis6991/gitsigns.nvim'
Plug 'marko-cerovac/material.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'tpope/vim-surround'
Plug 'vimwiki/vimwiki'

call plug#end()

" Show line number
set number

" Use system clipboard
set clipboard=unnamedplus

" Set current colorscheme
let g:material_style = 'palenight'
colorscheme material

" Show more color
set termguicolors

" Enable syntax for Rust
syntax enable
filetype plugin indent on

" Set SQL dialect to MySQL
let g:sql_type_default='mysql'  

" Setup VimWiki
let g:vimwiki_list = [{'path': '~/vimwiki/', 'syntax': 'markdown', 'ext': '.md'}]

" Load lua configs
lua require("config")

" Nvim-lspconfig key mappings
nnoremap <silent> gd	<cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> gD	<cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> gr	<cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> gi	<cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> K	<cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> <C-k>	<cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> <C-n>	<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>
nnoremap <silent> <C-p>	<cmd>lua vim.lsp.diagnostic.goto_next()<CR>

" Compe key mappings
inoremap <silent><expr> <C-Space> compe#complete()
inoremap <silent><expr> <CR>      compe#confirm('<CR>')
inoremap <silent><expr> <C-e>     compe#close('<C-e>')
inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })
inoremap <silent><expr> <TAB>     pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr>         <S-TAB>   pumvisible() ? "\<C-p>" : "\<C-h>"

" Telescop key mappings
nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<CR>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<CR>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<CR>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<CR>

" Nvim-tree key mappings
nnoremap <C-n> :NvimTreeToggle<CR>
nnoremap <leader>r :NvimTreeRefresh<CR>
nnoremap <leader>n :NvimTreeFindFile<CR>
