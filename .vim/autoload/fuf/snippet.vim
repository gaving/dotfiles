"=============================================================================
" Copyright (c) 2009 Gavin Gilmour
"
"=============================================================================
" LOAD GUARD {{{1

if exists('g:loaded_autoload_fuf_snippet') || v:version < 702
  finish
endif
let g:loaded_autoload_fuf_snippet = 1

" }}}1
"=============================================================================
" GLOBAL FUNCTIONS {{{1

"
function fuf#snippet#createHandler(base)
  return a:base.concretize(copy(s:handler))
endfunction

"
function fuf#snippet#getSwitchOrder()
  return g:fuf_snippet_switchOrder
endfunction

"
function fuf#snippet#renewCache()
endfunction

"
function fuf#snippet#requiresOnCommandPre()
  return 0
endfunction

"
function fuf#snippet#onInit()
  call fuf#defineLaunchCommand('FufSnippet', s:MODE_NAME, '""')
endfunction

" }}}1
"=============================================================================
" LOCAL FUNCTIONS/VARIABLES {{{1

let s:MODE_NAME = expand('<sfile>:t:r')

"
function s:openSnippet(snippet)
  exec "normal i" . a:snippet . "\<c-r>=TriggerSnippet()\<CR>"
endfunction

"
function s:fetchSnippets(filetype)
  let items = ReturnSnippets(a:filetype)
  if empty(items)
    call fuf#echoWithHl('No snippets found for this filetype', 'WarningMsg')
    return []
  endif
  let items = fuf#unique(items)
  let items = map(items, 'fuf#makeNonPathItem(v:val, "")')
  call fuf#mapToSetSerialIndex(items, 1)
  let items = map(items, 'fuf#setAbbrWithFormattedWord(v:val, 1)')
  return items
endfunction

"
function s:enumSnippets(filetype)
  let snippets = s:fetchSnippets(a:filetype)
  return snippets
endfunction

"
function s:getMatchingIndex(lines, cmd)
  if a:cmd !~# '\D'
    return str2nr(a:cmd)
  endif
  let pattern = matchstr(a:cmd, '^\/\^\zs.*\ze\$\/$')
  if empty(pattern)
    return -1
  endif
  for i in range(len(a:lines))
    if a:lines[i] ==# pattern
      return i
    endif
  endfor
  return -1
endfunction

" }}}1
"=============================================================================
" s:handler {{{1

let s:handler = {}

"
function s:handler.getModeName()
  return s:MODE_NAME
endfunction

"
function s:handler.getPrompt()
  return fuf#formatPrompt(g:fuf_snippet_prompt, self.partialMatching)
endfunction

"
function s:handler.getPreviewHeight()
  return g:fuf_previewHeight
endfunction

"
function s:handler.targetsPath()
  return 0
endfunction

"
function s:handler.makePatternSet(patternBase)
  return fuf#makePatternSet(a:patternBase, 's:interpretPrimaryPatternForNonPath',
        \                   self.partialMatching)
endfunction

function s:handler.makePreviewLines(word, count)
  let snippets = self.snippets
  if empty(snippets)
    return []
  endif
  " let i = a:count % len(snippets)
  " let title = printf('(%d/%d) %s', i + 1, len(snippets), snippets[i].filename)
  let lines = "hello"
  " let index = s:getMatchingIndex(lines, snippets[i].cmd)
  return fuf#makePreviewLinesAround(
        \ lines, 10, a:count, self.getPreviewHeight())
endfunction

"
function s:handler.getCompleteItems(patternPrimary)
  return self.snippets
endfunction

"
function s:handler.onOpen(word, mode)
  call s:openSnippet(a:word)
endfunction

"
function s:handler.onModeEnterPre()
  let bufprev = getbufvar(self.bufNrPrev, '&ft')
  let self.snippets = s:enumSnippets(bufprev)
endfunction

"
function s:handler.onModeEnterPost()
endfunction

"
function s:handler.onModeLeavePost(opened)
endfunction

" }}}1
"=============================================================================
" vim: set fdm=marker
