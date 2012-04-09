if !has("unix")
  set rtp&
  let &rtp = expand('~/.vim').','.&rtp.','.expand('~/.vim/after')
endif

runtime macros/matchit.vim
runtime ftplugin/man.vim

call pathogen#infect()
call pathogen#helptags()

filetype on
filetype indent on
filetype plugin on
syntax on

if has('gui_running')
    set guioptions=cM
    set cursorline
endif

if has('spell')
    set spell
    set spelllang=en_gb
    set spellfile=~/.vim/spell/spellfile.add
    set spellsuggest=best,10
endif

if has('unix')
    set backupdir=$HOME/.vim/tmp
    set directory=$HOME/.vim/tmp
endif

if has('persistent_undo')
    set undofile
    set undodir=$HOME/.vim/tmp
endif

autocmd BufEnter * silent! lcd %:p:h:gs/ /\\ /
autocmd FileType help wincmd L

" {{{1 Settings

set nocompatible
set nomodeline

set autoindent
set autowriteall " Watch this!
set backspace=start,indent,eol
set clipboard+=unnamed
set expandtab
set foldclose=all
set foldmethod=marker
set enc=utf-8
set incsearch
set lazyredraw
set list

" Show tabs and trailing whitespace visually
if (&termencoding == "utf-8") || has("gui_running")
    if has("gui_running")
        set list listchars=tab:»·,trail:·,extends:…,nbsp:‗
    else
        set list listchars=tab:»·,trail:·,extends:>,nbsp:_
    endif
else
    set list listchars=tab:>-,trail:.,extends:>,nbsp:_
endif

let &sbr = nr2char(8618).' '
set hidden
set history=5000
set icon
set ignorecase
set laststatus=2
set nojoinspaces
set nowrap
set nrformats=hex,octal,alpha
set number
set scrolljump=5
set scrolloff=3
set shiftwidth=4
set shortmess+=I
set showcmd
set sidescroll=1
set sidescrolloff=10
set smartcase
set smartindent
set smarttab
set softtabstop=4

if exists('+shellslash')
    set shellslash
endif

set splitright
set splitbelow
set suffixes+=.class,.gz,.zip,.bz2,.tar,.pyc
set suffixes-=.h
set t_Co=256
set timeoutlen=700
set tags=tags;/
set textwidth=79
set ttyfast
set viminfo='100,f1
set wildignore+=*.o,*.r,*.class,*.pyc,*.so,*.sl,*.tar,*.tgz,*.gz,*.dmg,*.zip,*.pdf,*CVS/*,*.svn/*,*.toc,*.aux,*.dvi,*.log
set wildmode=full
set wildmenu

" {{{1 Abbreviations

ca Set set
ca ~? ~/

command! -bang -nargs=* -complete=file W :w <args>
command! -bang -nargs=* -complete=file E :e <args>
command! -bang -nargs=* -complete=help He :he <args>
command! -bang -nargs=* Retab :retab <args>

" {{{1 Mappings

let mapleader = ","
let maplocalleader = ","

nnoremap <Leader>v :e $HOME/.vimrc<CR>
nnoremap <Leader>vl :e $HOME/.vimrc.local<CR>

nnoremap <Leader>w :w<cr>
nnoremap <Leader>d :lcd %:p:h<cr>
nnoremap <leader>o <C-w>o
nnoremap <Leader>E :e <C-r>=expand("%:p:h")<CR>/<C-d>

nnoremap <Leader><CR> :noh<CR>
nnoremap <silent> <Leader>/ :execute 'vimgrep /'.@/.'/g %'<CR>:copen<CR>
nnoremap <silent> XX :w<bar>bd<cr>

" {{{2 Insert

inoremap jj <Esc>
inoremap <S-Up> <C-o><C-y>
inoremap <S-Down> <C-o><C-e>

" {{{2 Normal

noremap <Backspace> <C-y>

noremap <silent> g<backspace> <c-o>
noremap <silent> g<return> <c-i>

noremap <silent> gb :bnext<cr>
noremap <silent> gB :bprev<cr>
noremap <silent> gd :bd<cr>
noremap <silent> gD :bd!<cr>
noremap <silent> g<space> :b#<cr>

" Remap old behavior
noremap <silent> <Leader>gd gd
noremap <silent> <Leader>gD gD

" Diff commands
nnoremap <Leader>du :diffupdate<CR>
nnoremap <Leader>dg :diffget<CR>
nnoremap <Leader>dp :diffput<CR>
nnoremap <Leader>do :diffof<CR>
nnoremap <Leader>ds :vertical diffsplit <C-r>=expand("%:p:h")<CR>/<C-d>

nnoremap ` <C-^>
noremap <Space> <C-f>
noremap gp `[v`]
noremap <C-d> "_dd

noremap Y y$
noremap q: :q
noremap ; :
noremap , ;
xno <bs> "_x

noremap <C-e> 3<C-e>
noremap <C-y> 3<C-y>
noremap + <C-a>
noremap - <C-x>

" Window navigation
nnoremap <silent> <A-Up> :wincmd k<CR>
nnoremap <silent> <A-Down> :wincmd j<CR>
nnoremap <silent> <A-Left> :wincmd h<CR>
nnoremap <silent> <A-Right> :wincmd l<CR>

" Delete trailing whitespace
noremap <Leader>dtw :%s/\s\+$//g<CR>:nohls<CR>

" Delete blank lines
noremap <Leader>dbl :g/^$/d<CR>:nohls<CR>

" Swap two words
noremap <silent> gw :s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<CR>``

" Toggles
noremap <silent> <Leader>p :set paste!<CR>:set paste?<CR>
noremap <silent> <Leader>i :set list!<CR>:set list?<CR>
noremap <silent> <Leader>s :set spell!<CR>:set spell?<CR>

" Start substitution with word under cursor
noremap <Leader>z :%s/\<<c-r><c-w>\>//g<Left><Left>
noremap <Leader>Z :%S/<c-r><c-w>//g<Left><Left>
vmap <Leader>z :<c-u>%s/\<<c-r>*\>/

" {{{2 Command

cnoremap <C-A> <Home>
cnoremap <ESC>b <S-Left>
cnoremap <ESC>f <S-Right>
cnoremap w!! %!sudo tee > /dev/null %

" {{{1 Extensions

" {{{2 ctrlp.vim

let g:ctrlp_extensions = ['tag', 'buffertag', 'quickfix', 'dir', 'mixed']

nnoremap <Leader>b :CtrlPBuffer<CR>
nnoremap <Leader>f :CtrlP<CR>
nnoremap <Leader>m :CtrlPMixed<CR>
nnoremap <Leader>t :CtrlPTag<CR>

" {{{2 setcolors.vim

nnoremap <Leader>un :call NextColor(1)<CR>
nnoremap <Leader>up :call NextColor(-1)<CR>
nnoremap <Leader>ur :call NextColor(0)<CR>

" {{{2 camelcasemotion.vim

map <silent> w <Plug>CamelCaseMotion_w
map <silent> b <Plug>CamelCaseMotion_b
map <silent> e <Plug>CamelCaseMotion_e

" {{{2 ack.vim

nnoremap <Leader>a :Ack

" {{{2 syntastic.vim

nnoremap <Leader>e :Errors<CR><C-w>j

" {{{2 NERD_commenter.vim

let NERDMenuMode=0

" {{{2 changesqlcase.vim

vmap <silent> <Leader>uc :FixSQLCase<CR>

" {{{1 Local settings

if filereadable(expand("~/.vimrc.local"))
    source ~/.vimrc.local
endif
