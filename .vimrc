" .vimrc configuration

" {{{ GUI

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

    " {{{ Spelling

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

    " }}}

endif

" }}}

" {{{ Autocmds

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

if exists('+autochdir')
    set autochdir
else
    autocmd BufEnter * silent! lcd %:p:h:gs/ /\\ /
endif

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

"recalculate the long line warning when idle and after saving
autocmd cursorhold,bufwritepost * unlet! b:statusline_long_line_warning

"return a warning for "long lines" where "long" is either &textwidth or 80 (if
"no &textwidth is set)
"
"return '' if no long lines
"return '[#x,my,$z] if long lines are found, were x is the number of long
"lines, y is the median length of the long lines and z is the length of the
"longest line
function! StatuslineLongLineWarning()
    if !exists("b:statusline_long_line_warning")
        let long_line_lens = s:LongLines()

        if len(long_line_lens) > 0
            let b:statusline_long_line_warning = "[" .
                        \ '#' . len(long_line_lens) . "," .
                        \ 'm' . s:Median(long_line_lens) . "," .
                        \ '$' . max(long_line_lens) . "]"
        else
            let b:statusline_long_line_warning = ""
        endif
    endif
    return b:statusline_long_line_warning
endfunction

"return a list containing the lengths of the long lines in this buffer
function! s:LongLines()
    let threshold = (&tw ? &tw : 80)
    let spaces = repeat(" ", &ts)

    let long_line_lens = []

    let i = 1
    while i <= line("$")
        let len = strlen(substitute(getline(i), '\t', spaces, 'g'))
        if len > threshold
            call add(long_line_lens, len)
        endif
        let i += 1
    endwhile

    return long_line_lens
endfunction

"find the median of the given array of numbers
function! s:Median(nums)
    let nums = sort(a:nums)
    let l = len(nums)

    if l % 2 == 1
        let i = (l-1) / 2
        return nums[i]
    else
        return (nums[l/2] + nums[(l/2)-1]) / 2
    endif
endfunction

if has('title') && (has('gui_running') || &title)
    set titlestring=%f%h%m%r%w\ -\ %{v:progname}
endif

" }}}

" }}}

" {{{ Abbreviations

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

" }}}

" {{{ Mappings

" {{{ General

" Change <Leader>
let mapleader = ","

if has('win32')
    " nmap <Leader>s :source $HOME/_vimrc<CR>
    nmap <Leader>v :e $HOME/_vimrc<CR>
elseif has('unix')
    nmap <Leader>s :source $HOME/.vimrc<CR>
    nmap <Leader>v :e $HOME/.vimrc<CR>
endif

noremap <Backspace> <C-y>
noremap <Return> <C-e>
" noremap <Space> <C-f>
noremap <C-d> "_dd
noremap Y y$
noremap q: :q
noremap ; :
noremap , ;

inoremap jj <Esc>
imap <C-Space> <C-X><C-O>

map <Silent> <Leader><CR> :noh<CR>
imap <S-Return> <Esc>A;<Esc>o
map <S-Enter> O<Esc>

xno <bs> "_x

nnoremap <Leader>w :w<cr>
nnoremap <Leader>x :x<cr>
nnoremap <Leader>a <c-^>
nnoremap <Leader>D :lcd %:p:h<cr>

nnoremap <C-e> 3<C-e>
nnoremap <C-y> 3<C-y>

" Additional keys to increment/decrement
nnoremap + <C-a>
nnoremap - <C-x>

" Clear lines
noremap <Leader>clr :s/^.*$//<CR>:nohls<CR>

" Delete trailing whitespace
noremap <Leader>dtw :%s/\s\+$//g<CR>:nohls<CR>

" Delete blank lines
noremap <Leader>dbl :g/^$/d<CR>:nohls<CR>

" Enclose each selected line with markers
noremap <Leader>enc :<C-w>execute
            \ substitute(":'<,'>s/^.*/#&#/ \| :nohls", "#", input(">"), "g")<CR>

" Edit something in the current directory
noremap <Leader>ed :e <C-r>=expand("%:p:h")<CR>/<C-d>

" Select thing just pasted
noremap gp `[v`]

" Toggle paste
nmap <silent> <Leader>p :set invpaste<CR>:set paste?<CR>

" Swap two words
nmap <silent> gw :s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<CR>`'

" Underline the current line with '='
nmap <silent> <Leader>ul :t.\|s/./=/g\|set nohls<cr>

" Toggle invisibles
nmap <Leader>i :set list!<CR>

" Start substitution with word under cursor
nmap <leader>z :%s/\<<c-r><c-w>\>/
vmap <leader>z :<c-u>%s/\<<c-r>*\>/

" }}}

" {{{ Command window

cabbrev Set set

" oh god emacs styled bindings for command window
cnoremap <C-A> <Home>
cnoremap <ESC>b <S-Left>
cnoremap <ESC>f <S-Right>

cmap w!! %!sudo tee > /dev/null %

" }}}

" {{{ Buffer management

nmap <tab> <C-I><cr>
nmap <s-tab> <C-O><cr>

" Less mode
function! LessMode()
  if g:lessmode == 0
    let g:lessmode = 1
    let onoff = 'on'
    " Scroll half a page down
    noremap <script> d <C-D>
    " Scroll one line down
    noremap <script> j <C-E>
    " Scroll half a page up
    noremap <script> u <C-U>
    " Scroll one line up
    noremap <script> k <C-Y>
    " Scroll on space
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
nnoremap <F5> :call LessMode()<CR>
inoremap <F5> <Esc>:call LessMode()<CR>

" }}}

" {{{ Fkey bindings
map <silent> <F3> :!ctags -R .<CR><CR>
map <silent> <F4> :set hls!<bar>set hls?<CR>
map <silent> <F5> :set paste!<bar>set paste?<CR>
map <silent> <F6> :set wrap!<bar>set wrap?<CR>
map <silent> <F7> :/\<\(\w\+\)\s\+\1\><CR>
map <silent> <F8> :NERDTreeToggle<CR>
" }}}

" }}}

" {{{ Plugins

" {{{ fuf.vim

map <Leader>q :FufQuickfix<CR>
map <Leader>b :FufBuffer<CR>
map <Leader>f :FufFile<CR>
map <Leader>mc :FufMruCmd<CR>
map <Leader>mf :FufMruFile<CR>
map <Leader>l :FufLine<CR>
map <Leader>h :FufHelp<CR>
map <Leader>t :FufTag!<CR>
map <Leader>s :FufSnippet<CR>


let g:fuf_modesDisable = []
let g:fuf_previewHeight = 0

" }}}

" {{{ setcolors.vim

let g:mycolors = ['hornet', 'paintbox', 'ir_black', 'whitebox', 'darkburn']
let g:mycolors += ['fruidle', 'pyte', 'rdark', 'darkrobot', 'manuscript']
let g:mycolors += ['twilight', 'zenburn', 'wombat', 'darkspectrum']
let g:mycolors += [ 'jellybeans', 'bclear', 'molokai', 'zmrok', 'mustang']

colorscheme hornet

nnoremap <Leader>un :call NextColor(1)<CR>
nnoremap <Leader>up :call NextColor(-1)<CR>
nnoremap <Leader>ur :call NextColor(0)<CR>

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

" {{{ NERD_tree.vim

let NERDTreeIgnore=['CVS']

" }}}

" {{{ NERD_commenter.vim

let g:NERDSpaceDelims=1
let NERDMenuMode=0

" }}}

" {{{ surround.vim

autocmd FileType php let b:surround_45 = "<?php \r ?>"
autocmd FileType php let b:surround_99 = "try { \r } catch(Exception $e) { }"

" }}}

" {{{ toggle_words.vim

map <Leader><Space> :ToggleWord<CR>

" }}}

" {{{ changesqlcase.vim

vmap <leader>uc :call ChangeSqlCase()<cr>

" }}}

" {{{ syntastic.vim

let g:syntastic_enable_signs=1
let g:syntastic_auto_loc_list=1

" }}}

" {{{ Align

let g:DrChipTopLvlMenu=""

" }}}

" {{{ vcscommand.vim

let VCSCommandSplit='vertical'

" }}}

" {{{ space.vim

let g:space_disable_select_mode = 1

" }}}

" }}}

" {{{ Local settings

if filereadable(expand("~/.vimrc.local"))
    source ~/.vimrc.local
endif

" }}}

