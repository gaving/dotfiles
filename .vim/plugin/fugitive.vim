" fugitive.vim - Fugitive
" Maintainer:   Tim Pope <vimNOSPAM@tpope.info>

if (exists("g:loaded_fugitive") && g:loaded_fugitive) || &cp
  finish
endif
let g:loaded_fugitive = 1

if !exists('g:fugitive_git_executable')
  let g:fugitive_git_executable = 'git'
endif

" Utility {{{1

function! s:function(name) abort
  return function(substitute(a:name,'^s:',matchstr(expand('<sfile>'), '<SNR>\d\+_'),''))
endfunction

function! s:sub(str,pat,rep) abort
  return substitute(a:str,'\v\C'.a:pat,a:rep,'')
endfunction

function! s:gsub(str,pat,rep) abort
  return substitute(a:str,'\v\C'.a:pat,a:rep,'g')
endfunction

function! s:shellesc(arg) abort
  if a:arg =~ '^[A-Za-z0-9_/.-]\+$'
    return a:arg
  else
    return shellescape(a:arg)
  endif
endfunction

function! s:fnameescape(file) abort
  if exists('*fnameescape')
    return fnameescape(a:file)
  else
    return escape(a:file," \t\n*?[{`$\\%#'\"|!<")
  endif
endfunction

function! s:throw(string) abort
  let v:errmsg = 'fugitive: '.a:string
  throw v:errmsg
endfunction

function! s:add_methods(namespace, method_names) abort
  for name in a:method_names
    let s:{a:namespace}_prototype[name] = s:function('s:'.a:namespace.'_'.name)
  endfor
endfunction

let s:commands = []
function! s:command(definition) abort
  let s:commands += [a:definition]
endfunction

function! s:define_commands()
  for command in s:commands
    exe 'command! -buffer '.command
  endfor
endfunction

augroup fugitive_commands
  autocmd!
  autocmd User Fugitive call s:define_commands()
augroup END

let s:abstract_prototype = {}

" }}}1
" Initialization {{{1

function! s:ExtractGitDir(path) abort
  if a:path =~? '^fugitive://.*//'
    return matchstr(a:path,'fugitive://\zs.\{-\}\ze//')
  endif
  let fn = fnamemodify(a:path,':s?[\/]$??')
  let ofn = ""
  let nfn = fn
  while fn != ofn
    if isdirectory(fn . '/.git')
      return s:sub(simplify(fnamemodify(fn . '/.git',':p')),'/$','')
    elseif fn =~ '\.git$' && filereadable(fn . '/HEAD')
      return s:sub(simplify(fnamemodify(fn,':p')),'/$','')
    endif
    let ofn = fn
    let fn = fnamemodify(ofn,':h')
  endwhile
  return ''
endfunction

function! s:Detect()
  if !exists('b:git_dir')
    let dir = s:ExtractGitDir(expand('%:p'))
    if dir != ''
      let b:git_dir = dir
    endif
  endif
  if exists('b:git_dir')
    silent doautocmd User Fugitive
    cnoremap <expr> <buffer> <C-R><C-G> fugitive#buffer().rev()
  endif
endfunction

augroup fugitive
  autocmd!
  autocmd BufNewFile,BufReadPost * call s:Detect()
  autocmd FileType           netrw call s:Detect()
  autocmd BufWinLeave * execute getbufvar(+expand('<abuf>'), 'fugitive_restore')
augroup END

" }}}1
" Repository {{{1

let s:repo_prototype = {}
let s:repos = {}

function! s:repo(...) abort
  let dir = a:0 ? a:1 : (exists('b:git_dir') ? b:git_dir : s:ExtractGitDir(expand('%:p')))
  if dir == ''
    call s:throw('not a git repository: '.expand('%:p'))
  else
    if has_key(s:repos,dir)
      let repo = get(s:repos,dir)
    else
      let repo = {'git_dir': dir}
      let s:repos[dir] = repo
    endif
    return extend(extend(repo,s:repo_prototype,'keep'),s:abstract_prototype,'keep')
  endif
endfunction

function! s:repo_dir(...) dict abort
  return join([self.git_dir]+a:000,'/')
endfunction

function! s:repo_tree(...) dict abort
  if self.bare()
    call s:throw('no work tree')
  else
    let dir = fnamemodify(self.git_dir,':h')
    return join([dir]+a:000,'/')
  endif
endfunction

function! s:repo_bare() dict abort
  return self.dir() !~# '/\.git$'
endfunction

function! s:repo_translate(spec) dict abort
  if a:spec ==# '.' || a:spec ==# '/.'
    return self.bare() ? self.dir() : self.tree()
  elseif a:spec =~# '^/'
    return fnamemodify(self.dir(),':h').a:spec
  elseif a:spec =~# '^:[0-3]:'
    return 'fugitive://'.self.dir().'//'.a:spec[1].'/'.a:spec[3:-1]
  elseif a:spec ==# ':'
    return self.dir('index')
  elseif a:spec =~# '^:/'
    let ref = self.rev_parse(matchstr(a:spec,'.[^:]*'))
    return 'fugitive://'.self.dir().'//'.ref
  elseif a:spec =~# '^:'
    return 'fugitive://'.self.dir().'//0/'.a:spec[1:-1]
  elseif a:spec =~# 'HEAD\|^refs/' && a:spec !~ ':' && filereadable(self.dir(a:spec))
    return self.dir(a:spec)
  elseif filereadable(s:repo().dir('refs/'.a:spec))
    return self.dir('refs/'.a:spec)
  elseif filereadable(s:repo().dir('refs/tags/'.a:spec))
    return self.dir('refs/tags/'.a:spec)
  elseif filereadable(s:repo().dir('refs/heads/'.a:spec))
    return self.dir('refs/heads/'.a:spec)
  elseif filereadable(s:repo().dir('refs/remotes/'.a:spec))
    return self.dir('refs/remotes/'.a:spec)
  elseif filereadable(s:repo().dir('refs/remotes/'.a:spec.'/HEAD'))
    return self.dir('refs/remotes/'.a:spec,'/HEAD')
  else
    try
      let ref = self.rev_parse(matchstr(a:spec,'[^:]*'))
      let path = s:sub(matchstr(a:spec,':.*'),'^:','/')
      return 'fugitive://'.self.dir().'//'.ref.path
    catch /^fugitive:/
      return self.tree(a:spec)
    endtry
  endif
endfunction

call s:add_methods('repo',['dir','tree','bare','translate'])

function! s:repo_git_command(...) dict abort
  let git = g:fugitive_git_executable . ' --git-dir='.s:shellesc(self.git_dir)
  return git.join(map(copy(a:000),'" ".s:shellesc(v:val)'),'')
endfunction

function! s:repo_git_chomp(...) dict abort
  return s:sub(system(call(self.git_command,a:000,self)),'\n$','')
endfunction

function! s:repo_git_chomp_in_tree(...) dict abort
  let cd = exists('*haslocaldir') && haslocaldir() ? 'lcd ' : 'cd '
  let dir = getcwd()
  try
    execute cd.' `=s:repo().tree()`'
    return call(s:repo().git_chomp, a:000, s:repo())
  finally
    execute cd.' `=dir`'
  endtry
endfunction

function! s:repo_rev_parse(rev) dict abort
  let hash = self.git_chomp('rev-parse','--verify',a:rev)
  if hash =~ '^\x\{40\}$'
    return hash
  else
    call s:throw('rev-parse '.a:rev.': '.hash)
  endif
endfunction

call s:add_methods('repo',['git_command','git_chomp','git_chomp_in_tree','rev_parse'])

function! s:repo_dirglob(base) dict abort
  let base = s:sub(a:base,'^/','')
  let matches = split(glob(self.tree(s:gsub(base,'/','*&').'*/')),"\n")
  call map(matches,'v:val[ strlen(self.tree())+(a:base !~ "^/") : -1 ]')
  return matches
endfunction

function! s:repo_superglob(base) dict abort
  if a:base =~# '^/' || a:base !~# ':'
    let results = []
    if a:base !~# '^/'
      let heads = ["HEAD","ORIG_HEAD","FETCH_HEAD","MERGE_HEAD"]
      let heads += sort(split(s:repo().git_chomp("rev-parse","--symbolic","--branches","--tags","--remotes"),"\n"))
      call filter(heads,'v:val[ 0 : strlen(a:base)-1 ] ==# a:base')
      let results += heads
    endif
    if !self.bare()
      let base = s:sub(a:base,'^/','')
      let matches = split(glob(self.tree(s:gsub(base,'/','*&').'*')),"\n")
      call map(matches,'v:val !~ "/$" && isdirectory(v:val) ? v:val."/" : v:val')
      call map(matches,'v:val[ strlen(self.tree())+(a:base !~ "^/") : -1 ]')
      let results += matches
    endif
    return results

  elseif a:base =~# '^:'
    let entries = split(self.git_chomp('ls-files','--stage'),"\n")
    call map(entries,'s:sub(v:val,".*(\\d)\\t(.*)",":\\1:\\2")')
    if a:base !~# '^:[0-3]\%(:\|$\)'
      call filter(entries,'v:val[1] == "0"')
      call map(entries,'v:val[2:-1]')
    endif
    call filter(entries,'v:val[ 0 : strlen(a:base)-1 ] ==# a:base')
    return entries

  else
    let tree = matchstr(a:base,'.*[:/]')
    let entries = split(self.git_chomp('ls-tree',tree),"\n")
    call map(entries,'s:sub(v:val,"^04.*\\zs$","/")')
    call map(entries,'tree.s:sub(v:val,".*\t","")')
    return filter(entries,'v:val[ 0 : strlen(a:base)-1 ] ==# a:base')
  endif
endfunction

call s:add_methods('repo',['dirglob','superglob'])

function! s:repo_keywordprg() dict abort
  let args = ' --git-dir='.escape(self.dir(),"\\\"' ").' show'
  if has("gui_running")
    return g:fugitive_git_executable . ' --no-pager' . args
  else
    return g:fugitive_git_executable . args
  endif
endfunction

call s:add_methods('repo',['keywordprg'])

" }}}1
" Buffer {{{1

let s:buffer_prototype = {}

function! s:buffer(...) abort
  let buffer = {'#': bufnr(a:0 ? a:1 : '%')}
  call extend(extend(buffer,s:buffer_prototype,'keep'),s:abstract_prototype,'keep')
  if buffer.getvar('git_dir') == ''
    call s:throw('not a git repository: '.expand('%:p'))
  endif
  return buffer
endfunction

function! fugitive#buffer(...) abort
  return s:buffer(a:0 ? a:1 : '%')
endfunction

function! s:buffer_getvar(var) dict abort
  return getbufvar(self['#'],a:var)
endfunction

function! s:buffer_getline(lnum) dict abort
  return getbufline(self['#'],a:lnum)[0]
endfunction

function! s:buffer_repo() dict abort
  return s:repo(self.getvar('git_dir'))
endfunction

function! s:buffer_type(...) dict abort
  if self.getvar('fugitive_type') != ''
    let type = self.getvar('fugitive_type')
  elseif fnamemodify(self.name(),':p') =~# '.\git/refs/\|\.git/\w*HEAD$'
    let type = 'head'
  elseif self.getline(1) =~ '^tree \x\{40\}$' && self.getline(2) == ''
    let type = 'tree'
  elseif self.getline(1) =~ '^\d\{6\} \w\{4\} \x\{40\}\>\t'
    let type = 'tree'
  elseif self.getline(1) =~ '^\d\{6\} \x\{40\}\> \d\t'
    let type = 'index'
  elseif isdirectory(self.name())
    let type = 'directory'
  elseif filereadable(self.name())
    let type = 'file'
  else
    let type = ''
  endif
  if a:0
    return !empty(filter(copy(a:000),'v:val ==# type'))
  else
    return type
  endif
endfunction

function! s:buffer_name() dict abort
  return fnamemodify(bufname(self['#']),':p')
endfunction

function! s:buffer_commit() dict abort
  return matchstr(self.name(),'^fugitive://.\{-\}//\zs\w*')
endfunction

function! s:buffer_path(...) dict abort
  let rev = matchstr(self.name(),'^fugitive://.\{-\}//\zs.*')
  if rev != ''
    let rev = s:sub(rev,'\w*','')
  elseif self.name() =~ '\.git/refs/\|\.git/.*HEAD$'
    let rev = ''
  else
    let rev = self.name()[strlen(self.repo().tree()) : -1]
  endif
  return s:sub(rev,'^/',a:0 ? a:1 : '')
endfunction

function! s:buffer_rev() dict abort
  let rev = matchstr(self.name(),'^fugitive://.\{-\}//\zs.*')
  if rev =~ '^\x/'
    return ':'.rev[0].':'.rev[2:-1]
  elseif rev =~ '.'
    return s:sub(rev,'/',':')
  elseif self.name() =~ '\.git/index$'
    return ':'
  elseif self.name() =~ '\.git/refs/\|\.git/.*HEAD$'
    return self.name()[strlen(self.repo().dir())+1 : -1]
  else
    return self.path()
  endif
endfunction

function! s:buffer_sha1() dict abort
  if self.name() =~ '^fugitive://' || self.name() =~ '\.git/refs/\|\.git/.*HEAD$'
    return self.repo().rev_parse(self.rev())
  else
    return ''
  endif
endfunction

function! s:buffer_expand(rev) dict abort
  if a:rev =~# '^:[0-3]$'
    let file = a:rev.self.path(':')
  elseif a:rev =~# '^-'
    let file = 'HEAD^{}'.a:rev[1:-1].self.path(':')
  elseif a:rev =~# '^@{'
    let file = 'HEAD'.a:rev.self.path(':')
  elseif a:rev =~# '^[~^]'
    let commit = s:sub(self.commit(),'^\d=$','HEAD')
    let file = commit.a:rev.self.path(':')
  else
    let file = a:rev
  endif
  return s:sub(file,'\%$',self.path())
endfunction

function! s:buffer_containing_commit() dict abort
  if self.commit() =~# '\x\{40\}'
    return self.commit()
  elseif self.commit() =~# '.'
    return ':'
  else
    return 'HEAD'
  endif
endfunction

call s:add_methods('buffer',['getvar','getline','repo','type','name','commit','path','rev','sha1','expand','containing_commit'])

" }}}1
" Git {{{1

call s:command("-bar -bang -nargs=? -complete=customlist,s:GitComplete Git :call s:Git(<bang>0,<q-args>)")

function! s:ExecuteInTree(cmd) abort
  let cd = exists('*haslocaldir') && haslocaldir() ? 'lcd ' : 'cd '
  let dir = getcwd()
  try
    execute cd.' `=s:repo().tree()`'
    execute a:cmd
  finally
    execute cd.' `=dir`'
  endtry
endfunction

function! s:Git(bang,cmd) abort
  let git = s:repo().git_command()
  if has('gui_running')
    let git .= ' --no-pager'
  endif
  call s:ExecuteInTree('!'.git.' '.a:cmd)
  call fugitive#reload_status()
endfunction

function! s:GitComplete(A,L,P) abort
  if !exists('s:exec_path')
    let s:exec_path = s:sub(system(g:fugitive_git_executable.' --exec-path'),'\n$','')
  endif
  let cmds = map(split(glob(s:exec_path.'/git-*'),"\n"),'v:val[strlen(s:exec_path)+5 : -1]')
  if a:L =~ ' [[:alnum:]-]\+ '
    return s:repo().superglob(a:A)
  elseif a:A == ''
    return cmds
  else
    return filter(cmds,'v:val[0 : strlen(a:A)-1] ==# a:A')
  endif
endfunction

" }}}1
" Gcd, Glcd {{{1

function! s:DirComplete(A,L,P) abort
  let matches = s:repo().dirglob(a:A)
  return matches
endfunction

call s:command("-bar -bang -nargs=? -complete=customlist,s:DirComplete Gcd  :cd<bang>  `=s:repo().bare() ? s:repo().dir(<q-args>) : s:repo().tree(<q-args>)`")
call s:command("-bar -bang -nargs=? -complete=customlist,s:DirComplete Glcd :lcd<bang> `=s:repo().bare() ? s:repo().dir(<q-args>) : s:repo().tree(<q-args>)`")

" }}}1
" Gstatus {{{1

call s:command("-bar Gstatus :execute s:Status()")

function! s:Status()
  try
    Gpedit :
    wincmd P
    nnoremap <buffer> <silent> q    :<C-U>bdelete<CR>
  catch /^fugitive:/
    return 'echoerr v:errmsg'
  endtry
  return ''
endfunction

function! fugitive#reload_status()
  let mytab = tabpagenr()
  for tab in [mytab] + range(1,tabpagenr('$'))
    for winnr in range(1,tabpagewinnr(tab,'$'))
      if getbufvar(tabpagebuflist(tab)[winnr-1],'fugitive_type') ==# 'index'
        execute 'tabnext '.tab
        if winnr != winnr()
          execute winnr.'wincmd w'
          let restorewinnr = 1
        endif
        try
          if !&modified
            call s:BufReadIndex()
          endif
        finally
          if exists('restorewinnr')
            wincmd p
          endif
          execute 'tabnext '.mytab
        endtry
      endif
    endfor
  endfor
endfunction

function! s:StageToggle(lnum1,lnum2)
  try
    let output = ''
    for lnum in range(a:lnum1,a:lnum2)
      let line = getline(lnum)
      let filename = matchstr(line,'^#\t[[:alpha:] ]\+: *\zs.*')
      if filename ==# ''
        let filename = matchstr(line,'^#\t\zs.*')
      endif
      if filename ==# ''
        continue
      endif
      if !exists('first_filename')
        let first_filename = filename
      endif
      execute lnum
      let section = getline(search('^# .*:$','bnW'))
      if line =~# '^#\trenamed:' && filename =~ ' -> '
        let cmd = ['mv','--'] + reverse(split(filename,' -> '))
        let filename = cmd[-1]
      elseif section =~? ' to be '
        let cmd = ['reset','-q','--',filename]
      elseif line =~# '^#\tdeleted:'
        let cmd = ['rm','--',filename]
      else
        let cmd = ['add','--',filename]
      endif
      let output .= call(s:repo().git_chomp_in_tree,cmd,s:repo())."\n"
    endfor
    if exists('first_filename')
      silent! edit!
      1
      redraw
      call search('^#\t\%([[:alpha:] ]\+: *\)\=\V'.first_filename.'\$','W')
    endif
    echo s:sub(s:gsub(output,'\n+','\n'),'\n$','')
  catch /^fugitive:/
    return 'echoerr v:errmsg'
  endtry
  return 'checktime'
endfunction

" }}}1
" Ggrep, Glog {{{1

call s:command("-bar -bang -nargs=? -complete=customlist,s:EditComplete Ggrep :execute s:Grep(<bang>0,<q-args>)")
call s:command("-bar -bang Glog :execute s:Log('grep<bang>')")

function! s:Grep(bang,arg) abort
  let grepprg = &grepprg
  let grepformat = &grepformat
  let cd = exists('*haslocaldir') && haslocaldir() ? 'lcd ' : 'cd '
  let cd .= s:fnameescape(getcwd())
  try
    cd `=s:repo().tree()`
    let &grepprg = s:repo().git_command('--no-pager', 'grep', '-n')
    let &grepformat = '%f:%l:%m'
    exe 'grep! '.a:arg
    let list = getqflist()
    for entry in list
      if bufname(entry.bufnr) =~ ':'
        let entry.filename = s:repo().translate(bufname(entry.bufnr))
        unlet! entry.bufnr
      elseif a:arg =~# '\%(^\| \)--cached\>'
        let entry.filename = s:repo().translate(':0:'.bufname(entry.bufnr))
        unlet! entry.bufnr
      endif
    endfor
    call setqflist(list,'r')
    if !a:bang && !empty(list)
      return 'cfirst'
    else
      return ''
    endif
  finally
    let &grepprg = grepprg
    let &grepformat = grepformat
    exe cd
  endtry
endfunction

function! s:Log(cmd)
  let cmd = ['--no-pager', 'log', '--no-color', '--pretty=format:fugitive://'.s:repo().dir().'//%H'.s:buffer().path('/').'::%s']
  if s:buffer().commit() =~# '\x\{40\}'
    let cmd += [s:buffer().commit().'^']
  endif
  let cmd += ['--']
  if s:buffer().path() != ''
    let cmd += [s:buffer().path()]
  endif
  let grepformat = &grepformat
  let grepprg = &grepprg
  try
    let &grepprg = escape(call(s:repo().git_command,cmd,s:repo()),'%')
    let &grepformat = '%f::%m'
    exe a:cmd
  finally
    let &grepformat = grepformat
    let &grepprg = grepprg
  endtry
endfunction

" }}}1
" Gedit, Gpedit, Gsplit, Gvsplit, Gtabedit, Gread {{{1

function! s:Edit(cmd,...) abort
  if a:0 && a:1 == ''
    return ''
  elseif a:0
    let file = s:buffer().expand(a:1)
  elseif s:buffer().commit() ==# '' && s:buffer().path('/') !~# '^/.git\>'
    let file = s:buffer().path(':')
  else
    let file = s:buffer().path('/')
  endif
  try
    let file = s:repo().translate(file)
  catch /^fugitive:/
    return 'echoerr v:errmsg'
  endtry
  if a:cmd =~# 'read!$'
    return '%delete|read '.s:fnameescape(file).'|1delete_|diffupdate|'.line('.')
  else
    if &previewwindow && getbufvar('','fugitive_type') ==# 'index'
      wincmd p
    endif
    return a:cmd.' '.s:fnameescape(file)
  endif
endfunction

function! s:EditComplete(A,L,P) abort
  return s:repo().superglob(a:A)
endfunction

call s:command("-bar -bang -nargs=? -complete=customlist,s:EditComplete Ge       :execute s:Edit('edit<bang>',<f-args>)")
call s:command("-bar -bang -nargs=? -complete=customlist,s:EditComplete Gedit    :execute s:Edit('edit<bang>',<f-args>)")
call s:command("-bar -bang -nargs=? -complete=customlist,s:EditComplete Gpedit   :execute s:Edit('pedit<bang>',<f-args>)")
call s:command("-bar -bang -nargs=? -complete=customlist,s:EditComplete Gsplit   :execute s:Edit('split<bang>',<f-args>)")
call s:command("-bar -bang -nargs=? -complete=customlist,s:EditComplete Gvsplit  :execute s:Edit('vsplit<bang>',<f-args>)")
call s:command("-bar -bang -nargs=? -complete=customlist,s:EditComplete Gtabedit :execute s:Edit('tabedit<bang>',<f-args>)")
call s:command("-bar -bang -nargs=? -range -complete=customlist,s:EditComplete Gread :execute s:Edit('<line1>,<line2>read<bang>',<f-args>)")

" }}}1
" Gwrite {{{1

call s:command("-bar -bang -nargs=? -complete=customlist,s:EditComplete Gwrite :execute s:Write(<bang>0,<f-args>)")

function! s:Write(force,...) abort
  let mytab = tabpagenr()
  let mybufnr = bufnr('')
  let path = a:0 ? a:1 : s:buffer().path()
  if path =~# '^:\d\>'
    return 'write'.(a:force ? '! ' : ' ').s:fnameescape(s:repo().translate(s:buffer().expand(path)))
  endif
  let always_permitted = (s:buffer().path() ==# path && s:buffer().commit() =~# '^0\=$')
  if !always_permitted && !a:force && s:repo().git_chomp_in_tree('diff','--name-status','HEAD','--',path) . s:repo().git_chomp_in_tree('ls-files','--others','--',path) !=# ''
    let v:errmsg = 'fugitive: file has uncommitted changes (use ! to override)'
    return 'echoerr v:errmsg'
  endif
  let file = s:repo().translate(path)
  let treebufnr = 0
  for nr in range(1,bufnr('$'))
    if fnamemodify(bufname(nr),':p') == file
      let treebufnr = nr
    endif
  endfor

  if treebufnr > 0 && treebufnr != bufnr('')
    let temp = tempname()
    silent execute '%write '.temp
    for tab in [mytab] + range(1,tabpagenr('$'))
      for winnr in range(1,tabpagewinnr(tab,'$'))
        if tabpagebuflist(tab)[winnr-1] == treebufnr
          execute 'tabnext '.tab
          if winnr != winnr()
            execute winnr.'wincmd w'
            let restorewinnr = 1
          endif
          try
            let lnum = line('.')
            let last = line('$')
            silent execute '$read '.temp
            silent execute '1,'.last.'delete_'
            silent write!
            silent execute lnum
            let did = 1
          finally
            if exists('restorewinnr')
              wincmd p
            endif
            execute 'tabnext '.mytab
          endtry
        endif
      endfor
    endfor
    if !exists('did')
      call writefile(readfile(temp,'b'),file,'b')
    endif
  else
    execute 'write! '.s:fnameescape(s:repo().translate(path))
  endif

  let error = s:repo().git_chomp_in_tree('add', file)
  if v:shell_error
    let v:errmsg = 'fugitive: '.error
    return 'echoerr v:errmsg'
  endif
  if s:buffer().path() == path && s:buffer().commit() =~# '^\d$'
    set nomodified
  endif

  let one = s:repo().translate(':1:'.path)
  let two = s:repo().translate(':2:'.path)
  let three = s:repo().translate(':3:'.path)
  for nr in range(1,bufnr('$'))
    if bufloaded(nr) && !getbufvar(nr,'&modified') && (bufname(nr) == one || bufname(nr) == two || bufname(nr) == three)
      execute nr.'bdelete'
    endif
  endfor

  unlet! restorewinnr
  let zero = s:repo().translate(':0:'.path)
  for tab in range(1,tabpagenr('$'))
    for winnr in range(1,tabpagewinnr(tab,'$'))
      let bufnr = tabpagebuflist(tab)[winnr-1]
      let bufname = bufname(bufnr)
      if bufname ==# zero && bufnr != mybufnr
        execute 'tabnext '.tab
        if winnr != winnr()
          execute winnr.'wincmd w'
          let restorewinnr = 1
        endif
        try
          let lnum = line('.')
          let last = line('$')
          silent $read `=file`
          silent execute '1,'.last.'delete_'
          silent execute lnum
          set nomodified
          diffupdate
        finally
          if exists('restorewinnr')
            wincmd p
          endif
          execute 'tabnext '.mytab
        endtry
        break
      endif
    endfor
  endfor
  call fugitive#reload_status()
  return 'checktime'
endfunction

" }}}1
" Gdiff {{{1

call s:command("-bar -nargs=? -complete=customlist,s:EditComplete Gdiff :execute s:Diff(<f-args>)")

augroup fugitive_diff
  autocmd BufWinLeave * if winnr('$') == 2 && &diff && getbufvar(+expand('<abuf>'), 'git_dir') !=# '' | diffoff! | endif
  autocmd BufWinEnter * if winnr('$') == 1 && &diff && getbufvar(+expand('<abuf>'), 'git_dir') !=# '' | diffoff | endif
augroup END

function! s:Diff(...) abort
  if exists(':DiffGitCached')
    return 'DiffGitCached'
  elseif (!a:0 || a:1 == ':') && s:buffer().commit() =~# '^[0-1]\=$' && s:repo().git_chomp_in_tree('ls-files', '--unmerged', '--', s:buffer().path()) !=# ''
      leftabove vsplit `=fugitive#buffer().repo().translate(s:buffer().expand(':2'))`
      diffthis
      wincmd p
      rightbelow vsplit `=fugitive#buffer().repo().translate(s:buffer().expand(':3'))`
      diffthis
      wincmd p
      diffthis
      return ''
  elseif a:0
    if a:1 ==# ''
      return ''
    elseif a:1 ==# '/'
      let file = s:buffer().path('/')
    elseif a:1 ==# ':'
      let file = s:buffer().path(':0:')
    elseif a:1 =~# '^:/'
      try
        let file = s:repo().rev_parse(a:1)
      catch /^fugitive:/
        return 'echoerr v:errmsg'
      endtry
    else
      let file = s:buffer().expand(a:1)
    endif
    if file !~ ':' && file !~ '^/'
      let file = file.s:buffer().path(':')
    endif
  else
    let file = s:buffer().path(s:buffer().commit() == '' ? ':0:' : '/')
  endif
  try
    vsplit `=fugitive#buffer().repo().translate(file)`
    diffthis
    wincmd p
    diffthis
    return ''
  catch /^fugitive:/
    return 'echoerr v:errmsg'
  endtry
endfunction

" }}}1
" Gmove, Gremove {{{1

function! s:Move(force,destination)
  if a:destination =~# '^/'
    let destination = a:destination[1:-1]
  else
    let destination = fnamemodify(s:sub(a:destination,'[%#]%(:\w)*','\=expand(submatch(0))'),':p')
    if destination[0:strlen(s:repo().tree())] == s:repo().tree('')
      let destination = destination[strlen(s:repo().tree('')):-1]
    endif
  endif
  let message = call(s:repo().git_chomp_in_tree,['mv']+(a:force ? ['-f'] : [])+['--', s:buffer().path(), destination], s:repo())
  if v:shell_error
    let v:errmsg = 'fugitive: '.message
    return 'echoerr v:errmsg'
  endif
  let destination = s:repo().tree(destination)
  if isdirectory(destination)
    let destination = fnamemodify(s:sub(destination,'/$','').'/'.expand('%:t'),':.')
  endif
  call fugitive#reload_status()
  if s:buffer().commit() == ''
    return 'saveas! '.s:fnameescape(destination)
  else
    return 'file '.s:fnameescape(s:repo.translate(':0:'.destination)
  endif
endfunction

function! s:MoveComplete(A,L,P)
  if a:A =~ '^/'
    return s:repo().superglob(a:A)
  else
    return split(glob(a:A.'*'),"\n")
  endif
endfunction

function! s:Remove(force)
  if s:buffer().commit() ==# ''
    let cmd = ['rm']
  elseif s:buffer().commit() ==# '0'
    let cmd = ['rm','--cached']
  else
    let v:errmsg = 'fugitive: rm not supported here'
    return 'echoerr v:errmsg'
  endif
  if a:force
    let cmd += ['--force']
  endif
  let message = call(s:repo().git_chomp_in_tree,cmd+['--',s:buffer().path()],s:repo())
  if v:shell_error
    let v:errmsg = 'fugitive: '.s:sub(message,'error:.*\zs\n\(.*-f.*',' (add ! to force)')
    return 'echoerr '.string(v:errmsg)
  else
    call fugitive#reload_status()
    return 'bdelete'.(a:force ? '!' : '')
  endif
endfunction

augroup fugitive_remove
  autocmd!
  autocmd User Fugitive if s:buffer().commit() =~# '^0\=$' |
        \ exe "command! -buffer -bar -bang -nargs=1 -complete=customlist,s:MoveComplete Gmove :execute s:Move(<bang>0,<q-args>)" |
        \ exe "command! -buffer -bar -bang Gremove :execute s:Remove(<bang>0)" |
        \ endif
augroup END

" }}}1
" Gblame {{{1

augroup fugitive_blame
  autocmd!
  autocmd BufReadPost *.fugitiveblame setfiletype fugitiveblame
  autocmd FileType fugitiveblame setlocal nomodeline | if exists('b:git_dir') | let &l:keywordprg = s:repo().keywordprg() | endif
  autocmd Syntax fugitiveblame call s:BlameSyntax()
  autocmd User Fugitive if s:buffer().type('file', 'blob') | exe "command! -buffer -bar -bang -range=0 Gblame :execute s:Blame(<bang>0,<line1>,<line2>,<count>,<f-args>)" | endif
augroup END

function! s:Blame(bang,line1,line2,count) abort
  try
    if s:buffer().path() == ''
      call s:throw('file or blob required')
    endif
    let git_dir = s:repo().dir()
    let cmd = ['--no-pager', 'blame', '--show-number']
    if strlen(s:buffer().commit()) == 40
      let cmd += [s:buffer().commit()]
    else
      let cmd += ['--contents', '-']
    endif
    let basecmd = call(s:repo().git_command,cmd+['--',s:buffer().path()],s:repo())
    try
      let cd = exists('*haslocaldir') && haslocaldir() ? 'lcd ' : 'cd '
      if !s:repo().bare()
        let dir = getcwd()
        execute cd.' `=s:repo().tree()`'
      endif
      if a:count
        execute 'write !'.substitute(basecmd,' blame ',' blame -L '.a:line1.','.a:line2.' ','g')
      else
        let temp = tempname().'.fugitiveblame'
        silent! exe '%write !'.basecmd.' > '.temp.' 2> '.temp
        if v:shell_error
          call s:throw(join(readfile(temp),"\n"))
        endif
        let bufnr = bufnr('')
        let restore = 'call setbufvar('.bufnr.',"&scrollbind",0)'
        if &l:wrap
          let restore .= '|call setbufvar('.bufnr.',"&wrap",1)'
        endif
        if &l:foldenable
          let restore .= '|call setbufvar('.bufnr.',"&foldenable",1)'
        endif
        let winnr = winnr()
        windo set noscrollbind
        exe winnr.'wincmd w'
        setlocal scrollbind nowrap nofoldenable
        let top = line('w0') + &scrolloff
        let current = line('.')
        exe 'leftabove vsplit '.temp
        let b:git_dir = git_dir
        let b:fugitive_type = 'blame'
        let b:fugitive_blamed_bufnr = bufnr
        let b:fugitive_restore = restore
        call s:Detect()
        execute top
        normal! zt
        execute current
        execute "vertical resize ".(match(getline('.'),'\s\+\d\+)')+1)
        setlocal nomodified nomodifiable nonumber scrollbind nowrap foldcolumn=0 nofoldenable filetype=fugitiveblame
        nnoremap <buffer> <silent> q    :<C-U>bdelete<CR>
        nnoremap <buffer> <silent> <CR> :<C-U>exe <SID>BlameJump()<CR>
        nnoremap <buffer> <silent> o    :<C-U>exe <SID>Edit((&splitbelow ? "botright" : "topleft")." split", matchstr(getline('.'),'\x\+'))<CR>
        nnoremap <buffer> <silent> O    :<C-U>exe <SID>Edit("tabedit", matchstr(getline('.'),'\x\+'))<CR>
        syncbind
      endif
    finally
      if exists('l:dir')
        execute cd.' `=dir`'
      endif
    endtry
    return ''
  catch /^fugitive:/
    return 'echoerr v:errmsg'
  endtry
endfunction

function! s:BlameJump() abort
  let commit = matchstr(getline('.'),'^\^\=\zs\x\+')
  if commit =~# '^0\+$'
    let commit = ':0'
  endif
  let lnum = matchstr(getline('.'),'\d\+\ze (')
  let path = matchstr(getline('.'),'^\^\=\zs\x\+\s\+\zs.\{-\}\ze\s*\d\+ (')
  if path ==# ''
    let path = s:buffer(b:fugitive_blamed_bufnr).path()
  endif
  let offset = line('.') - line('w0')
  let bufnr = bufnr('%')
  let winnr = bufwinnr(b:fugitive_blamed_bufnr)
  if winnr > 0
    exe winnr.'wincmd w'
  endif
  execute s:Edit('edit',commit.':'.path)
  if winnr > 0
    exe bufnr.'bdelete'
  endif
  Gblame
  execute lnum
  let delta = line('.') - line('w0') - offset
  if delta > 0
    execute 'norm! 'delta."\<C-E>"
  elseif delta < 0
    execute 'norm! '(-delta)."\<C-Y>"
  endif
  syncbind
  return ''
endfunction

function! s:BlameSyntax() abort
  let b:current_syntax = 'fugitiveblame'
  syn match FugitiveblameBoundary "^\^"
  syn match FugitiveblameHash       "\%(^\^\=\)\@<=\x\{7,40\}\>" nextgroup=FugitiveblameAnnotation,fugitiveblameOriginalFile,FugitiveblameOriginalLineNumber skipwhite
  syn match FugitiveblameUncommitted "\%(^\^\=\)\@<=0\{7,40\}\>" nextgroup=FugitiveblameAnnotation,FugitiveblameOriginalLineNumber,fugitiveblameOriginalFile skipwhite
  syn region FugitiveblameAnnotation matchgroup=FugitiveblameDelimiter start="(" end="\%( \d\+\)\@<=)" contained keepend oneline
  syn match FugitiveblameTime "[0-9:/+-][0-9:/+ -]*[0-9:/+-]\%( \+\d\+)\)\@=" contained containedin=FugitiveblameAnnotation
  syn match FugitiveblameLineNumber         " \@<=\d\+)\@=" contained containedin=FugitiveblameAnnotation
  syn match FugitiveblameOriginalFile       " \%(\f\+\D\@<=\|\D\@=\f\+\)\%(\%(\s\+\d\+\)\= (\)\@=" contained nextgroup=FugitiveblameOriginalLineNumber,FugitiveblameAnnotation skipwhite
  syn match FugitiveblameOriginalLineNumber " \@<=\d\+\%( (\)\@=" contained nextgroup=FugitiveblameAnnotation skipwhite
  syn match FugitiveblameNotCommittedYet "(\@<=Not Committed Yet\>" contained containedin=FugitiveblameAnnotation
  hi def link FugitiveblameBoundary           Keyword
  hi def link FugitiveblameHash               Identifier
  hi def link FugitiveblameUncommitted        Function
  hi def link FugitiveblameTime               PreProc
  hi def link FugitiveblameLineNumber         Number
  hi def link FugitiveblameOriginalFile       String
  hi def link FugitiveblameOriginalLineNumber Float
  hi def link FugitiveblameDelimiter          Delimiter
  hi def link FugitiveblameNotCommittedYet    Comment
endfunction

" }}}1
" File access {{{1

function! s:ReplaceCmd(cmd) abort
  let fn = bufname('')
  let tmp = tempname()
  let aw = &autowrite
  try
    set noautowrite
    silent exe '!'.escape(a:cmd,'%#') ' > '.tmp
  finally
    let &autowrite = aw
  endtry
  silent exe 'keepalt file '.tmp
  silent edit!
  silent exe 'keepalt file '.s:fnameescape(fn)
  call delete(tmp)
  silent exe 'doau BufReadPost '.s:fnameescape(fn)
endfunction

function! s:BufReadIndex()
  if !exists('b:fugitive_display_format')
    let b:fugitive_display_format = +getbufvar('#','fugitive_display_format')
  endif
  let b:fugitive_display_format = b:fugitive_display_format % 2
  let b:fugitive_type = 'index'
  try
    let b:git_dir = s:repo().dir()
    setlocal noro ma
    if b:fugitive_display_format
      call s:ReplaceCmd(s:repo().git_command('ls-files','--stage'))
      set ft=git nospell
    else
      let cd = exists('*haslocaldir') && haslocaldir() ? 'lcd ' : 'cd '
      let dir = getcwd()
      try
        execute cd.' `=s:repo().tree()`'
        call s:ReplaceCmd(s:repo().git_command('status'))
      finally
        execute cd.' `=dir`'
      endtry
      set ft=gitcommit
    endif
    setlocal ro noma nomod nomodeline bufhidden=delete
    nnoremap <buffer> <silent> a :<C-U>let b:fugitive_display_format += 1<Bar>exe <SID>BufReadIndex()<CR>
    nnoremap <buffer> <silent> i :<C-U>let b:fugitive_display_format -= 1<Bar>exe <SID>BufReadIndex()<CR>
    nnoremap <buffer> <silent> - :<C-U>execute <SID>StageToggle(line('.'),line('.')+v:count1-1)<CR>
    xnoremap <buffer> <silent> - :<C-U>execute <SID>StageToggle(line("'<"),line("'>"))<CR>
    call s:JumpInit()
  catch /^fugitive:/
    return 'echoerr v:errmsg'
  endtry
endfunction

function! s:FileRead()
  try
    let repo = s:repo(s:ExtractGitDir(expand('<amatch>')))
    let path = s:sub(s:sub(matchstr(expand('<amatch>'),'fugitive://.\{-\}//\zs.*'),'/',':'),'^\d:',':&')
    let hash = repo.rev_parse(path)
    if path =~ '^:'
      let type = 'blob'
    else
      let type = repo.git_chomp('cat-file','-t',hash)
    endif
    " TODO: use count, if possible
    return "read !".escape(repo.git_command('cat-file',type,hash),'%#\')
  catch /^fugitive:/
    return 'echoerr v:errmsg'
  endtry
endfunction

function! s:BufReadIndexFile()
  try
    let b:fugitive_type = 'blob'
    let b:git_dir = s:repo().dir()
    call s:ReplaceCmd(s:repo().git_command('cat-file','blob',s:buffer().sha1()))
    return ''
  catch /^fugitive: rev-parse/
    silent exe 'doau BufNewFile '.s:fnameescape(bufname(''))
    return ''
  catch /^fugitive:/
    return 'echoerr v:errmsg'
  endtry
endfunction

function! s:BufWriteIndexFile()
  let tmp = tempname()
  try
    let path = matchstr(expand('<amatch>'),'//\d/\zs.*')
    let stage = matchstr(expand('<amatch>'),'//\zs\d')
    silent execute 'write !'.s:repo().git_command('hash-object','-w','--stdin').' > '.tmp
    let sha1 = readfile(tmp)[0]
    let old_mode = matchstr(s:repo().git_chomp('ls-files','--stage',path),'^\d\+')
    if old_mode == ''
      let old_mode = executable(s:repo().tree(path)) ? '100755' : '100644'
    endif
    let info = old_mode.' '.sha1.' '.stage."\t".path
    call writefile([info],tmp)
    let error = system(s:repo().git_command('update-index','--index-info').' < '.tmp)
    if v:shell_error == 0
      setlocal nomodified
      silent execute 'doautocmd BufWritePost '.s:fnameescape(expand('%:p'))
      call fugitive#reload_status()
      return ''
    else
      return 'echoerr '.string('fugitive: '.error)
    endif
  finally
    call delete(tmp)
  endtry
endfunction

function! s:BufReadObject()
  try
    setlocal noro ma
    let b:git_dir = s:repo().dir()
    let hash = s:buffer().sha1()
    if !exists("b:fugitive_type")
      let b:fugitive_type = s:repo().git_chomp('cat-file','-t',hash)
    endif
    if b:fugitive_type !~# '^\%(tag\|commit\|tree\|blob\)$'
      return "echoerr 'fugitive: unrecognized git type'"
    endif
    let firstline = getline('.')
    if !exists('b:fugitive_display_format') && b:fugitive_type != 'blob'
      let b:fugitive_display_format = +getbufvar('#','fugitive_display_format')
    endif

    let pos = getpos('.')
    silent %delete
    setlocal endofline

    if b:fugitive_type == 'tree'
      let b:fugitive_display_format = b:fugitive_display_format % 2
      if b:fugitive_display_format
        call s:ReplaceCmd(s:repo().git_command('ls-tree',hash))
      else
        call s:ReplaceCmd(s:repo().git_command('show',hash))
      endif
    elseif b:fugitive_type == 'tag'
      let b:fugitive_display_format = b:fugitive_display_format % 2
      if b:fugitive_display_format
        call s:ReplaceCmd(s:repo().git_command('cat-file',b:fugitive_type,hash))
      else
        call s:ReplaceCmd(s:repo().git_command('cat-file','-p',hash))
      endif
    elseif b:fugitive_type == 'commit'
      let b:fugitive_display_format = b:fugitive_display_format % 2
      if b:fugitive_display_format
        call s:ReplaceCmd(s:repo().git_command('cat-file',b:fugitive_type,hash))
      else
        call s:ReplaceCmd(s:repo().git_command('show','--pretty=format:tree %T%nparent %P%nauthor %an <%ae> %ad%ncommitter %cn <%ce> %cd%nencoding %e%n%n%s%n%n%b',hash))
        call search('^parent ')
        silent s/\%(^parent\)\@<! /\rparent /ge
        if search('^encoding \%(<unknown>\)\=$','W',line('.')+3)
          silent delete
        end
        1
      endif
    elseif b:fugitive_type ==# 'blob'
      call s:ReplaceCmd(s:repo().git_command('cat-file',b:fugitive_type,hash))
    endif
    call setpos('.',pos)
    setlocal ro noma nomod nomodeline
    if b:fugitive_type !=# 'blob'
      set filetype=git
      nnoremap <buffer> <silent> a :<C-U>let b:fugitive_display_format += v:count1<Bar>exe <SID>BufReadObject()<CR>
      nnoremap <buffer> <silent> i :<C-U>let b:fugitive_display_format -= v:count1<Bar>exe <SID>BufReadObject()<CR>
    else
      call s:JumpInit()
    endif

    return ''
  catch /^fugitive:/
    return 'echoerr v:errmsg'
  endtry
endfunction

augroup fugitive_files
  autocmd!
  autocmd BufReadCmd  *.git/index                      exe s:BufReadIndex()
  autocmd FileReadCmd fugitive://**//[0-3]/**          exe s:FileRead()
  autocmd BufReadCmd  fugitive://**//[0-3]/**          exe s:BufReadIndexFile()
  autocmd BufWriteCmd fugitive://**//[0-3]/**          exe s:BufWriteIndexFile()
  autocmd BufReadCmd  fugitive://**//[0-9a-f][0-9a-f]* exe s:BufReadObject()
  autocmd FileReadCmd fugitive://**//[0-9a-f][0-9a-f]* exe s:FileRead()
  autocmd FileType git       call s:JumpInit()
augroup END

" }}}1
" Go to file {{{1

function! s:JumpInit() abort
  nnoremap <buffer> <silent> <CR>    :<C-U>exe <SID>GF("edit")<CR>
  if !&modifiable
    nnoremap <buffer> <silent> o     :<C-U>exe <SID>GF("split")<CR>
    nnoremap <buffer> <silent> O     :<C-U>exe <SID>GF("tabedit")<CR>
    nnoremap <buffer> <silent> P     :<C-U>exe <SID>Edit('edit',<SID>buffer().commit().'^'.v:count1.<SID>buffer().path(':'))<CR>
    nnoremap <buffer> <silent> ~     :<C-U>exe <SID>Edit('edit',<SID>buffer().commit().'~'.v:count1.<SID>buffer().path(':'))<CR>
    nnoremap <buffer> <silent> C     :<C-U>exe <SID>Edit('edit',<SID>buffer().containing_commit())<CR>
    nnoremap <buffer> <silent> c     :<C-U>exe <SID>Edit('pedit',<SID>buffer().containing_commit())<CR>
  endif
endfunction

function! s:GF(mode) abort
  try
    let buffer = s:buffer()
    let myhash = buffer.sha1()

    if buffer.type('tree')
      let showtree = (getline(1) =~# '^tree ' && getline(2) == "")
      if showtree && line('.') == 1
        return ""
      elseif showtree && line('.') > 2
        return s:Edit(a:mode,buffer.commit().':'.(buffer.path() == '' ? '' : buffer.path().'/').s:sub(getline('.'),'/$',''))
      elseif getline('.') =~# '^\d\{6\} \l\{3,8\} \x\{40\}\t'
        return s:Edit(a:mode,buffer.commit().':'.(buffer.path() == '' ? '' : buffer.path().'/').s:sub(matchstr(getline('.'),'\t\zs.*'),'/$',''))
      endif

    elseif buffer.type('blob')
      let ref = expand("<cfile>")
      try
        let sha1 = buffer.repo().rev_parse(ref)
      catch /^fugitive:/
      endtry
      if exists('sha1')
        return s:Edit(a:mode,ref)
      endif

    else

      " Index
      if getline('.') =~# '^\d\{6\} \x\{40\} \d\t'
        let ref = matchstr(getline('.'),'\x\{40\}')
        let file = ':'.s:sub(matchstr(getline('.'),'\d\t.*'),'\t',':')
        return s:Edit(a:mode,file)

      elseif getline('.') =~# '^#\trenamed:.* -> '
        let file = '/'.matchstr(getline('.'),' -> \zs.*')
        return s:Edit(a:mode,file)
      elseif getline('.') =~# '^#\t[[:alpha:] ]\+: *.'
        let file = '/'.matchstr(getline('.'),': *\zs.*')
        return s:Edit(a:mode,file)
      elseif getline('.') =~# '^#\t.'
        let file = '/'.matchstr(getline('.'),'#\t\zs.*')
        return s:Edit(a:mode,file)
      elseif getline('.') =~# ': needs merge$'
        let file = '/'.matchstr(getline('.'),'.*\ze: needs merge$')
        return s:Edit(a:mode,file).'|Gdiff'

      elseif getline('.') ==# '# Not currently on any branch.'
        return s:Edit(a:mode,'HEAD')
      elseif getline('.') =~# '^# On branch '
        let file = 'refs/heads/'.getline('.')[12:]
        return s:Edit(a:mode,file)
      elseif getline('.') =~# "^# Your branch .*'"
        let file = 'refs/remotes/'.matchstr(getline('.'),"'\\zs\\S\\+\\ze'")
        return s:Edit(a:mode,file)
      endif

      let showtree = (getline(1) =~# '^tree ' && getline(2) == "")

      if getline('.') =~# '^ref: '
        let ref = strpart(getline('.'),5)

      elseif getline('.') =~# '^parent \x\{40\}\>'
        let ref = matchstr(getline('.'),'\x\{40\}')
        let line = line('.')
        let parent = 0
        while getline(line) =~# '^parent '
          let parent += 1
          let line -= 1
        endwhile
        return s:Edit(a:mode,ref)

      elseif getline('.') =~ '^tree \x\{40\}$'
        let ref = matchstr(getline('.'),'\x\{40\}')
        if s:repo().rev_parse(myhash.':') == ref
          let ref = myhash.':'
        endif
        return s:Edit(a:mode,ref)

      elseif getline('.') =~# '^object \x\{40\}$' && getline(line('.')+1) =~ '^type \%(commit\|tree\|blob\)$'
        let ref = matchstr(getline('.'),'\x\{40\}')
        let type = matchstr(getline(line('.')+1),'type \zs.*')

      elseif getline('.') =~# '^\l\{3,8\} '.myhash.'$'
        return ''

      elseif getline('.') =~# '^\l\{3,8\} \x\{40\}\>'
        let ref = matchstr(getline('.'),'\x\{40\}')
        echoerr "warning: unknown context ".matchstr(getline('.'),'^\l*')

      elseif getline('.') =~# '^[+-]\{3\} [ab/]'
        let ref = getline('.')[4:]

      elseif getline('.') =~# '^rename from '
        let ref = 'a/'.getline('.')[12:]
      elseif getline('.') =~# '^rename to '
        let ref = 'b/'.getline('.')[10:]

      elseif getline('.') =~# '^diff --git \%(a/.*\|/dev/null\) \%(b/.*\|/dev/null\)'
        let dref = matchstr(getline('.'),'\Cdiff --git \zs\%(a/.*\|/dev/null\)\ze \%(b/.*\|/dev/null\)')
        let ref = matchstr(getline('.'),'\Cdiff --git \%(a/.*\|/dev/null\) \zs\%(b/.*\|/dev/null\)')

      elseif line('$') == 1 && getline('.') =~ '^\x\{40\}$'
        let ref = getline('.')
      else
        let ref = ''
      endif

      if myhash ==# ''
        let ref = s:sub(ref,'^a/','HEAD:')
        let ref = s:sub(ref,'^b/',':0:')
        if exists('dref')
          let dref = s:sub(dref,'^a/','HEAD:')
        endif
      else
        let ref = s:sub(ref,'^a/',myhash.'^:')
        let ref = s:sub(ref,'^b/',myhash.':')
        if exists('dref')
          let dref = s:sub(dref,'^a/',myhash.'^:')
        endif
      endif

      if ref == '/dev/null'
        " Empty blob
        let ref = 'e69de29bb2d1d6434b8b29ae775ad8c2e48c5391'
      endif

      if exists('dref')
        return s:Edit(a:mode,ref) . '|Gdiff '.s:fnameescape(dref)
      elseif ref != ""
        return s:Edit(a:mode,ref)
      endif

    endif
    return ''
  catch /^fugitive:/
    return 'echoerr v:errmsg'
  endtry
endfunction

" }}}1

" vim:set ft=vim ts=8 sw=2 sts=2:
