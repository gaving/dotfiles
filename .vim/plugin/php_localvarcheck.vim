" highlight unused/unassigned local variable
" Last Change:  2009-10-08
" Maintainer:   Yukihiro Nakadaira <yukihiro.nakadaira@gmail.com>
" License:      This file is placed in the public domain.
"
" Options:
"   g:php_localvarcheck_enable (default: 1)
"     If 0, do nothing.
"
"   g:php_localvarcheck_global (default: 0)
"     If 1, global scope code are also highlighted.

if exists("b:did_ftplugin")
  finish
endif

let s:save_cpo = &cpo
set cpo&vim

hi default link PhpLocalVarCheckError Error

if !exists('g:php_localvarcheck_enable')
  let g:php_localvarcheck_enable = 1
endif
if !exists('g:php_localvarcheck_global')
  let g:php_localvarcheck_global = 0
endif

let b:php_localvarcheck_cache_pos = {}
let b:php_localvarcheck_cache_vars = {}
let b:php_localvarcheck_changedtick = 0
let b:php_localvarcheck_global_prev = 0

"let w:php_localvarcheck_matches = []
"let w:php_localvarcheck_start = 0
"let w:php_localvarcheck_end = 0

augroup PhpLocalVarCheck
  au! * <buffer>
  autocmd FileType <buffer> if &ft != 'php' | call s:Uninstall() | endif
  autocmd CursorMoved <buffer> call s:LocalVarCheck()
augroup END

augroup PhpLocalVarCheckW
  au! * <buffer>
  autocmd WinEnter <buffer> if &ft != 'php' | call s:UninstallW() | endif
augroup END

function! s:Uninstall()
  au! PhpLocalVarCheck * <buffer>
  unlet! b:php_localvarcheck_cache_pos
  unlet! b:php_localvarcheck_cache_vars
  unlet! b:php_localvarcheck_changedtick
  unlet! b:php_localvarcheck_global_prev
  call s:UninstallW()
endfunction

function! s:UninstallW()
  if exists('w:php_localvarcheck_matches')
    for id in w:php_localvarcheck_matches
      call matchdelete(id)
    endfor
  endif
  unlet! w:php_localvarcheck_matches
  unlet! w:php_localvarcheck_start
  unlet! w:php_localvarcheck_end
endfunction

function! s:LocalVarCheck()
  if !g:php_localvarcheck_enable
    return
  endif

  if !exists('w:php_localvarcheck_matches')
    let w:php_localvarcheck_matches = []
  endif
  if !exists('w:php_localvarcheck_start')
    let w:php_localvarcheck_start = 0
  endif
  if !exists('w:php_localvarcheck_end')
    let w:php_localvarcheck_end = 0
  endif

  " force refresh
  if g:php_localvarcheck_global != b:php_localvarcheck_global_prev
    let b:php_localvarcheck_changedtick = 0
  endif
  let b:php_localvarcheck_global_prev = g:php_localvarcheck_global

  if !g:php_localvarcheck_global
    if b:php_localvarcheck_changedtick == b:changedtick
          \ && w:php_localvarcheck_start <= line('.')
          \ && w:php_localvarcheck_end >= line('.')
      return
    endif
  endif

  " clear cache
  if b:php_localvarcheck_changedtick != b:changedtick
    let b:php_localvarcheck_cache_pos = {}
    " TODO: memory vs speed
    "let b:php_localvarcheck_cache_vars = {}
  endif

  " find function
  let cache_key = line('.')
  if !has_key(b:php_localvarcheck_cache_pos, cache_key)
    let pos = s:FindFunction()
    if g:php_localvarcheck_global && (pos[0] == 0 || pos[3] == 0 || pos[3] < line('.'))
      let pos = s:FindPhp()
    endif
    let b:php_localvarcheck_cache_pos[cache_key] = pos
  endif
  let [start, startcol, open, end, endcol] = b:php_localvarcheck_cache_pos[cache_key]

  if b:php_localvarcheck_changedtick == b:changedtick
        \ && w:php_localvarcheck_start == start
        \ && w:php_localvarcheck_end == end
        \ && end >= line('.')
    return
  endif

  " clear highlight
  for id in w:php_localvarcheck_matches
    call matchdelete(id)
  endfor
  let w:php_localvarcheck_matches = []

  " set highlight
  if start == 0 || end == 0 || end < line('.')
    let b:php_localvarcheck_changedtick = b:changedtick
    let w:php_localvarcheck_start = 0
    let w:php_localvarcheck_end = 0
  else
    let lines = getline(start, end)
    let lines[-1] = lines[-1][ : endcol - 1]
    let lines[0] = lines[0][startcol - 1 : ]
    let src = join(lines, "\n")

    let cache_key = src
    if !has_key(b:php_localvarcheck_cache_vars, cache_key)
      let b:php_localvarcheck_cache_vars[cache_key] = s:FindBadVariables(src)
    endif
    let vars = b:php_localvarcheck_cache_vars[cache_key]

    for var in vars
      let id = matchadd('PhpLocalVarCheckError', '\V' . escape(var, '\') . '\>')
      call add(w:php_localvarcheck_matches, id)
    endfor

    let b:php_localvarcheck_changedtick = b:changedtick
    let w:php_localvarcheck_start = start
    let w:php_localvarcheck_end = end
  endif
endfunction

function! s:FindFunction()
  let [start, startcol, open, end, endcol] = [0, 0, 0, 0, 0]

  if exists('g:syntax_on')
    let skip = 'synIDattr(synID(line("."), col("."), 0), "name") !~? "phpDefine\\|phpParent"'
  else
    let skip = '0'
  endif

  let view = winsaveview()

  call cursor(line('.'), col('$'))

  let [start, startcol] = searchpos('\c\v<function>', 'bWc')
  while start != 0 && eval(skip)
    let [start, startcol] = searchpos('\c\v<function>', 'bW')
  endwhile

  if start != 0
    let open = search('{', 'W')
    while open != 0 && eval(skip)
      let open = search('{', 'W')
    endwhile
  endif

  if start != 0 && open != 0
    let [end, endcol] = searchpairpos('{', '', '}', 'W', skip)
  endif

  call winrestview(view)

  return [start, startcol, open, end, endcol]
endfunction

function! s:FindPhp()
  let [start, startcol, open, end, endcol] = [0, 0, 0, 0, 0]

  let view = winsaveview()

  call cursor(1, 1)

  if exists('g:php_noShortTags')
    let phpopen = '\c\v\<\?php'
  else
    let phpopen = '\c\v\<\?%(php)?'
  endif
  if exists('g:php_asp_tags')
    let phpopen .= '|\<\%'
  endif

  let [start, startcol] = searchpos(phpopen, 'Wc')
  let [end, endcol] = [line('$'), col([line('$'), '$'])]

  call winrestview(view)

  return [start, startcol, open, end, endcol]
endfunction

function! s:FindBadVariables(src)
  let special = {'$GLOBALS':1,'$_SERVER':1,'$_GET':1,'$_POST':1,'$_REQUEST':1,'$_FILES':1,'$_COOKIE':1,'$_SESSION':1,'$_ENV':1,'$this':1}
  let global = {}
  let assigned = {}
  let used = {}
  let bad = {}
  for [var, is_assign, is_global] in s:Parse(a:src)
    if has_key(special, var)
      continue
    endif
    if is_assign
      let assigned[var] = 1
      " global variable may be used in somewhere else.
      if is_global
        let global[var] = 1
      elseif has_key(global, var)
        let used[var] = 1
      endif
    else
      let used[var] = 1
      if !has_key(assigned, var)
        let bad[var] = 1
      endif
    endif
  endfor
  for var in keys(assigned)
    if !has_key(used, var)
      let bad[var] = 1
    endif
  endfor
  return keys(bad)
endfunction

" @return [['$varname', is_assign, is_global], ...]
function! s:Parse(src)
  if exists('g:php_noShortTags')
    let phpopen = '\<\?php'
    let phpclose = '\?\>'
  else
    let phpopen = '\<\?%(php)?'
    let phpclose = '\?\>'
  endif
  if exists('g:php_asp_tags')
    let phpopen .= '|\<\%'
    let phpclose .= '|\%\>'
  endif
  let pat_syntax  = '\c\v'
        \ . '%(' . phpclose . ').{-}%(' . phpopen . '|$)'
        \ . '|#.{-}%(\n|' . phpclose . ')@='
        \ . '|//.{-}%(\n|' . phpclose . ')@='
        \ . '|/\*.{-}\*/'
        \ . "|'[^']*'"
        \ . '|"%(\\.|[^"])*"'
        \ . '|\<\<\<\s*''?(\w+)''?.{-}\n\1;'
        \ . '|\$\w+'
        \ . '|<as>'
        \ . '|<list>'
        \ . '|<static>'
        \ . '|<global>'
        \ . '|<function>'
        \ . '|<class>'
        \ . '|[;(){}]'
  let items = []
  let i = match(a:src, pat_syntax)
  " parse args
  if a:src =~? '^function'
    while i != -1
      let s = matchstr(a:src, pat_syntax, i)
      if s[0] == ')'
        break
      elseif s[0] == '$'
        call add(items, [s, 1, 0])
        let e = i + len(s)
      else
        let e = i + len(s)
      endif
      let i = match(a:src, pat_syntax, e)
    endwhile
  endif
  " parse body
  while i != -1
    let s = matchstr(a:src, pat_syntax, i)
    if s[0] == '"'
      for var in s:MatchStrAll(s, '\v\\.|\$\w+')
        if var[0] == '$'
          call add(items, [var, 0, 0])
        endif
      endfor
      let e = i + len(s)
    elseif s =~ '^<<<'
      if match(s, '^<<<\s*''') == -1
        for var in s:MatchStrAll(s, '\v\\.|\$\w+')
          if var[0] == '$'
            call add(items, [var, 0, 0])
          endif
        endfor
      endif
      let e = i + len(s)
    elseif s[0] == '$'
      if match(a:src, '^\_s*=[^=>]', i + len(s)) != -1
        call add(items, [s, 1, 0])
      else
        call add(items, [s, 0, 0])
      endif
      let e = i + len(s)
    elseif s ==? 'as'
      let _ = matchlist(a:src, '\c\vas%(\_s|&)*(\$\w+)%(\_s*\=\>%(\_s|&)*(\$\w+))?', i)
      if empty(_)
        " error
        break
      endif
      call add(items, [_[1], 1, 0])
      if _[2] != ''
        call add(items, [_[2], 1, 0])
      endif
      let e = i + len(_[0])
    elseif s ==? 'list'
      let j = match(a:src, pat_syntax, i + len(s))
      while j != -1
        let t = matchstr(a:src, pat_syntax, j)
        if t == ')'
          break
        elseif t[0] == '$'
          call add(items, [t, 1, 0])
        endif
        let j = match(a:src, pat_syntax, j + len(t))
      endwhile
      if j == -1
        " error
        break
      endif
      let e = j
    elseif s ==? 'static'
      let j = match(a:src, pat_syntax, i + len(s))
      while j != -1
        let t = matchstr(a:src, pat_syntax, j)
        if t == ';'
          break
        elseif t[0] == '$'
          call add(items, [t, 1, 0])
        endif
        let j = match(a:src, pat_syntax, j + len(t))
      endwhile
      if j == -1
        " error
        break
      endif
      let e = j
    elseif s ==? 'global'
      let j = match(a:src, pat_syntax, i + len(s))
      while j != -1
        let t = matchstr(a:src, pat_syntax, j)
        if t == ';'
          break
        elseif t[0] == '$'
          call add(items, [t, 1, 1])
        endif
        let j = match(a:src, pat_syntax, j + len(t))
      endwhile
      if j == -1
        " error
        break
      endif
      let e = j
    elseif s ==? 'function' || s ==? 'class'
      " skip function or class
      let j = match(a:src, pat_syntax, i + len(s))
      while j != -1
        let t = matchstr(a:src, pat_syntax, j)
        if t == '{'
          break
        endif
        let j = match(a:src, pat_syntax, j + len(t))
      endwhile
      let level = 0
      while j != -1
        let t = matchstr(a:src, pat_syntax, j)
        if t == '{'
          let level += 1
        elseif t == '}'
          let level -= 1
          if level == 0
            break
          endif
        endif
        let j = match(a:src, pat_syntax, j + len(t))
      endwhile
      if j == -1
        " error
        break
      endif
      let e = j
    else
      let e = i + len(s)
    endif
    let i = match(a:src, pat_syntax, e)
  endwhile
  return items
endfunction

function! s:MatchStrAll(text, pat)
  let matches = []
  call substitute(a:text, a:pat, '\=empty(add(matches, submatch(0)))', 'g')
  return matches
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
