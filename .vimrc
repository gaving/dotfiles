set nocompatible

if !has("unix")
  set rtp&
  let &rtp = expand('c:/gavin/dotfiles/.vim').','.&rtp
endif

let g:mapleader = ","

call plug#begin('c:/gavin/dotfiles/.vim/plugged')

Plug 'tpope/vim-abolish'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-projectionist'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-rsi'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-vinegar'
" Plug 'tpope/vim-obsession'
" Plug 'dhruvasagar/vim-prosession'
" Plug 'bling/vim-bufferline'
Plug 'mhinz/vim-startify'
Plug 'Chiel92/vim-autoformat'

Plug 'kana/vim-textobj-indent'
Plug 'kana/vim-textobj-line'
Plug 'kana/vim-textobj-user'
Plug 'wellle/targets.vim'
Plug 'junegunn/vim-after-object'
Plug 'rking/ag.vim'

Plug 'bkad/camelcasemotion'
Plug 'christoomey/vim-tmux-navigator'
" Plug 'itchyny/lightline.vim'
Plug 'bling/vim-airline'
Plug 'junegunn/vim-easy-align'
Plug 'junegunn/vim-oblique'
Plug 'junegunn/vim-peekaboo'
Plug 'junegunn/vim-pseudocl'
Plug 'justinmk/vim-gtfo'
Plug 'mhinz/vim-sayonara', { 'on': 'Sayonara' }
Plug 'scrooloose/syntastic'
Plug 'shougo/neomru.vim'
Plug 'shougo/unite.vim'
Plug 'shougo/unite-session'
Plug 'shougo/vimproc.vim'
Plug 'szw/vim-g'
Plug 'szw/vim-tags'
Plug 'tommcdo/vim-exchange'
Plug 'tsukkee/unite-tag'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'ap/vim-css-color'
" Plug 'airblade/vim-gitgutter'
Plug 'shumphrey/fugitive-gitlab.vim'
Plug 'ajh17/VimCompletesMe'

Plug 'ap/vim-css-color'
Plug 'stanangeloff/php.vim'
Plug 'kchmck/vim-coffee-script'
Plug 'pangloss/vim-javascript'
Plug 'maksimr/vim-jsbeautify'
Plug 'dyng/ctrlsf.vim'

Plug 'junegunn/seoul256.vim'
Plug 'romainl/apprentice'
Plug 'trusktr/seti.vim'

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

set autowriteall
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

nnoremap <Leader>d :bd<cr>
nnoremap <Leader>D :bd!<cr>
nnoremap <Leader>da :exec "1," . bufnr('$') . "bd"<cr>
nnoremap <Leader>du :diffupdate<CR>
nnoremap <Leader>ds :vertical diffsplit <C-r>=expand("%:p:h")<CR>/<C-d>
nnoremap <Leader>vs :vsplit <C-r>=expand("%:p:h")<CR>/<C-d>

nnoremap <Leader>dtw :%s/\s\+$//g<CR>:nohls<CR>
nnoremap <Leader>dbl :g/^$/d<CR>:nohls<CR>

nnoremap <Leader>e :Errors<CR><C-w>j
nnoremap <Leader>r :%s/\<<c-r><c-w>\>//g<Left><Left>
nnoremap <Leader>R :%S/<c-r><c-w>//g<Left><Left>

nnoremap <Leader>q 1z=<CR>
nnoremap <Leader>v :e $MYVIMRC<CR>
nnoremap <Leader>V :e $HOME/.vimrc.local<CR>
nnoremap <Leader>w :w<cr>
nnoremap Y y$

nmap <silent> w <Plug>CamelCaseMotion_w
nmap <silent> b <Plug>CamelCaseMotion_b
nmap <silent> e <Plug>CamelCaseMotion_e

nnoremap <leader>p :<C-u>UniteWithProjectDir -buffer-name=files -no-split file_rec/async:!<CR>
nnoremap <leader>t :<C-u>Unite tag -buffer-name=tags<CR>
nnoremap <leader>f :<C-u>Unite -buffer-name=files file_rec<CR>
nnoremap <leader>m :<C-u>Unite -buffer-name=files file_mru<CR>
nnoremap <leader>b :<C-u>Unite -buffer-name=buffer buffer<CR>
nnoremap <leader>B :<C-u>Unite -buffer-name=buffer -quick-match buffer<CR>
nnoremap <leader>/ :<C-u>Unite -buffer-name=buffer line<CR>
" nnoremap <leader>g :<C-u>Unite -buffer-name=buffer grep:.<CR>
nnoremap <leader>y :<C-u>Unite history/yank<CR>

let g:unite_source_history_yank_enable = 1
let g:unite_enable_start_insert = 1
let g:unite_split_rule = "botright"
let g:unite_force_overwrite_statusline = 0
let g:unite_winheight = 20

call unite#custom_source('file_rec,file_rec/async,file_mru,file,buffer,grep',
      \ 'ignore_pattern', join([
      \ '\.\(git\|svn\|vagrant\)\/',
      \ 'tmp\/',
      \ 'app\/storage\/',
      \ 'bower_components\/',
      \ 'fonts\/',
      \ 'sass-cache\/',
      \ 'node_modules\/',
      \ '\.\(jpe?g\|gif\|png\)$',
      \ ], '\|'))

autocmd FileType unite call s:unite_settings()
autocmd VimEnter * call after_object#enable('=', ':', '-', '#', ' ')

function! s:unite_settings()
  nmap <buffer> <ESC> <Plug>(unite_exit)
endfunction

vmap <Enter> <Plug>(EasyAlign)
nmap <Leader>a <Plug>(EasyAlign)

nnoremap <C-d> :Sayonara<CR>
nnoremap <leader>G :Google
vnoremap <leader>G :Google<CR>

if filereadable(expand("~/.vimrc.local"))
    source ~/.vimrc.local
endif
