if !has("unix")
  set rtp&
  let &rtp = expand('~/.vim').','.&rtp.','.expand('~/.vim/after')
endif

runtime macros/matchit.vim
runtime ftplugin/man.vim

call pathogen#infect()
call pathogen#helptags()

" {{{1 GUI

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

" {{{1 Autocmds

set nocompatible
set nomodeline

filetype on
filetype indent on
filetype plugin on
syntax on

" {{{1 Platform

if has('unix')
    set backupdir=$HOME/.vim/tmp
    set directory=$HOME/.vim/tmp
endif

if exists('+autochdir')
    set autochdir
else
    autocmd BufEnter * silent! lcd %:p:h:gs/ /\\ /
endif

if has('persistent_undo')
    set undofile
    set undodir=$HOME/.vim/tmp
endif

autocmd FileType help wincmd L

" {{{1 Settings

set autoindent
set autowriteall " Watch this!
set backspace=start,indent,eol
set clipboard+=unnamed
set complete=.,w,b,u,t,i
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
set history=1000
set icon
set ignorecase
set laststatus=2
set noautoread
set noerrorbells
set nojoinspaces
set novisualbell
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

" {{{2 General

let mapleader = ","
let maplocalleader = ","

nmap <Leader>v :e $HOME/.vimrc<CR>

" {{{2 Insert

inoremap jj <Esc>
inoremap <S-Up> <C-o><C-y>
inoremap <S-Down> <C-o><C-e>

" {{{2 Normal

noremap <Backspace> <C-y>
"noremap <CR> <C-e> (breaks quickfix)

noremap <silent> g<backspace> <c-o>
noremap <silent> g<return> <c-i>

noremap <silent> gb :bnext<cr>
noremap <silent> gB :bprev<cr>
noremap <silent> gd :bd<cr>
noremap <silent> gD :bd!<cr>
noremap <silent> g<space> :b#<cr>

" Remap old behavior
noremap <silent> <leader>gd gd
noremap <silent> <leader>gD gD

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

noremap <silent> XX :w<bar>bd<cr>

noremap <Leader>w :w<cr>
noremap <Leader>D :lcd %:p:h<cr>
noremap <Leader><CR> :noh<CR>

nnoremap <silent> <leader>/ :execute 'vimgrep /'.@/.'/g %'<CR>:copen<CR>

noremap <C-e> 3<C-e>
noremap <C-y> 3<C-y>
noremap + <C-a>
noremap - <C-x>

" Window navigation
nmap <silent> <A-Up> :wincmd k<CR>
nmap <silent> <A-Down> :wincmd j<CR>
nmap <silent> <A-Left> :wincmd h<CR>
nmap <silent> <A-Right> :wincmd l<CR>

" Delete trailing whitespace
noremap <Leader>dtw :%s/\s\+$//g<CR>:nohls<CR>

" Delete blank lines
noremap <Leader>dbl :g/^$/d<CR>:nohls<CR>

" Edit something in the current directory
noremap <Leader>ed :e <C-r>=expand("%:p:h")<CR>/<C-d>

" Swap two words
noremap <silent> gw :s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<CR>``

" Toggle paste
noremap <silent> <Leader>p :set invpaste<CR>:set paste?<CR>

" Toggle invisibles
noremap <silent> <Leader>i :set list!<CR>:set list?<CR>

" Underline the current line with '='
noremap <silent> <Leader>ul :t.\|s/./=/g\|set nohls<cr>

" Delete surrounding block
noremap dsb VaImk$%dkV`kj<`kdd

" Start substitution with word under cursor
noremap <leader>z :%s/\<<c-r><c-w>\>//g<Left><Left>
noremap <leader>Z :%S/<c-r><c-w>//g<Left><Left>
vmap <leader>z :<c-u>%s/\<<c-r>*\>/

" Fix ( foo ) to (foo)
map <leader>x( :%s/(\s\+/(/gc<cr>
map <leader>x) :%s/\s\+)/)/gc<cr>

" Fix ; with leading spaces
map <leader>x; :%s/\s\+;/;/gc<cr>

" Fix , with leading spaces
map <leader>x, :%s/\s\+,/,/gc<cr>

" {{{2 Command

cnoremap <C-A> <Home>
cnoremap <ESC>b <S-Left>
cnoremap <ESC>f <S-Right>
cnoremap w!! %!sudo tee > /dev/null %

" {{{1 Plugins

" {{{2 ctrlp.vim

let g:ctrlp_extensions = ['tag', 'buffertag', 'quickfix', 'dir']

nmap <Leader>b :CtrlPBuffer<CR>
nmap <Leader>f :CtrlP<CR>
nmap <Leader>m :CtrlPMRU<CR>

nmap <Leader>T :CtrlPTag<CR>

" {{{2 setcolors.vim

nnoremap <Leader>un :call NextColor(1)<CR>
nnoremap <Leader>up :call NextColor(-1)<CR>
nnoremap <Leader>ur :call NextColor(0)<CR>

" {{{2 camelcasemotion.vim

nmap <silent> w <Plug>CamelCaseMotion_w
nmap <silent> b <Plug>CamelCaseMotion_b
nmap <silent> e <Plug>CamelCaseMotion_e
omap <silent> iw <Plug>CamelCaseMotion_iw
vmap <silent> iw <Plug>CamelCaseMotion_iw
omap <silent> ib <Plug>CamelCaseMotion_ib
vmap <silent> ib <Plug>CamelCaseMotion_ib
omap <silent> ie <Plug>CamelCaseMotion_ie
vmap <silent> ie <Plug>CamelCaseMotion_ie

" {{{2 supertab.vim

let g:SuperTabDefaultCompletionType = "<c-n>"

" {{{2 NERD_tree.vim

let NERDTreeIgnore=['CVS']
let NERDTreeMinimalUI=1
let NERDTreeDirArrows=1

" {{{2 NERD_commenter.vim

let NERDMenuMode=0

" {{{2 changesqlcase.vim

vmap <silent> <leader>uc :FixSQLCase<CR>

" {{{2 syntastic.vim

let g:syntastic_enable_signs=1
let g:syntastic_auto_loc_list=1

" {{{2 scratch.vim

nnoremap <Leader>s :Scratch<CR>

" {{{1 Local settings

if filereadable(expand("~/.vimrc.local"))
    source ~/.vimrc.local
endif
