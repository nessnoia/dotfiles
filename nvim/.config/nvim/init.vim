set nocompatible
filetype plugin on
set encoding=utf-8

"" Auto download vim-plug if it is not downloaded already
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif
call plug#begin()

" ----- List of all Plugins -----

" Automatically close quotes, parens, etc
Plug 'Raimondi/delimitMate'

" Colour code brackets
Plug 'luochen1990/rainbow'

" Gutter symbols for git
Plug 'mhinz/vim-signify'

" Git blame
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'

" Fuzzy finder for vim
Plug 'junegunn/fzf', { 'do': 'yes \| ./install' }
Plug 'junegunn/fzf.vim'

" Quickfix / location list useful shortcuts
Plug 'tpope/vim-unimpaired'

" File explorer tree
Plug 'preservim/nerdtree'

" Better AgRaw
Plug 'jesseleite/vim-agriculture'

" Better go syntax
" Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }

" Colour themes
Plug 'navarasu/onedark.nvim'

" Pretty hacker boy bar
Plug 'nvim-lualine/lualine.nvim'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'akinsho/bufferline.nvim', { 'tag': '*' }

" LSP
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'neovim/nvim-lspconfig'

" Autocomplete
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/nvim-cmp'

" Treesitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" Surroundings
Plug 'tpope/vim-surround'

" Prettier
Plug 'prettier/vim-prettier'

" Undo highlighting when search is done
Plug 'romainl/vim-cool'

" Better commenting
Plug 'tpope/vim-commentary'

" Autoclose HTML tags
Plug 'windwp/nvim-ts-autotag'

" All of your Plugins must be added before the following line
call plug#end() " required

lua require('config')

"" Fuzzy Finding
let g:rainbow_active = 1
let g:fzf_vim = {}
let g:fzf_preview_window = ['up:35%', 'ctrl-/']

nnoremap <silent> <C-a> :Ag<cr>
nmap <silent> <C-s> <Plug>AgRawWordUnderCursor<cr>
xmap <silent> <C-s> <Plug>AgRawVisualSelection<cr>

nnoremap <silent> <C-p> :Prettier<cr>
nnoremap <C-f> :Files<CR>


"" Lualine
" let g:airline#extensions#tabline#enabled = 2
" let g:airline#extensions#tabline#show_buffers = 1
" let g:airline#extensions#tabline#left_alt_sep = '|'
" let g:airline#extensions#tabline#formatter = 'default'
" let g:airline#theme = 'term'


"" Python support
let g:python2_host_prog = '/usr/bin/python'
let g:python3_host_prog = '/usr/local/bin/python3'


"" Git gutter symbols
let g:signify_sign_change = '~'
let g:signify_priority = 1
let g:signify_sign_overwrite = 0


"" Prettier
" Autoformatting on save
" let g:prettier#autoformat_config_present = 1
" let g:prettier#autoformat_require_pragma = 0
" let g:prettier#autoformat_config_files = [".prettierrc"]

" Prettier config settings
let g:prettier#config#tab_width = 4
let g:prettier#config#use_tabs = 'false'
let g:prettier#config#parser = 'json'


set termguicolors
syntax on
colorscheme onedark


"" Git specific helpers
" 'git web...' open in webbrowser (current branch)
nmap gw :.GBrowse<CR>
nmap gb :G blame<CR>
" 'git upstream' open upstream master in webbrowser
nmap gu :.GBrowse upstream/master:%<CR>
" 'git preview' open preview of commit on line
nmap gp :0,3Git blame<CR>
" 'git undo'
nmap gU :SignifyHunkUndo<CR>


"" List Buffers
nnoremap gB :ls<CR>:b<Space>

"" Nerd Tree
nnoremap <C-n> :NERDTreeToggle<CR>


"" Vim Config
" Enable mouse reporting
" set mouse=a

" Invisibles
set list
set listchars=eol:¬,tab:—→,trail:■

" Hard tabs
set autoindent noexpandtab tabstop=2 shiftwidth=2

" Show matching brackets
set showmatch

" Show line number
set number

" Wrap text after x characters
set wrap
set textwidth=120

" Searches ignore case
set ignorecase

" Disable folding
set nofoldenable

" Don't use swapfile
set noswapfile

" Reduce update time for better git signify
" Default updatetime 4000ms is not good for async update
set updatetime=2000

" Quick navigation while in insert mode
imap <C-h> <left>
imap <C-j> <down>
imap <C-k> <up>
imap <C-l> <right>

" Instead of tabs, just use buffers
nnoremap <C-l> :bn!<CR>
nnoremap <C-h> :bp!<CR>

" Close buffer and force close buffer
set confirm
nnoremap <C-x> :bw<CR>

" Close buffer without closing window
nnoremap <Leader>x :bp<bar>sp<bar>bn<bar>bd<CR>

" Accelerated scrolling
noremap J 5j
noremap K 5k
noremap H 5h
noremap L 5l

" Search up and down path for gf
set path+=**;

" Change cursor between modes
" Vertical bar in insert mode
let &t_SI = "\e[6 q"
" Block in normal mode
let &t_EI = "\e[2 q"
" Underline in replace mode
let &t_SR = "\e[4 q"

" Allow saving of files as sudo when I forgot to start vim using sudo.
cmap w!! w !sudo tee > /dev/null %

