" Change the color scheme from a list of color
" sch/Volumes/WD/Sandbox/upstream/server.js
" Version 2008-11-02 from http://vim.wikia.com/wiki/VimTip341
" Set the list of color schemes used by the above (default is 'all'):
"   :SetColors all              (all $VIMRUNTIME/colors/*.vim)
"   :SetColors blue slate ron   (these schemes)
"   :SetColors                  (display current scheme names)
if v:version < 700 || exists('loaded_setcolors') || &cp
    finish
endif
let loaded_setcolors = 1
let s:mycolors = []  " colorscheme names that we use to set color

" Set list of color scheme names that we will use, except
" argument 'now' actually changes the current color scheme.
function! s:SetColors(args)
    if len(a:args) == 0
        echo 'Current color scheme names:'
        let i = 0
        while i < len(s:mycolors)
            echo '  '.join(map(s:mycolors[i : i+4], 'printf("%-14s", v:val)'))
            let i += 5
        endwhile
    elseif a:args == 'all'
        let paths = split(globpath(&runtimepath, 'colors/*.vim'), "\n")
        let s:mycolors = map(paths, 'fnamemodify(v:val, ":t:r")')
    else
        let s:mycolors = split(a:args)
        "echo 'List of colors set from argument (space-separated names)'
    endif
endfunction
command! -nargs=* SetColors call <SID>SetColors('<args>')

" Set next/previous/random (how = 1/-1/0) color from our list of colors.
" The 'random' index is actually set from the current time in seconds.
" Global (no 's:') so can easily call from command line.
function! NextColor(how)
    if len(s:mycolors) == 0
        call s:SetColors('all')
    endif
    if exists('g:colors_name')
        let current = index(s:mycolors, g:colors_name)
    else
        let current = -1
    endif
    let missing = []
    let how = a:how
    for i in range(len(s:mycolors))
        if how == 0
            let current = localtime() % len(s:mycolors)
            let how = 1  " in case random color does not exist
        else
            let current += how
            if !(0 <= current && current < len(s:mycolors))
                let current = (how>0 ? 0 : len(s:mycolors)-1)
            endif
        endif
        try
            execute 'colorscheme '.s:mycolors[current]
            break
        catch /E185:/
            call add(missing, s:mycolors[current])
        endtry
    endfor
    redraw
    if len(missing) > 0
        echo 'Error: colorscheme not found:' join(missing)
    endif
    if exists('g:colors_name')
        echo g:colors_name
    endif
endfunction
