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

" noremap <Space> <C-f>
noremap <C-d> "_dd
noremap Y y$
nmap q: :q

inoremap jj <Esc>
imap <C-Space> <C-X><C-O>

" map <S-Return> :normal A;<Esc>o
map <Silent> <Leader><CR> :noh<CR>
" imap <S-Return> <Esc>A;<Esc>o
map <S-Enter> O<Esc>
" map <CR> o<Esc>

nnoremap <C-e> 3<C-e>
nnoremap <C-y> 3<C-y>

" }}}

" {{{ Error windows

" Quickfix window

map <Leader>qo :copen<CR>
map <Leader>qn :cnext<CR>
map <Leader>qp :cprev<CR>

" Location window

map <Leader>lo :lopen<CR>
map <Leader>ln :lnext<CR>
map <Leader>lp :lprev<CR>

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
map <silent> <S-F3> :!ctags -R .<CR><CR>
map <silent> <S-F4> :set hls!<bar>set hls?<CR>
map <silent> <S-F5> :set paste!<bar>set paste?<CR>
map <silent> <S-F6> :set wrap!<bar>set wrap?<CR>
map <silent> <S-F7> :/\<\(\w\+\)\s\+\1\><CR>
" }}}

" {{{ Tab management
"
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
"colorscheme jellybeans
"colorscheme bclear
"colorscheme neon
"colorscheme molokai
"colorscheme zmork
colorscheme mustang

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

" {{{ syntastic.vim

let g:syntastic_enable_signs=1
let g:syntastic_auto_loc_list=1

" }}}
"

" }}}
