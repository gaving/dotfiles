" grex - Operate on lines matched to the last search pattern (:g/re/x)
" Version: 0.0.1
" Copyright (C) 2009 kana <http://whileimautomaton.net/>
" License: MIT license  {{{
"     Permission is hereby granted, free of charge, to any person obtaining
"     a copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
"
"     The above copyright notice and this permission notice shall be included
"     in all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}
" Interface  "{{{1
function! grex#delete(...) range  "{{{2
  let register = 1 <= a:0 ? a:1 : '"'

  let original_cursor_position = getpos('.')
    let [original_U_content, original_U_type] = [@", getregtype('"')]
    let [original_g_content, original_g_type] = [@g, getregtype('g')]
      let @g = ''
      silent execute a:firstline  ',' a:lastline 'global//delete G'
      let _ = @g[1:]
    call setreg('g', original_g_content, original_g_type)
    call setreg('"', original_U_content, original_U_type)
  call setpos('.', original_cursor_position)

  call setreg(register, _)

  echo len(split(@", '\n')) 'lines greded'
endfunction




function! grex#operator_delete(motion_wise)  "{{{2
  '[,']call grex#delete(v:register)
endfunction




function! grex#operator_yank(motion_wise)  "{{{2
  '[,']call grex#yank(v:register)
endfunction




function! grex#yank(...) range  "{{{2
  let register = 1 <= a:0 ? a:1 : '"'

  let original_cursor_position = getpos('.')
    let [original_U_content, original_U_type] = [@", getregtype('"')]
    let [original_g_content, original_g_type] = [@g, getregtype('g')]
      let @g = ''
      silent execute a:firstline  ',' a:lastline 'global//yank G'
      let _ = @g[1:]
    call setreg('g', original_g_content, original_g_type)
    call setreg('"', original_U_content, original_U_type)
  call setpos('.', original_cursor_position)

  call setreg(register, _)

  echo len(split(@0, '\n')) 'lines greyed'
endfunction








" __END__  "{{{1
" vim: foldmethod=marker
