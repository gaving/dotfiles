set nocompatible

if !has("unix")
  set rtp&
  let &rtp = expand('~/.vim').','.&rtp.','.expand('~/.vim/after')
endif

let g:mapleader = ","
map <Space> <Leader>

call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-abolish'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-markdown'
Plug 'tpope/vim-projectionist'
Plug 'tpope/vim-obsession' | Plug 'dhruvasagar/vim-prosession'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-rsi'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-vinegar'

Plug 'kana/vim-textobj-indent'
Plug 'kana/vim-textobj-line'
Plug 'kana/vim-textobj-user'
Plug 'wellle/targets.vim'

Plug 'AndrewRadev/splitjoin.vim'
Plug 'Chiel92/vim-autoformat'
Plug 'Shougo/unite-outline'
Plug 'ap/vim-css-color'
Plug 'bkad/camelcasemotion'
Plug 'bling/vim-airline'
Plug 'christoomey/vim-tmux-navigator'
Plug 'dyng/ctrlsf.vim'
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
Plug 'junegunn/seoul256.vim'
Plug 'junegunn/vim-easy-align'
Plug 'junegunn/vim-oblique'
Plug 'junegunn/vim-peekaboo'
Plug 'junegunn/vim-pseudocl'
Plug 'justinmk/vim-gtfo'
Plug 'mhinz/vim-sayonara', { 'on': 'Sayonara' }
Plug 'mhinz/vim-startify'
Plug 'romainl/apprentice'
Plug 'scrooloose/syntastic'
Plug 'sheerun/vim-polyglot'
Plug 'shougo/neomru.vim'
Plug 'shougo/unite.vim'
Plug 'shougo/vimproc.vim'
Plug 'terryma/vim-expand-region'
Plug 'tommcdo/vim-exchange'

call plug#end()

autocmd FileType help wincmd L

if has('gui_running')
    set guioptions=cM
    set cursorline
endif

let &sbr = nr2char(8618).' '
set autowriteall
set backupdir=~/.vim/tmp
set clipboard+=unnamed
set directory=~/.vim/tmp
set foldmethod=marker
set gcr=n:blinkon0
set hidden
set ignorecase
set lazyredraw
set list
set nojoinspaces
set nowrap
set nrformats+=alpha
set number
set scrolljump=5
set smartindent
set splitbelow
set splitright
set textwidth=79
set ttyfast
set undodir=~/.vim/tmp
set undofile
set undolevels=5000
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
nnoremap Y y$

noremap <Backspace> <C-y>
xnoremap <Backspace> "_x

nnoremap <Leader>s :Prosession 
nnoremap <Leader>d :vertical diffsplit <C-r>=expand("%:p:h")<CR>/<C-d>
nnoremap <Leader>e :Errors<CR><C-w>j
nnoremap <Leader>v :e $MYVIMRC<CR>
nnoremap <Leader>V :e $HOME/.vimrc.local<CR>
nnoremap <Leader>w :w<cr>

nnoremap <leader>p :<C-u>UniteWithProjectDir -buffer-name=files -no-split file_rec/async:!<CR>
nnoremap <leader>f :<C-u>Unite -buffer-name=files file_rec<CR>
nnoremap <leader>m :<C-u>Unite -buffer-name=files file_mru<CR>
nnoremap <leader>b :<C-u>Unite -buffer-name=buffer buffer<CR>
nnoremap <leader>/ :<C-u>Unite -buffer-name=buffer line<CR>
nnoremap <leader>y :<C-u>Unite history/yank<CR>
nnoremap <leader>o :<C-u>Unite outline<CR>

call unite#custom#profile('default', 'context', {
\   'start_insert': 1,
\   'winheight': 10,
\   'sync': 1,
\   'direction': 'dynamicbottom',
\   'prompt_direction': 'botleft',
\   'prompt' : '➤ '
\ })

call unite#custom_source('file_rec,file_rec/async,file_mru,file,buffer,grep',
      \ 'ignore_pattern', join([
      \ '\.\(jpe?g\|gif\|png\|svg\)$',
      \ ], '\|'))

let g:unite_source_history_yank_enable = 1
let g:unite_source_rec_async_command = ['ag', '--follow', '--nocolor', '--nogroup', '--hidden', '-g', '']

autocmd FileType unite call s:unite_settings()
function! s:unite_settings()
  nmap <buffer> <ESC> <Plug>(unite_exit)
endfunction

vmap <Enter> <Plug>(EasyAlign)
nmap <Leader>a <Plug>(EasyAlign)
nmap <Leader>g :Goyo<CR>
nmap <Leader>l :Limelight!!<CR>
xmap <Leader>l <Plug>(Limelight)

autocmd! User GoyoEnter Limelight
autocmd! User GoyoLeave Limelight!

nnoremap <C-d> :Sayonara<CR>

let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1

if filereadable(expand("~/.vimrc.local"))
    source ~/.vimrc.local
endif
