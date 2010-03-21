function! s:LongLines()
    let threshold = (&tw ? &tw : 80)
    let spaces = repeat(" ", &ts)

    let long_line_lens = []

    let i = 1
    while i <= line("$")
        let len = strlen(substitute(getline(i), '\t', spaces, 'g'))
        if len > threshold
            call add(long_line_lens, len)
        endif
        let i += 1
    endwhile

    return long_line_lens
endfunction

function! s:Median(nums)
    let nums = sort(a:nums)
    let l = len(nums)

    if l % 2 == 1
        let i = (l-1) / 2
        return nums[i]
    else
        return (nums[l/2] + nums[(l/2)-1]) / 2
    endif
endfunction

function! StatuslineTrailingSpaceWarning()
    if !exists("b:statusline_trailing_space")
        if search('\s\+$', 'nw') != 0
            let b:statusline_trailing_space = '[\s]'
        else
            let b:statusline_trailing_space = ''
        endif
    endif
    return b:statusline_trailing_space
endfunction

function! StatuslineTabWarning()
    if !exists("b:statusline_tab")
        let tabs = search('^\t', 'nw') != 0
        let spaces = search('^ ', 'nw') != 0

        if tabs && spaces
            let b:statusline_tab = '[mixed]'
        elseif (spaces && !&et) || (tabs && &et)
            let b:statusline_tab = '[&et]'
        else
            let b:statusline_tab = ''
        endif
    endif
    return b:statusline_tab
endfunction

function! StatuslineLongLineWarning()
    if !exists("b:statusline_long_line")
        let long_line_lens = s:LongLines()

        if len(long_line_lens) > 0
            let b:statusline_long_line = "[".
                        \ '#'.len(long_line_lens).",".
                        \ 'm'.s:Median(long_line_lens).",".
                        \ '$'.max(long_line_lens)."]"
        else
            let b:statusline_long_line = ""
        endif
    endif
    return b:statusline_long_line
endfunction

function! StatuslineCurrentHighlight()
    let name = synIDattr(synID(line('.'),col('.'),1),'name')
    if name == ''
        return ''
    else
        return '['.name.']'
    endif
endfunction

augroup statusline
    autocmd!
    autocmd CursorHold,BufWritePost * unlet! b:statusline_tab
    autocmd CursorHold,BufWritePost * unlet! b:statusline_long_line
    autocmd CursorHold,BufWritePost * unlet! b:statusline_trailing_space
augroup end
