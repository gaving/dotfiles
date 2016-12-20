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
Plug 'tpope/vim-markdown', { 'for': 'markdown' }
Plug 'tpope/vim-projectionist'
Plug 'tpope/vim-obsession' | Plug 'dhruvasagar/vim-prosession'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-rsi'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'

Plug 'AndrewRadev/splitjoin.vim'
Plug 'ap/vim-css-color'
Plug 'bkad/camelcasemotion'
Plug 'bling/vim-airline'
Plug 'christoomey/vim-tmux-navigator'
Plug 'elzr/vim-json', { 'for': 'json' }
Plug 'junegunn/goyo.vim', { 'on': 'Goyo' }
Plug 'junegunn/limelight.vim', { 'on': 'Limelight' }
Plug 'junegunn/vim-easy-align'
Plug 'junegunn/vim-oblique'
Plug 'junegunn/vim-peekaboo'
Plug 'junegunn/vim-pseudocl'
Plug 'justinmk/vim-dirvish'
Plug 'justinmk/vim-gtfo'
Plug 'kana/vim-textobj-indent'
Plug 'kana/vim-textobj-line'
Plug 'kana/vim-textobj-user'
Plug 'mhinz/vim-sayonara', { 'on': 'Sayonara' }
Plug 'mhinz/vim-startify'
Plug 'moll/vim-node', { 'for': 'javascript' }
Plug 'neomake/neomake'
Plug 'othree/es.next.syntax.vim', { 'for': 'javascript' }
Plug 'othree/html5.vim', { 'for': 'html' }
Plug 'othree/yajs.vim', { 'for': 'javascript' }
Plug 'pangloss/vim-javascript', { 'for': 'javascript' }
Plug 'shougo/neomru.vim'
Plug 'shougo/unite.vim'
Plug 'shougo/vimproc.vim'
Plug 'tommcdo/vim-exchange'
Plug 'wellle/targets.vim'

Plug 'romainl/apprentice'
Plug 'junegunn/seoul256.vim'
Plug 'morhetz/gruvbox'
Plug 'mhartington/oceanic-next'

call plug#end()

autocmd FileType help wincmd L

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

if (has("termguicolors"))
  set termguicolors
endif
  
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
nnoremap gt :bn<CR>
nnoremap gT :bp<CR>

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
autocmd! BufWritePost * Neomake

nnoremap <C-d> :Sayonara<CR>

let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1

colorscheme OceanicNext
set background=dark
let g:airline_theme='oceanicnext'

if filereadable(expand("~/.vimrc.local"))
    source ~/.vimrc.local
endif
