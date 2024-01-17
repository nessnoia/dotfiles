set nocompatible " be iMproved, required
filetype off	" required
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

" Gutter symbols for git
Plug 'mhinz/vim-signify'

" Fuzzy finder for vim
Plug 'junegunn/fzf', { 'do': 'yes \| ./install' }
Plug 'junegunn/fzf.vim'

" Quickfix / location list useful shortcuts
Plug 'tpope/vim-unimpaired'

" File explorer tree
Plug 'preservim/nerdtree'

" Better AgRaw
Plug 'jesseleite/vim-agriculture'

" Pretty hacker boy bar
Plug 'vim-airline/vim-airline'

" Ale with signature help
Plug 'nessnoia/vim-lsp-downloader'
Plug 'nessnoia/ale'

" Syntax highlighting
Plug 'sheerun/vim-polyglot'

" Undo highlighting when search is done
Plug 'romainl/vim-cool'

" Better commenting
Plug 'tpope/vim-commentary'

" All of your Plugins must be added before the following line
call plug#end() " required


"" Vim LSP Downloader
let g:lsp_export_to_path = 1


"" ALE
let g:ale_syntax_highlight_floating_preview = 1

let g:ale_hover_cursor = 0
let g:ale_completion_enabled = 1
let g:ale_floating_preview = 1
let g:ale_floating_window_border = []
let g:ale_floating_preview_popup_opts = {
			\ 'close': 'none',
			\ 'pos': 'botleft',
			\ 'line': 'cursor-1',
			\	}

" Autocomplete tab through list
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <Down>   pumvisible() ? "\<C-n>" : "\<Down>"
inoremap <expr> <Up> pumvisible() ? "\<C-p>" : "\<Up>"

autocmd CursorHold * silent! ALEHover
autocmd CursorMovedI * silent! ALESignatureHelp

set completeopt=menuone,noinsert,noselect,menu
set completeopt-=preview


"" Fuzzy Finding
let g:rainbow_active = 1
let g:fzf_vim = {}
let g:fzf_preview_window = ['up:35%', 'ctrl-/']
let g:fzf_vim.listproc = { list -> fzf#vim#listproc#location(list) }

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


"" Git gutter symbols
let g:signify_sign_change = '~'


syntax on


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

" Make so vim does not open extremely tiny
set lines=120
set columns=80

" Change cursor between modes
" Vertical bar in insert mode
let &t_SI = "\e[6 q"
" Block in normal mode
let &t_EI = "\e[2 q"
" Underline in replace mode
let &t_SR = "\e[4 q"

" Allow saving of files as sudo when I forgot to start vim using sudo.
cmap w!! w !sudo tee > /dev/null %

