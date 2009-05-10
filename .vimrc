" .vimrc configuration

" {{{ Autocmds

augroup vimrcEx

if has('win32')
    autocmd! BufWritePost _vimrc source %
    autocmd! BufWritePost _gvimrc source %
elseif has('unix')
    autocmd! BufWritePost .vimrc source %
    autocmd! BufWritePost .gvimrc source %
endif

autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

augroup END

" }}}

" {{{ Options

" {{{ Behaviour

filetype indent on
filetype plugin on

if &t_Co > 2 || has('gui_running')
    syntax on
endif

" {{{ Platform

if has('win32')
    helptags ~/vimfiles/doc/
    set backupdir=$HOME/_vim/tmp
    set directory=$HOME/_vim/tmp
elseif has('unix')
    helptags ~/.vim/doc/
    set backupdir=$HOME/.vim/tmp
    set directory=$HOME/.vim/tmp
endif

" }}}

set autochdir
set autoindent
set autowriteall " Watch this!
set backspace=start,indent,eol
set clipboard+=unnamed
set expandtab
set foldclose=all
set foldmethod=marker
set history=1000
set incsearch
set lazyredraw
set list
set listchars=tab:▷⋅,trail:⋅,nbsp:⋅
set noautoread
set nocompatible
set nocursorline
set noerrorbells
set hidden
set icon
set ignorecase
set nojoinspaces
set novisualbell
set nowrap
set number
set scrolljump=5
set scrolloff=3
set shiftwidth=4
set shortmess+=I
set showcmd
set smartcase
set smartindent
set smarttab
set softtabstop=4
set splitright
set splitbelow
set suffixes+=.h,.bak,~,.o,.info,.swp,.obj,.class,.gz,.zip,.bz2,.tar
set t_Co=256
set timeoutlen=700
set tags=tags;/
set textwidth=79
set ttyfast
set viminfo='100,f1
set wildignore+=*.o,*.r,*.so,*.sl,*.tar,*.tgz,*.pdf
set wildmode=full
set wildmenu

" Dictionary completion!
if has('unix')
    set dictionary=/usr/share/dict/words
    "set complete=.,w,b,u,t,i,k
endif

set complete=.,w,b,u,t,i

" }}}

" {{{ Statusline & Titlestring

"statusline setup
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

"display a warning if &paste is set
set statusline+=%#error#
set statusline+=%{&paste?'[paste]':''}
set statusline+=%*

set statusline+=%= "left/right separator
set statusline+=%{StatuslineCurrentHighlight()}\ \ "current highlight
set statusline+=%c, "cursor column
set statusline+=%l/%L "cursor line/total lines
set statusline+=\ %P "percent through file
set laststatus=2

"recalculate the trailing whitespace warning when idle, and after saving
autocmd cursorhold,bufwritepost * unlet! b:statusline_trailing_space_warning

"return '[\s]' if trailing white space is detected
"return '' otherwise
function! StatuslineTrailingSpaceWarning()
    if !exists("b:statusline_trailing_space_warning")
        if search('\s\+$', 'nw') != 0
            let b:statusline_trailing_space_warning = '[\s]'
        else
            let b:statusline_trailing_space_warning = ''
        endif
    endif
    return b:statusline_trailing_space_warning
endfunction

"return the syntax highlight group under the cursor ''
function! StatuslineCurrentHighlight()
    let name = synIDattr(synID(line('.'),col('.'),1),'name')
    if name == ''
        return ''
    else
        return '[' . name . ']'
    endif
endfunction

"recalculate the tab warning flag when idle and after writing
autocmd cursorhold,bufwritepost * unlet! b:statusline_tab_warning

"return '[&et]' if &et is set wrong
"return '[mixed-indenting]' if spaces and tabs are used to indent
"return an empty string if everything is fine
function! StatuslineTabWarning()
    if !exists("b:statusline_tab_warning")
        let tabs = search('^\t', 'nw') != 0
        let spaces = search('^ ', 'nw') != 0

        if tabs && spaces
            let b:statusline_tab_warning = '[mixed-indenting]'
        elseif (spaces && !&et) || (tabs && &et)
            let b:statusline_tab_warning = '[&et]'
        else
            let b:statusline_tab_warning = ''
        endif
    endif
    return b:statusline_tab_warning
endfunction

if has('title') && (has('gui_running') || &title)
    set titlestring=%f%h%m%r%w\ -\ %{v:progname}
endif

" }}}

" {{{ Spelling

if has('spell') && has('gui_running')
    set spell
    set spelllang=en_gb
    if has('win32')
        set spellfile=~/vimfiles/spell/spellfile.add
    elseif has('unix')
        set spellfile=~/.vim/spell/spellfile.add
    endif
    set spellsuggest=best,10
endif

" }}}

" }}}

" {{{ Mappings

" {{{ General

" Change <Leader>
let mapleader = ","

if has('win32')
    nmap <Leader>s :source $HOME/_vimrc<CR>
    nmap <Leader>v :e $HOME/_vimrc<CR>
elseif has('unix')
    nmap <Leader>s :source $HOME/.vimrc<CR>
    nmap <Leader>v :e $HOME/.vimrc<CR>
endif

noremap <Space> <C-f>
noremap <C-d> "_dd
noremap Y y$
nmap q: :q

inoremap jj <Esc>
imap <C-Space> <C-X><C-O>

map <S-Return> :normal A;<Esc>o
map <Silent> <Leader><CR> :noh<CR>
imap <S-Return> <Esc>A;<Esc>o

nnoremap <C-e> 3<C-e>
nnoremap <C-y> 3<C-y>

" }}}

" {{{ Quickfix window

map <Leader>o :copen<CR>
map <Leader>n :cnext<CR>
map <Leader>p :cprev<CR>

" }}}

" {{{ Command window

cabbrev Set set
cabbrev h tab h
cabbrev he tab he
cabbrev help tab help

" oh god emacs styled bindings for command window
cnoremap <C-A> <Home>
cnoremap <ESC>b <S-Left>
cnoremap <ESC>f <S-Right>

cmap w!! %!sudo tee > /dev/null %

" }}}

" {{{ Buffer management
nmap <tab> <C-I><cr>
nmap <s-tab> <C-O><cr>
" }}}

" {{{ Tab management

nmap <C-tab> :tabnext<CR>
map <C-tab> :tabnext<CR>
imap <C-tab> <ESC>:tabnext<CR>i

nmap <C-Enter> :tabnew 
nmap <C-Delete> :tabclose<CR>

map <S-Left> :tabprev<CR>
map <S-Right> :tabnext<CR>
map <A-Left> :tabprev<CR>
map <A-Right> :tabnext<CR>

" }}}

" {{{ Colourschemes

"colorscheme darktango
"colorscheme paintbox
"colorscheme ir_dark
"colorscheme desert
"colorscheme fruit
"colorscheme moria
"colorscheme rootwater
"colorscheme fruidle
"colorscheme pyte
"colorscheme rdark
"colorscheme tango2
"colorscheme twilight
"colorscheme zenburn
"colorscheme wombat
"colorscheme darkspectrum
colorscheme jellybeans

" }}}

" }}}

" {{{ Plugins

" {{{ fuzzerfinder.vim

map <Leader>b :FuzzyFinderBuffer<CR>
map <Leader>f :FuzzyFinderFile<CR>
map <Leader>mc :FuzzyFinderMruCmd<CR>
map <Leader>mf :FuzzyFinderMruFile<CR>
map <Leader>t :FuzzyFinderTag!<CR>

" inoremap <Leader>s <Esc>:FuzzyFinderSnippet<CR>

" }}}

" {{{ setcolors.vim

nnoremap <Leader>sn :call NextColor(1)<CR>
nnoremap <Leader>sp :call NextColor(-1)<CR>
nnoremap <Leader>sr :call NextColor(0)<CR>

" }}}

" {{{ camelcasemotion.vim

" This stuff could be troublesome
nmap <silent> w <Plug>CamelCaseMotion_w
nmap <silent> b <Plug>CamelCaseMotion_b
nmap <silent> e <Plug>CamelCaseMotion_e

omap <silent> iw <Plug>CamelCaseMotion_iw
vmap <silent> iw <Plug>CamelCaseMotion_iw
omap <silent> ib <Plug>CamelCaseMotion_ib
vmap <silent> ib <Plug>CamelCaseMotion_ib
omap <silent> ie <Plug>CamelCaseMotion_ie
vmap <silent> ie <Plug>CamelCaseMotion_ie

" }}}

" {{{ NERD_commenter.vim

let g:NERDSpaceDelims=1

" }}}

" {{{ toggle_words.vim

map <Leader><Space> :ToggleWord<CR>

" }}}

" {{{ changesqlcase.vim

vmap <leader>uc :call ChangeSqlCase()<cr>

" }}}

" }}}
