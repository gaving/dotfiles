" .vimrc configuration

" use .vim folder instead of vimfiles on windows.
if !has("unix")
  set rtp&
  let &rtp = expand('~/.vim').','.&rtp.','.expand('~/.vim/after')
endif

let $VIMHOME = split(&rtp, ',')[0]
silent! call pathogen#runtime_prepend_subdirectories($VIMHOME.'/bundles')

" {{{1 GUI

if has('gui_running')
    set lines=70
    set columns=100
    set guioptions=cM
    set guicursor=a:blinkon0
    set cursorline

    if has("gui_win32")
        set guifont=Consolas:h10:cDEFAULT
    elseif has("gui_macvim")
        set guifont=Monaco:h12.00
        map <D-t> :CommandT<CR>
    endif

    if has('spell')
        set spell
        set spelllang=en_gb
        set spellfile=~/.vim/spell/spellfile.add
        set spellsuggest=best,10
    endif
endif

" {{{1 Autocmds

augroup vimrcEx
autocmd! BufWritePost .vimrc source %

autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

augroup END

filetype indent on
filetype plugin on

if &t_Co > 2 || has('gui_running')
    syntax on
endif

" {{{1 Platform

set backupdir=$HOME/.vim/tmp
set directory=$HOME/.vim/tmp

silent! call pathogen#helptags()

if exists('+autochdir')
    set autochdir
else
    autocmd BufEnter * silent! lcd %:p:h:gs/ /\\ /
endif

autocmd FileType help wincmd L

if has('persistent_undo')
    set undofile
    set undodir=$HOME/.vim/tmp
endif

" {{{1 Settings

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

set noautoread
set nocompatible
set noerrorbells
set hidden
set icon
set ignorecase
set nojoinspaces
set novisualbell
set nowrap
set nrformats=hex,octal,alpha
set number
let &sbr = nr2char(8618).' '
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
set laststatus=2
set history=1000

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
set wildignore+=*.o,*.r,*.class,*.pyc,*.so,*.sl,*.tar,*.tgz,*.gz,*.dmg,*.zip,*.pdf,*CVS/*,*.svn/*,*.git/*,*.toc,*.aux,*.dvi,*.log
set wildmode=full
set wildmenu

" Dictionary completion!
if has('unix')
    set dictionary=/usr/share/dict/words
endif

set complete=.,w,b,u,t,i

" {{{1 Lines

if has('title') && (has('gui_running') || &title)
    set titlestring=%f%h%m%r%w\ -\ %{v:progname}
endif

" {{{1 Abbreviations

ia teh the
ia htis this
ia tihs this
ia eariler earlier
ia funciton function
ia funtion function
ia fucntion function
ia retunr return
ia reutrn return
ia foreahc foreach
ia !+ !=

ca Set set
ca eariler earlier
ca !+ !=
ca ~? ~/

command! -bang -nargs=* -complete=file W :w <args>
command! -bang -nargs=* -complete=file E :e <args>
command! -bang -nargs=* -complete=help He :he <args>
command! -bang -nargs=* Retab :retab <args>

" {{{1 Mappings

" {{{2 General

let mapleader = ","
let maplocalleader = ","

nmap <Leader>s :source $HOME/.vimrc<CR>
nmap <Leader>v :e $HOME/.vimrc<CR>

" {{{2 Insert

inoremap jj <Esc>
inoremap <S-Up> <C-o><C-y>
inoremap <S-Down> <C-o><C-e>

" {{{2 Normal

noremap <Backspace> <C-y>
"noremap <CR> <C-e>

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

" noremap <Space> <C-f>
noremap gp `[v`]
noremap <C-d> "_dd
noremap Y y$
noremap q: :q
noremap ; :
noremap , ;
xno <bs> "_x


nnoremap ` <C-^>

" Write changes and delete buffer
" Similar to ZZ for windows
noremap <silent> XX :w<bar>bd<cr>

noremap <Leader>w :w<cr>
noremap <Leader>D :lcd %:p:h<cr>
noremap <Leader><CR> :noh<CR>

nnoremap <silent> <leader>/ :execute 'vimgrep /'.@/.'/g %'<CR>:copen<CR>
vnoremap <silent> in( :<C-U>normal! f(vi(<cr>
onoremap <silent> in( :<C-U>normal! f(vi(<cr>

noremap <C-e> 3<C-e>
noremap <C-y> 3<C-y>
noremap + <C-a>
noremap - <C-x>

" Window navigation
nmap <silent> <A-Up> :wincmd k<CR>
nmap <silent> <A-Down> :wincmd j<CR>
nmap <silent> <A-Left> :wincmd h<CR>
nmap <silent> <A-Right> :wincmd l<CR>

" Clear lines
noremap <Leader>clr :s/^.*$//<CR>:nohls<CR>

" Delete trailing whitespace
noremap <Leader>dtw :%s/\s\+$//g<CR>:nohls<CR>

" Delete blank lines
noremap <Leader>dbl :g/^$/d<CR>:nohls<CR>

" Enclose each selected line with markers
map <Leader>enc :<C-w>execute
            \ substitute(":'<,'>s/^.*/#&#/ \| :nohls", "#", input(">"), "g")<CR>

" Edit something in the current directory
noremap <Leader>ed :e <C-r>=expand("%:p:h")<CR>/<C-d>

" Toggle paste
noremap <silent> <Leader>p :set invpaste<CR>:set paste?<CR>

" Swap two words
noremap <silent> gw :s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<CR>``

" Underline the current line with '='
noremap <silent> <Leader>ul :t.\|s/./=/g\|set nohls<cr>

" Toggle invisibles
noremap <Leader>i :set list!<CR>

" Delete surrounding block
noremap dsb VaImk$%dkV`kj<`kdd

" Start substitution with word under cursor
noremap <leader>z :%s/\<<c-r><c-w>\>//g<Left><Left>
noremap <leader>Z :%S/<c-r><c-w>//g<Left><Left>
vmap <leader>z :<c-u>%s/\<<c-r>*\>/

" Fix commas without a following space
map <leader>x, :%s/,\zs\ze[^\s]/ /gc<cr>
" Fix ( foo ) to (foo)
map <leader>x( :%s/(\s\+/(/gc<cr>
map <leader>x) :%s/\s\+)/)/gc<cr>
" Fix ; with leading spaces
map <leader>x; :%s/\s\+;/;/gc<cr>
" Fix , with leading spaces
map <leader>x, :%s/\s\+,/,/gc<cr>
" Fix trailing spaces
map <leader>xs :%s/\s\+$//gc<cr>
" Remove carriage returns
map <leader>xr :%s/\r//gc<cr>

"-vmap P p :call setreg('"', getreg('0')) <CR>

" {{{2 Command

cnoremap <C-A> <Home>
cnoremap <ESC>b <S-Left>
cnoremap <ESC>f <S-Right>
cnoremap w!! %!sudo tee > /dev/null %

" {{{2 F-keys

nnoremap <silent> <F3> :!ctags -R .<CR><CR>
nnoremap <silent> <F4> :set hls!<bar>set hls?<CR>
nnoremap <silent> <F5> :set paste!<bar>set paste?<CR>
nnoremap <silent> <F6> :set wrap!<bar>set wrap?<CR>
nnoremap <silent> <F7> :/\<\(\w\+\)\s\+\1\><CR>
nnoremap <silent> <F8> :NERDTreeToggle<CR>
nnoremap <silent> <F9> :LessModeToggle<CR>

" {{{1 Plugins

" {{{2 fuf.vim

nmap <Leader>q :FufQuickfix<CR>
nmap <Leader>b :FufBuffer<CR>
nmap <Leader>f :FufFile<CR>
nmap <Leader>mc :FufMruCmd<CR>
nmap <Leader>mf :FufMruFile<CR>
nmap <Leader>l :FufLine<CR>
nmap <Leader>h :FufHelp<CR>
nmap <Leader>T :FufTag!<CR>

let g:fuf_modesDisable = []
let g:fuf_previewHeight = 0

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

" {{{2 space.vim

let g:space_disable_select_mode = 1

" {{{2 php-doc

inoremap <C-P> <ESC>:call PhpDocSingle()<CR>i
nnoremap <C-P> :call PhpDocSingle()<CR>
vnoremap <C-P> :call PhpDocRange()<CR>

" {{{2 scratch.vim

nnoremap <Leader>s :Scratch<CR>

" {{{2 easymotion.vim

let g:EasyMotion_leader_key = '<Leader>,'

" {{{2 misc.vim
map <silent> <Leader>o :call HandleURI()<CR>

" {{{1 Local settings

if filereadable(expand("~/.vimrc.local"))
    source ~/.vimrc.local
endif
