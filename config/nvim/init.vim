call plug#begin('~/.vim/plugged')

Plug 'wincent/terminus'

Plug 'tpope/vim-abolish'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-projectionist'
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

Plug 'airblade/vim-rooter'
Plug 'andrewradev/splitjoin.vim'
Plug 'bkad/CamelCaseMotion'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
Plug 'liuchengxu/vim-which-key'
Plug 'neoclide/coc.nvim', {'tag': '*', 'branch': 'release'}
Plug 'rhysd/git-messenger.vim'
Plug 'wellle/targets.vim'

Plug 'ap/vim-css-color'
Plug 'blueyed/vim-diminactive'
Plug 'jacoborus/tender.vim'
Plug 'maxmellon/vim-jsx-pretty'
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
set timeoutlen=500

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
nnoremap Y y$

noremap <Backspace> <C-y>
xnoremap <Backspace> "_x

nnoremap <C-d> :Sayonara<CR>

nnoremap [c :PrevColorScheme<CR>
nnoremap ]c :NextColorScheme<CR>

vmap <Enter> <Plug>(EasyAlign)

let g:mapleader = ","
let g:maplocalleader = "\<Space>"
nnoremap <silent><Leader> :<c-u>WhichKey ','<CR>
vnoremap <silent><Leader> :<c-u>WhichKey ','<CR>
nnoremap <silent><LocalLeader> :<c-u>WhichKey '<Space>'<CR>
vnoremap <silent><LocalLeader> :<c-u>WhichKeyVisual '<Space>'<CR>

let g:which_key_map =  {}
let g:which_key_sep = '→'
let g:which_key_use_floating_win = 0

let g:which_key_map[','] = [':w', 'write']
let g:which_key_map['/'] = [':Rg', 'ripgrep']
let g:which_key_map['b'] = 'camelcasemotion-b'
let g:which_key_map['c'] = [':Commands', 'commands']
let g:which_key_map['d'] = [':Gvdiffsplit', 'split diff']
let g:which_key_map['e'] = 'camelcasemotion-e'
let g:which_key_map['f'] = [':Files', 'files']
let g:which_key_map['g'] = [':Gstatus', 'git']
let g:which_key_map['m'] = [':GitMessenger', 'git messenger']
let g:which_key_map['o'] = [':only', 'only']
let g:which_key_map['p'] = [':GFiles', 'git files']
let g:which_key_map['s'] = [':Startify', 'startify']
let g:which_key_map['v'] = [':e $MYVIMRC', 'open .vimrc']
let g:which_key_map['V'] = [':e $HOME/.vimrc.local', 'open .vimrc.local']
let g:which_key_map['w'] = 'camelcasemotion-w'
let g:which_key_map['z'] = [':e $HOME/.zshrc', 'open .zshrc']
let g:which_key_map['Z'] = [':e $HOME/.zsh/custom', 'open .zsh/custom']

call which_key#register(',', 'g:which_key_map')

let g:airline#extensions#tmuxline#enabled = 0
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#left_sep = ' '
let g:camelcasemotion_key = '<Leader>'
let g:diminactive_enable_focus = 1
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }
let g:git_messenger_no_default_mappings = 1
let g:rooter_silent_chdir = 1
let g:tmuxline_powerline_separators = 0
let g:tmuxline_preset = {
      \'a'    : '#[bold]#S',
      \'b'    : '#(whoami)',
      \'win'  : '#W',
      \'cwin' : '#W',
      \'y'    : ['%R', '%a', '%d/%m/%y']}
let g:vim_markdown_folding_level = 2
let g:vim_markdown_no_default_key_mappings = 1

let base16colorspace=256
let g:airline_theme='tender'
colorscheme tender

if filereadable(expand("~/.vimrc.local"))
    source ~/.vimrc.local
endif
