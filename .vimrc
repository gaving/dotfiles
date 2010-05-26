" .vimrc configuration

let $VIMHOME = split(&rtp, ',')[0]
silent! call pathogen#runtime_prepend_subdirectories($VIMHOME.'/bundles')

" {{{1 GUI

if has('gui_running')

    " Window size
    set lines=70
    set columns=100
    set guioptions=cM
    set guicursor=a:blinkon0

    " Use cursor row highlighting
    if v:version >= 700
        set cursorline
    end

    if has("gui_win32")
        set guifont=Consolas:h10:cDEFAULT
    elseif has("gui_macvim")
        set guifont=Monaco:h12.00
    endif

    if has('spell')
        set spell
        set spelllang=en_gb
        if has('win32')
            set spellfile=~/vimfiles/spell/spellfile.add
        elseif has('unix')
            set spellfile=~/.vim/spell/spellfile.add
        endif
        set spellsuggest=best,10
    endif

endif

" {{{1 Autocmds

augroup vimrcEx

if (has("win32") || has("win64"))
    autocmd! BufWritePost _vimrc source %
elseif has('unix')
    autocmd! BufWritePost .vimrc source %
endif

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

if has('win32')
    set backupdir=$HOME/_vim/tmp
    set directory=$HOME/_vim/tmp
elseif has('unix')
    set backupdir=$HOME/.vim/tmp
    set directory=$HOME/.vim/tmp
endif

silent! call pathogen#helptags()

if exists('+autochdir')
    set autochdir
else
    autocmd BufEnter * silent! lcd %:p:h:gs/ /\\ /
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
set history=1000
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
set smartcase
set smartindent
set smarttab
set softtabstop=4
set laststatus=2

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
set wildignore+=*.o,*.r,*.class,*.pyc,*.so,*.sl,*.tar,*.tgz,*.gz,*.dmg,*.zip,*.pdf,CVS/,.svn/,.git/
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

set statusline=%f "tail of the filename

"display a warning if fileformat isnt unix
set statusline+=%#warningmsg#
set statusline+=%{&ff!='unix'?'['.&ff.']':''}
set statusline+=%*

"display a warning if file encoding isnt utf-8
set statusline+=%#warningmsg#
set statusline+=%{(&fenc!='utf-8'&&&fenc!='')?'['.&fenc.']':''}
set statusline+=%*
set statusline+=%h "help file flag
set statusline+=%y "filetype
set statusline+=%r "read only flag
set statusline+=%m "modified flag

"display a warning if &et is wrong, or we have mixed-indenting
set statusline+=%#error#
set statusline+=%{StatuslineTabWarning()}
set statusline+=%*
set statusline+=%{StatuslineTrailingSpaceWarning()}
set statusline+=%{StatuslineLongLineWarning()}
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

"display a warning if &paste is set
set statusline+=%#error#
set statusline+=%{&paste?'[paste]':''}
set statusline+=%*
set statusline+=%= "left/right separator
set statusline+=%{StatuslineCurrentHighlight()}\ \ "current highlight
set statusline+=%c, "cursor column
set statusline+=%l/%L "cursor line/total lines
set statusline+=\ %P "percent through file

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
ca eariler earlier
ca !+ !=
ca ~? ~/

" {{{1 Mappings

" {{{2 General

let mapleader = ","
let maplocalleader = ","

if has('win32')
    nmap <Leader>v :e $HOME/_vimrc<CR>
elseif has('unix')
    nmap <Leader>s :source $HOME/.vimrc<CR>
    nmap <Leader>v :e $HOME/.vimrc<CR>
endif

" {{{2 Insert

inoremap jj <Esc>
inoremap <C-Space> <C-X><C-O>
inoremap <S-Return> <Esc>A;<Esc>o
inoremap <S-Up> <C-o><C-y>
inoremap <S-Down> <C-o><C-e>

" {{{2 Normal

noremap <Backspace> <C-y>
noremap <Return> <C-e>
noremap <TAB> <C-I><cr>
noremap <S-TAB> <C-O><cr>

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

" Write changes and delete buffer
" Similar to ZZ for windows
noremap <silent> XX :w<bar>bd<cr>

noremap <Leader>w :w<cr>
noremap <Leader>D :lcd %:p:h<cr>
noremap <Leader><CR> :noh<CR>

noremap <C-e> 3<C-e>
noremap <C-y> 3<C-y>
noremap + <C-a>
noremap - <C-x>

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

" Start substitution with word under cursor
noremap <leader>z :%s/\<<c-r><c-w>\>//g<Left><Left>
noremap <leader>Z :%S/<c-r><c-w>//g<Left><Left>
vmap <leader>z :<c-u>%s/\<<c-r>*\>/

"-vmap P p :call setreg('"', getreg('0')) <CR>

" Less mode
function! LessMode()
  if g:lessmode == 0
    let g:lessmode = 1
    let onoff = 'on'
    noremap <script> d <C-D>
    noremap <script> j <C-E>
    noremap <script> u <C-U>
    noremap <script> k <C-Y>
    noremap <Space> <C-f>
  else
    let g:lessmode = 0
    let onoff = 'off'
    unmap d
    unmap j
    unmap u
    unmap k
  endif
  echohl Label | echo "Less mode" onoff | echohl None
endfunction
let g:lessmode = 0

" {{{2 Command

cabbrev Set set
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
nnoremap <silent> <F9> :call LessMode()<CR>

" {{{1 Plugins

" {{{2 fuf.vim

nnoremap <Leader>q :FufQuickfix<CR>
nnoremap <Leader>b :FufBuffer<CR>
nnoremap <Leader>f :FufFile<CR>
nnoremap <Leader>mc :FufMruCmd<CR>
nnoremap <Leader>mf :FufMruFile<CR>
nnoremap <Leader>l :FufLine<CR>
nnoremap <Leader>h :FufHelp<CR>
nnoremap <Leader>T :FufTag!<CR>
nnoremap <Leader>s :FufSnippet<CR>

let g:fuf_modesDisable = []
let g:fuf_previewHeight = 0

" {{{2 setcolors.vim

let g:mycolors  = ['hornet', 'paintbox', 'ir_black', 'whitebox', 'darkburn']
let g:mycolors += ['fruidle', 'pyte', 'rdark', 'darkrobot', 'manuscript']
let g:mycolors += ['twilight', 'zenburn', 'wombat', 'darkspectrum']
let g:mycolors += ['jellybeans', 'bclear', 'molokai', 'zmrok', 'mustang']
let g:mycolors += ['vilight']

colorscheme hornet

nnoremap <Leader>un :call NextColor(1)<CR>
nnoremap <Leader>up :call NextColor(-1)<CR>
nnoremap <Leader>ur :call NextColor(0)<CR>

" {{{2 camelcasemotion.vim

" Watch this! Could be troublesome.
nmap <silent> w <Plug>CamelCaseMotion_w
nmap <silent> b <Plug>CamelCaseMotion_b
nmap <silent> e <Plug>CamelCaseMotion_e
omap <silent> iw <Plug>CamelCaseMotion_iw
vmap <silent> iw <Plug>CamelCaseMotion_iw
omap <silent> ib <Plug>CamelCaseMotion_ib
vmap <silent> ib <Plug>CamelCaseMotion_ib
omap <silent> ie <Plug>CamelCaseMotion_ie
vmap <silent> ie <Plug>CamelCaseMotion_ie

" {{{2 NERD_tree.vim

let NERDTreeIgnore=['CVS']

" {{{2 NERD_commenter.vim

let g:NERDSpaceDelims=1
let NERDMenuMode=0

" {{{2 surround.vim

autocmd FileType php let b:surround_{char2nr("-")} = "<?php \r ?>"
autocmd FileType php let b:surround_{char2nr("p")} = "print_r(\r);"
autocmd FileType php let b:surround_{char2nr("l")} = "error_log(var_export(\r, true));"
autocmd FileType php let b:surround_{char2nr("e")} = "try { \r } catch(Exception $e) { }"

" {{{2 changesqlcase.vim

vmap <leader>uc :call ChangeSqlCase()<cr>

" {{{2 syntastic.vim

let g:syntastic_enable_signs=1
let g:syntastic_auto_loc_list=1

" {{{2 Align

let g:DrChipTopLvlMenu=""

" {{{2 vcscommand.vim

let VCSCommandSplit='vertical'

" {{{2 space.vim

let g:space_disable_select_mode = 1

" {{{2 sparkup.vim

let g:sparkup=$VIMHOME.'/bundles/sparkup/sparkup.py'

" {{{2 command-t

let g:CommandTMatchWindowAtTop = 1

" {{{2 delimitMate

let g:loaded_delimitMate = 1

" {{{2 php-doc

inoremap <C-P> <ESC>:call PhpDocSingle()<CR>i
nnoremap <C-P> :call PhpDocSingle()<CR>
vnoremap <C-P> :call PhpDocRange()<CR>

" {{{1 Local settings

if filereadable(expand("~/.vimrc.local"))
    source ~/.vimrc.local
endif
