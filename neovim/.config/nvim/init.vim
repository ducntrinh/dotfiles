call plug#begin('~/.vim/plugged')

Plug '/usr/bin/fzf'
Plug 'drewtempelmeyer/palenight.vim'
" Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'hrsh7th/nvim-compe'
Plug 'junegunn/fzf.vim'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
" Plug 'rust-lang/rust.vim'
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
Plug 'vimwiki/vimwiki'

call plug#end()

" Show line number
set number

" Use system clipboard
set clipboard=unnamedplus

" Use dark background
set background=dark

" Set current colorscheme
colorscheme palenight

" Show more color
set termguicolors

" Enable syntax for Rust
syntax enable
filetype plugin indent on

" Palenight customization
let g:palenight_terminal_italics=1

" Set SQL dialect to MySQL
let g:sql_type_default='mysql'  

" disable vim-go :GoDef short cut (gd) this is handled by LanguageClient [LC]
let g:go_def_mapping_enabled = 0

" Use golangci-lint as linter
let g:go_metalinter_command = "golangci-lint"

" Load lua configs
lua require("config")

" Compe key mappings
inoremap <silent><expr> <C-Space> compe#complete()
inoremap <silent><expr> <CR>      compe#confirm('<CR>')
inoremap <silent><expr> <C-e>     compe#close('<C-e>')
inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })
inoremap <silent><expr> <TAB>     pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr>         <S-TAB>   pumvisible() ? "\<C-p>" : "\<C-h>"
