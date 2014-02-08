set nocompatible

if !has("unix")
  set rtp&
  let &rtp = expand('~/.vim').','.&rtp.','.expand('~/.vim/after')
endif

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
nnoremap Q gqap
nnoremap q: :q
nnoremap gp `[v`]
nnoremap XX :w<bar>bd<cr>
nnoremap XQ :bd!<cr>

noremap <Backspace> <C-y>
xnoremap <Backspace> "_x

nnoremap g<backspace> <c-o>
nnoremap g<return> <c-i>
nnoremap gb :bnext<cr>
nnoremap gB :bprev<cr>
nnoremap gd :bd<cr>
nnoremap gD :bd!<cr>

nnoremap <Leader>da :exec "1," . bufnr('$') . "bd"<cr>
nnoremap <Leader>du :diffupdate<CR>
nnoremap <Leader>ds :vertical diffsplit <C-r>=expand("%:p:h")<CR>/<C-d>
nnoremap <Leader>vs :vsplit <C-r>=expand("%:p:h")<CR>/<C-d>

nnoremap <Leader>dtw :%s/\s\+$//g<CR>:nohls<CR>
nnoremap <Leader>dbl :g/^$/d<CR>:nohls<CR>

nnoremap <Leader>e :Errors<CR><C-w>j
nnoremap <Leader>E :e <C-r>=expand("%:p:h")<CR>/<C-d>
nnoremap <Leader>r :%s/\<<c-r><c-w>\>//g<Left><Left>
nnoremap <Leader>R :%S/<c-r><c-w>//g<Left><Left>

nnoremap <Leader>d :lcd %:p:h<cr>
nnoremap <Leader>q 1z=<CR>
nnoremap <Leader>v :e $MYVIMRC<CR>
nnoremap <Leader>V :e $HOME/.vimrc.local<CR>
nnoremap <Leader>w :w<cr>
nnoremap Y y$

vnoremap <Leader>y "+y:let @+ = join(map(split(@+, '\n'), 'substitute(v:val, "^\\s\\+", "", "")'), " ")<CR>
vnoremap <Leader>Y "+y:let @+ = join(map(split(@+, '\n'), 'substitute(v:val, "^\\s\\+\\\|\\s\\+$", "", "g")'), ",")<CR>

nmap <silent> w <Plug>CamelCaseMotion_w
nmap <silent> b <Plug>CamelCaseMotion_b
nmap <silent> e <Plug>CamelCaseMotion_e

nnoremap <Leader>b :CtrlPBuffer<CR>
nnoremap <Leader>f :CtrlPCurFile<CR>
nnoremap <Leader>m :CtrlPMRUFiles<CR>
nnoremap <Leader>M :CtrlPMixed<CR>
nnoremap <Leader>t :CtrlPBufTagAll<CR>
nnoremap <Leader>T :CtrlPTag<CR>
nnoremap <Leader>p :CtrlPRoot<CR>

let g:ctrlp_root_markers = ['.ctrlp']
let g:ctrlp_working_path_mode = 'ra'

let g:UltiSnipsNoPythonWarning = 1
let NERDMenuMode=0

if filereadable(expand("~/.vimrc.local"))
    source ~/.vimrc.local
endif
