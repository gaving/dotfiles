let g:mapleader = ","
map <Space> <Leader>

call plug#begin('~/.vim/plugged')

Plug 'wincent/terminus'

Plug 'tpope/vim-abolish'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-projectionist'
Plug 'tpope/vim-obsession' | Plug 'dhruvasagar/vim-prosession'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-rsi'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/vim-easy-align'
Plug 'junegunn/vim-slash'
Plug 'junegunn/vim-peekaboo'
Plug 'junegunn/vim-pseudocl'

Plug 'justinmk/vim-dirvish'
Plug 'justinmk/vim-gtfo'
Plug 'justinmk/vim-sneak'

Plug 'kana/vim-textobj-indent'
Plug 'kana/vim-textobj-line'
Plug 'kana/vim-textobj-user'

Plug 'mhinz/vim-sayonara', { 'on': 'Sayonara' }
Plug 'mhinz/vim-startify'
Plug 'mhinz/vim-signify'

Plug 'christoomey/vim-tmux-navigator'
Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'edkolev/tmuxline.vim'

Plug 'andrewradev/splitjoin.vim'
Plug 'airblade/vim-rooter'
Plug 'alok/notational-fzf-vim'
Plug 'bkad/CamelCaseMotion'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install'  }
Plug 'neoclide/coc.nvim', {'tag': '*', 'branch': 'release'}
Plug 'rhysd/git-messenger.vim'
Plug 'tommcdo/vim-exchange'
Plug 'wellle/targets.vim'

Plug 'ap/vim-css-color'
Plug 'blueyed/vim-diminactive'
Plug 'jacoborus/tender.vim'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'noah/vim256-color'
Plug 'ntpeters/vim-better-whitespace'
Plug 'pangloss/vim-javascript'
Plug 'plasticboy/vim-markdown'
Plug 'psliwka/vim-smoothie'
Plug 'ryanoasis/vim-devicons'
Plug 'sheerun/vim-polyglot'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'xolox/vim-colorscheme-switcher'
Plug 'xolox/vim-misc'

call plug#end()

autocmd FileType help wincmd L

let &sbr = nr2char(8618).' '
set autowriteall
set backupdir=~/.vim/tmp
set clipboard+=unnamed
set directory=~/.vim/tmp
set foldmethod=marker
set hidden
set ignorecase
set lazyredraw
set list
set nojoinspaces
set nowrap
set nrformats+=alpha
set number
set scrolljump=5
set smartindent
set splitbelow
set splitright

if (has("termguicolors"))
  let &t_8f = "\[38;2;%lu;%lu;%lum"
  let &t_8b = "\[48;2;%lu;%lu;%lum"
  set termguicolors
endif

set textwidth=79
set undodir=~/.vim/tmp
set undofile
set undolevels=5000

inoremap jj <Esc>
inoremap <S-Up> <C-o><C-y>
inoremap <S-Down> <C-o><C-e>

nnoremap <nowait> ` <C-^>
nnoremap Q gqap
nnoremap q: :q
nnoremap gp `[v`]
nnoremap Y y$

noremap <Backspace> <C-y>
xnoremap <Backspace> "_x

nnoremap <Left>  :vertical resize +2<CR>
nnoremap <Right> :vertical resize -2<CR>
nnoremap <Up>    :resize +2<CR>
nnoremap <Down>  :resize -2<CR>

nnoremap <C-d> :Sayonara<CR>

nnoremap <Leader><Leader> :w<CR>
nnoremap <Leader>f :Files<CR>
nnoremap <Leader>d :Gvdiffsplit<CR>
nnoremap <Leader>g :Gstatus<CR>
nnoremap <Leader>o :only<CR>
nnoremap <Leader>p :GFiles<CR>
nnoremap <Leader>s :Startify<CR>
nnoremap <Leader>v :e $MYVIMRC<CR>
nnoremap <Leader>V :e $HOME/.vimrc.local<CR>

nnoremap [c :PrevColorScheme<CR>
nnoremap ]c :NextColorScheme<CR>

vmap <Enter> <Plug>(EasyAlign)

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#left_sep = ' '
let g:camelcasemotion_key = '<Leader>'
let g:diminactive_enable_focus = 1
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }
let g:nv_create_note_window = 'split'
let g:rooter_silent_chdir = 1
let g:tmuxline_powerline_separators = 0
let g:tmuxline_preset = {
      \'a'    : '#[bold]#S',
      \'b'    : '#(whoami)',
      \'win'  : '#W',
      \'cwin' : '#W',
      \'y'    : ['%R', '%a', '%d/%m/%y']}

let base16colorspace=256
let g:airline_theme='tender'
colorscheme tender

if filereadable(expand("~/.vimrc.local"))
    source ~/.vimrc.local
endif
