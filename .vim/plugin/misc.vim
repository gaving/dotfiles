function! LessMode()
  if g:lessmode == 0
    let g:lessmode = 1
    let onoff = 'on'
    noremap <script> d <C-D>
    noremap <script> j <C-E>
    noremap <script> u <C-U>
    noremap <script> k <C-Y>
    noremap <Space> <C-f>
  else
    let g:lessmode = 0
    let onoff = 'off'
    unmap d
    unmap j
    unmap u
    unmap k
  endif
  echohl Label | echo "Less mode" onoff | echohl None
endfunction
let g:lessmode = 0
command! -nargs=* -bang LessModeToggle :call LessMode()

if has("gui_mac") || has("gui_macvim") || exists("$SECURITYSESSIONID")
    command! -bar -nargs=1 OpenURL :!open <args>
elseif has("gui_win32")
    command! -bar -nargs=1 OpenURL :!start cmd /cstart /b <args>
elseif executable("sensible-browser")
    command! -bar -nargs=1 OpenURL :!sensible-browser <args>
endif

function! HandleURI()
    let s:uri = matchstr(getline("."), '[a-z]*:\/\/[^ >,;:]*')
    echo s:uri
    if s:uri != ""
        exe 'OpenURL '.s:uri
    else
        echo "No URI found in line."
    endif
endfunction

function! Rename(name, bang)
    let l:curfile = expand("%:p")
    let v:errmsg = ""
    silent! exe "saveas" . a:bang . " " . a:name
    if v:errmsg =~# '^$\|^E329'
        if expand("%:p") !=# l:curfile && filewritable(expand("%:p"))
            silent exe "bwipe! " . l:curfile
            if delete(l:curfile)
                echoerr "Could not delete " . l:curfile
            endif
        endif
    else
        echoerr v:errmsg
    endif
endfunction
command! -nargs=* -complete=file -bang Rename :call Rename("<args>", "<bang>")
