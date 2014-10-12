set nocompatible

if !has("unix")
  set rtp&
  let &rtp = expand('~/.vim').','.&rtp.','.expand('~/.vim/after')
endif

let mapleader = ","

call plug#begin('~/.vim/plugged')

Plug 'chrisbra/csv.vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'ervandew/supertab'
Plug 'gaving/vim-schemery'
Plug 'gaving/vim-textobj-argument'
Plug 'honza/vim-snippets'
Plug 'itchyny/lightline.vim'
Plug 'junegunn/vim-oblique'
Plug 'junegunn/vim-pseudocl'
Plug 'junegunn/vim-easy-align'
Plug 'kana/vim-textobj-indent'
Plug 'kana/vim-textobj-user'
Plug 'kchmck/vim-coffee-script'
Plug 'lokaltog/vim-easymotion'
Plug 'molok/vim-vombato-colorscheme'
Plug 'mxw/vim-jsx'
Plug 'pangloss/vim-javascript'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/syntastic'
Plug 'shougo/neomru.vim'
Plug 'shougo/unite.vim'
Plug 'sickill/vim-pasta'
Plug 'sirver/ultisnips'
Plug 'stanangeloff/php.vim'
Plug 'stormherz/tablify'
Plug 'tommcdo/vim-exchange'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-markdown'
Plug 'tpope/vim-ragtag'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-rsi'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'vim-scripts/camelcasemotion'
Plug 'vim-scripts/unconditionalpaste'
Plug 'zeis/vim-kolor'

Plug 'romainl/apprentice'
Plug 'junegunn/seoul256.vim'
Plug 'sickill/vim-monokai'
Plug 'stayradiated/vim-termorrow'
Plug 'w0ng/vim-hybrid'
Plug 'whatyouhide/vim-gotham'

call plug#end()

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

nnoremap <Leader>e :e <C-r>=expand("%:p:h")<CR>/<C-d>
nnoremap <Leader>E :Errors<CR><C-w>j
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

nnoremap <leader>t :<C-u>Unite -no-split -buffer-name=files   -start-insert file_rec/async<CR>
nnoremap <leader>f :<C-u>Unite -no-split -buffer-name=files   -start-insert file<CR>
nnoremap <leader>m :<C-u>Unite -no-split -buffer-name=files   -start-insert file_mru<CR>
nnoremap <leader>b :<C-u>Unite -no-split -buffer-name=buffer  -start-insert buffer<CR>
nnoremap <leader>/ :<C-u>Unite -no-split -buffer-name=buffer  -start-insert line<CR>
nnoremap <leader>a :<C-u>Unite -no-split -buffer-name=buffer  -start-insert grep:.<CR>

let NERDMenuMode=0

let g:UltiSnipsNoPythonWarning = 1
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

let g:unite_enable_start_insert = 1
let g:unite_split_rule = "botright"
let g:unite_force_overwrite_statusline = 0
let g:unite_winheight = 10

call unite#custom_source('file_rec,file_rec/async,file_mru,file,buffer,grep',
      \ 'ignore_pattern', join([
      \ '\.git/',
      \ ], '\|'))

call unite#filters#matcher_default#use(['matcher_fuzzy'])
call unite#filters#sorter_default#use(['sorter_rank'])

autocmd FileType unite call s:unite_settings()

function! s:unite_settings()
  let b:SuperTabDisabled=1
  nmap <buffer> <ESC> <Plug>(unite_exit)
endfunction

vmap <Enter> <Plug>(EasyAlign)
nmap <Leader>a <Plug>(EasyAlign)

if filereadable(expand("~/.vimrc.local"))
    source ~/.vimrc.local
endif
