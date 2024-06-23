set nocompatible
filetype plugin on
set encoding=utf-8

"" Auto download vim-plug if it is not downloaded already
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()

" ----- List of all Plugins -----

" Automatically close quotes, parens, etc
Plug 'Raimondi/delimitMate'

" Colour code brackets
Plug 'luochen1990/rainbow'

" Markdown preview in vim
Plug 'JamshedVesuna/vim-markdown-preview'

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
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }

" Onedark colour theme
Plug 'joshdick/onedark.vim'

" Pretty hacker boy bar
Plug 'vim-airline/vim-airline'

" Allows for theming the airline bar
Plug 'vim-airline/vim-airline-themes'

" LSP
Plug 'nessnoia/vim-lsp-downloader'
Plug 'yegappan/lsp'

" Syntax highlighting
Plug 'sheerun/vim-polyglot'

" Autoclose html
" Plug 'alvan/vim-closetag'
"
" Surroundings
Plug 'tpope/vim-surround'

" Prettier
Plug 'prettier/vim-prettier'

" Undo highlighting when search is done
Plug 'romainl/vim-cool'

" Better commenting
Plug 'tpope/vim-commentary'

" Auto update tags
Plug 'ludovicchabant/vim-gutentags'

" All of your Plugins must be added before the following line
call plug#end() " required


"" Vim LSP Downloader
let g:lsp_export_to_path = 1


" Autocomplete tab through list
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <Down>   pumvisible() ? "\<C-n>" : "\<Down>"
inoremap <expr> <Up> pumvisible() ? "\<C-p>" : "\<Up>"


"" LSP Setup
let lspOpts = #{
			\     autoHighlightDiags: v:true,
			\     diagSignErrorText: 'E',
			\     diagSignHintText: 'H',
			\     diagSignIntoText: 'I',
			\     diagSignWarningText: 'W',
			\     ignoreMissingServer: v:true,
			\     showDiagInPopup: v:false,
			\     showDiagOnStatusLine: v:true,
			\ }

autocmd User LspSetup call LspOptionsSet(lspOpts)

let lspServers = [#{
	\	   name: 'go',
	\	   filetype: ['go', 'gomod'],
	\	   path: 'gopls',
	\	   args: ['serve'],
	\    syncInit: v:true,
	\ }, #{
	\    name: 'tsserver',
	\    filetype: ['typescript', 'javascript', 'typescriptreact', 'javascriptreact'],
	\    path: 'typescript-language-server',
	\    args: ['--stdio'],
	\    debug: v:true,
	\ }, #{
	\    name: 'svelte-server',
	\    filetype: ['svelte'],
	\    path: 'svelte-language-server',
	\    args: ['--stdio'],
	\    rootSearch: ['package.json', '.git'],
	\ }]

autocmd User LspSetup call LspAddServer(lspServers)

nnoremap gr :LspShowReferences<CR>
nnoremap gi :LspGotoImpl<CR>
nnoremap gR :LspRename<CR>
nnoremap gd :LspGotoDefinition<CR>
nnoremap gh :LspHover<CR>

" Handy for jumping between errors
nmap <silent> [E :LspDiag prev<CR>
nmap <silent> ]E :LspDiag next<CR>


"" Gutentags
let g:gutentags_cache_dir = expand('~/.cache/vim/ctags')
let g:gutentags_ctags_extra_args = [
      \ '--tag-relative=yes',
      \ '--fields=+ailmnS',
      \ ]
let g:gutentags_ctags_exclude = [
      \ '*.git',
      \ 'build',
      \ 'bin',
      \ 'node_modules',
      \ 'cache',
      \ '*-lock.json',
      \ '*.lock',
      \ '*bundle*.js',
      \ '*build*.js',
      \ '*.json',
      \ '*.class',
      \ '*.csproj.user',
      \ '*.cache',
      \ ]


"" Fuzzy Finding
let g:rainbow_active = 1
let g:fzf_vim = {}
let g:fzf_preview_window = ['up:35%', 'ctrl-/']

nnoremap <silent> <C-a> :Ag<cr>
nmap <silent> <C-s> <Plug>AgRawWordUnderCursor<cr>
xmap <silent> <C-s> <Plug>AgRawVisualSelection<cr>

nnoremap <silent> <C-p> :Prettier<cr>
nnoremap <C-f> :Files<CR>


"" Airline
let g:airline#extensions#tabline#enabled = 2
let g:airline#extensions#tabline#show_buffers = 1
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#formatter = 'default'
let g:airline#theme = 'term'


"" Go Vim
let g:go_fmt_command = 'gofmt'

autocmd FileType go nnoremap gr :GoReferrers<CR>
autocmd FileType go nnoremap gC :GoCallers<CR>
autocmd FileType go nnoremap gv :GoVet -composites=false<CR>
autocmd FileType go nnoremap gi :GoImplements<CR>
autocmd FileType go nnoremap gt :GoTest<CR>
autocmd FileType go nnoremap gH :GoDecls<CR>
autocmd FileType go nnoremap gR :GoRename<CR>

" Fmt and simplify code
let g:go_fmt_options = ' -s'
let g:go_def_mode = 'gopls'
let g:go_info_mode = 'gopls'

" Extra syntax highlighting
let g:go_highlight_function_calls = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_operators = 1

let g:go_doc_keywordprg_enabled = 0

" Make list quickfix cause locationlist is acting up
let g:go_list_type = 'quickfix'


"" Python support
let g:python2_host_prog = '/usr/bin/python'
let g:python3_host_prog = '/usr/local/bin/python3'


"" Git gutter symbols
let g:signify_sign_change = '~'


"" Svelte
let g:vim_svelte_plugin_use_typescript = 1


"" Prettier
" Autoformatting on save
let g:prettier#autoformat_config_present = 1
let g:prettier#autoformat_require_pragma = 0
let g:prettier#autoformat_config_files = [".prettierrc"]

" Prettier config settings
let g:prettier#config#tab_width = 4
let g:prettier#config#use_tabs = 'false'
let g:prettier#config#parser = 'json'


"" Filetypes where closetag is active
let g:closetag_filenames = '*.html,*.xhtml,*.phtml,*.svelte'
let g:closetag_filetypes = 'html,xhtml,phtml,svelte'
" So delimitMate doesn't match <> when closetag is active
au FileType svelte,html let b:delimitMate_matchpairs = "(:),[:],{:}"


"" One Dark theme and colours
let g:onedark_color_overrides = {
\ "background": { "gui": "#050505", "cterm": "232", "cterm16": "0" },
\ "menu_grey": {"gui": "#383e4a", "cterm": "235", "cterm16": "0" },
\}

set termguicolors
syntax on
colorscheme onedark
hi LspSigActiveParameter gui=reverse cterm=reverse


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
set mouse=a

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

" Attempt to indent automatically
set autoindent
set smartindent

" Searches ignore case
set ignorecase
set hlsearch
set incsearch

" Disable folding
set nofoldenable

" Show me what I'm typing
set showcmd

" Don't use swapfile
set noswapfile

" Allow backspacing over everything
set backspace=indent,eol,start

" Reduce update time for better git signify
" Default updatetime 4000ms is not good for async update
set updatetime=2000

" Quick navigation while in insert mode
imap <C-h> <left>
imap <C-j> <down>
imap <C-k> <up>
imap <C-l> <right>

" Set hidden lets you open a new file while in an unwritten buffer
set hidden

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

" No search hit bottom or top messages
set shortmess-=S

" Automatically reload buffer when file has been detected to be changed outside of Vim
set autoread

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

