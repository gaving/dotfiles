set nocompatible

if !has("unix")
  set rtp&
  let &rtp = expand('~/.vim').','.&rtp.','.expand('~/.vim/after')
endif

runtime ftplugin/man.vim

call pathogen#infect()
call pathogen#helptags()

let mapleader = ","

if exists('+autochdir')
    set autochdir
else
    autocmd BufEnter * silent! lcd %:p:h:gs/ /\\ /
endif

autocmd FileType help wincmd L

if has('gui_running')
    set guioptions=cM
    set cursorline
endif

if exists('+shellslash')
    set shellslash
endif

if has('spell')
    set spell
    set spelllang=en_gb
    set spellfile=$HOME/.vim/spell/spellfile.add
    set spellsuggest=best,10
endif

set autowriteall " Watch this!
set clipboard+=unnamed
set foldclose=all
set foldmethod=marker
set gcr=n:blinkon0
set enc=utf-8
set lazyredraw
set list
let &sbr = nr2char(8618).' '
set hidden
set icon
set ignorecase
set nojoinspaces
set nowrap
set nrformats+=alpha
set number
set scrolljump=5
set shortmess+=I
set smartindent
set splitright
set splitbelow
set suffixes+=.class,.gz,.zip,.bz2,.tar,.pyc
set suffixes-=.h
set timeoutlen=700
set textwidth=79
set ttyfast
set viminfo='100,f1
set wildignore+=*.o,*.r,*.class,*.pyc,*.so,*.sl,*.tar,*.tgz,*.gz,*.dmg,*.zip,*.pdf,*CVS/*,*.svn/*,*.toc,*.aux,*.dvi,*.log
set wildmode=full

cabbrev ~? ~/

command! -bang -nargs=* -complete=file E :e <args>
command! -bang -nargs=* -complete=help He :he <args>
command! -bang -nargs=* -complete=option Set :set <args>

inoremap jj <Esc>
inoremap <S-Up> <C-o><C-y>
inoremap <S-Down> <C-o><C-e>

nnoremap ` <C-^>
noremap Q gqap
noremap q: :q
noremap ; :
noremap gp `[v`]

nnoremap <silent> H :bp<CR>
nnoremap <silent> L :bn<CR>
nnoremap <silent> R <Plug>(operator-replace)

nmap <silent> w <Plug>CamelCaseMotion_w
nmap <silent> b <Plug>CamelCaseMotion_b
nmap <silent> e <Plug>CamelCaseMotion_e

noremap <Space> <C-f>
noremap <C-d> "_dd
noremap <Backspace> <C-y>
xno <Backspace> "_x
nnoremap <silent> XX :w<bar>bd<cr>

noremap <silent> g<backspace> <c-o>
noremap <silent> g<return> <c-i>
noremap <silent> gb :bnext<cr>
noremap <silent> gB :bprev<cr>
noremap <silent> gd :bd<cr>
noremap <silent> gD :bd!<cr>
noremap <silent> <Leader>da :exec "1," . bufnr('$') . "bd"<cr>

nnoremap <Leader>du :diffupdate<CR>
nnoremap <Leader>do :diffof<CR>
nnoremap <Leader>ds :vertical diffsplit <C-r>=expand("%:p:h")<CR>/<C-d>
nnoremap <Leader>vs :vsplit <C-r>=expand("%:p:h")<CR>/<C-d>
nnoremap <Leader>dtw :%s/\s\+$//g<CR>:nohls<CR>
nnoremap <Leader>dbl :g/^$/d<CR>:nohls<CR>
nnoremap  <Leader>dsb VaImk$%dkV`kj<`kdd

noremap <C-e> 3<C-e>
noremap <C-y> 3<C-y>
noremap + <C-a>
noremap - <C-x>

nnoremap <silent> <S-Up> :wincmd k<CR>
nnoremap <silent> <S-Down> :wincmd j<CR>
nnoremap <silent> <S-Left> :wincmd h<CR>
nnoremap <silent> <S-Right> :wincmd l<CR>

nnoremap <Leader>/ :AckFromSearch<CR>
nnoremap <Leader>E :e <C-r>=expand("%:p:h")<CR>/<C-d>
nnoremap <Leader>Z :%S/<c-r><c-w>//g<Left><Left>
nnoremap <Leader>H :Hammer<CR>
nnoremap <Leader>a :Ack
nnoremap <Leader>d :lcd %:p:h<cr>
nnoremap <Leader>e :Errors<CR><C-w>j
nnoremap <Leader>o <C-w>o
nnoremap <Leader>q 1z=<CR>
nnoremap <Leader>v :e $MYVIMRC<CR>
nnoremap <Leader>V :e $HOME/.vimrc.local<CR>
nnoremap <Leader>w :w<cr>
nnoremap <Leader>z :%s/\<<c-r><c-w>\>//g<Left><Left>

nnoremap <Leader>b :CtrlPBuffer<CR>
nnoremap <Leader>f :CtrlPCurFile<CR>
nnoremap <Leader>m :CtrlPMRUFiles<CR>
nnoremap <Leader>M :CtrlPMixed<CR>
nnoremap <Leader>t :CtrlPTag<CR>

vnoremap <Leader>y "+y:let @+ = join(map(split(@+, '\n'), 'substitute(v:val, "^\\s\\+", "", "")'), " ")<CR>
vnoremap <Leader>Y "+y:let @+ = join(map(split(@+, '\n'), 'substitute(v:val, "^\\s\\+\\\|\\s\\+$", "", "g")'), ",")<CR>

let g:EasyMotion_leader_key = '<Space>'
let NERDMenuMode=0

if filereadable(expand("~/.vimrc.local"))
    source ~/.vimrc.local
endif
