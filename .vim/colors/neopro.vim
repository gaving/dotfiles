" Vim color file
" Name:       neopro.vim
" Maintainer: Brian Wigginton <brian wigginton @ gmail dot com>
" Homepage:   http://github.com/bawigga/vim-neopro

set background=dark
hi clear
if exists("syntax_on")
   syntax reset
endif

let colors_name = "neopro"

if has("gui_running")

    hi Normal         gui=NONE   guifg=#ffffff   guibg=#000000
    hi CursorLine     guibg=#2F314D

    hi IncSearch      gui=BOLD   guifg=#ffffff   guibg=NONE
    hi Search         gui=NONE   guifg=#ffffff   guibg=NONE
    hi ErrorMsg       gui=BOLD   guifg=#FE0058   guibg=#3C1616
    hi WarningMsg     gui=BOLD   guifg=#FF9907   guibg=NONE
    hi ModeMsg        gui=BOLD   guifg=#00FF00   guibg=NONE
    hi MoreMsg        gui=BOLD   guifg=#ffffff   guibg=NONE
    hi Question       gui=BOLD   guifg=#ffffff   guibg=NONE

    hi StatusLine     gui=BOLD   guifg=#888888   guibg=#222222
    hi User1          gui=BOLD   guifg=#ffffff   guibg=NONE
    hi User2          gui=BOLD   guifg=#ffffff   guibg=NONE
    hi StatusLineNC   gui=NONE   guifg=#666666   guibg=#222222
    hi VertSplit      gui=NONE   guifg=#666666   guibg=#222222

    hi WildMenu       gui=BOLD   guifg=#ffffff   guibg=NONE

    hi MBENormal                 guifg=#ffffff   guibg=NONE
    hi MBEChanged                guifg=#ffffff   guibg=NONE
    hi MBEVisibleNormal          guifg=#ffffff   guibg=NONE
    hi MBEVisibleChanged         guifg=#ffffff   guibg=NONE

    hi DiffText       gui=NONE   guifg=#ffffff   guibg=NONE
    hi DiffChange     gui=NONE   guifg=#ffffff   guibg=NONE
    hi DiffDelete     gui=NONE   guifg=#ffffff   guibg=NONE
    hi DiffAdd        gui=NONE   guifg=#ffffff   guibg=NONE

    hi Cursor         gui=NONE   guifg=#000000   guibg=#00ff00
    hi lCursor        gui=NONE   guifg=#000000   guibg=#00ff00
    hi CursorIM       gui=NONE   guifg=#000000   guibg=#00ff00

    hi Folded         gui=NONE   guifg=#ffffff   guibg=NONE
    hi FoldColumn     gui=NONE   guifg=#ffffff   guibg=NONE

    hi Directory      gui=NONE   guifg=#ffffff   guibg=NONE
    hi LineNr         gui=NONE   guifg=#666666   guibg=#222222
    hi NonText        gui=BOLD   guifg=#666666   guibg=#111111
    hi SpecialKey     gui=BOLD   guifg=#ffffff   guibg=NONE
    hi Title          gui=BOLD   guifg=#ffffff   guibg=NONE
    hi Visual         gui=NONE   guifg=#EEEED3   guibg=#544D8C

    hi Boolean        gui=NONE   guifg=#0094FF   guibg=NONE
    hi Comment        gui=NONE   guifg=#555555   guibg=NONE
    hi Constant       gui=NONE   guifg=#3EF3FF   guibg=#00363F
    hi Conditional    gui=NONE   guifg=#85B2FE   guibg=#1C3644
    hi Function       gui=NONE   guifg=#FF00BF   guibg=#3B0025
    hi String         gui=NONE   guifg=#8FD4FF   guibg=#02162F
    hi Error          gui=NONE   guifg=#FE0058   guibg=#330000
    hi Identifier     gui=NONE   guifg=#85B2FE   guibg=#1C3644
    hi Ignore         gui=NONE
    hi Keyword        gui=NONE   guifg=#ffffff   guibg=NONE
    hi Label          gui=NONE   guifg=#9FFD39   guibg=#33570F
    hi Number         gui=NONE   guifg=#FBFFA1   guibg=NONE
    hi PreProc        gui=NONE   guifg=#DFC7FF   guibg=#2F0065
    hi Special        gui=NONE   guifg=#9A69FC   guibg=#321F57
    hi SpecialChar    gui=NONE   guifg=#ffffff   guibg=NONE
    hi Statement      gui=NONE   guifg=#ffffff   guibg=NONE
    hi Todo           gui=BOLD   guifg=#FFD570   guibg=#FF5F00
    hi Type           gui=NONE   guifg=#FF00BF   guibg=#3B0025
    hi Underlined     gui=BOLD   guifg=#ffffff   guibg=NONE
    hi TaglistTagName gui=BOLD   guifg=#ffffff   guibg=NONE

    " PERL
    hi perlSpecialMatch   gui=NONE   guifg=#ffffff   guibg=NONE
    hi perlSpecialString  gui=NONE   guifg=#ffffff   guibg=NONE

    " JavaScript
    hi link javaScriptLabel Label
    hi link javaScriptThis Number

    " HTML
    hi htmlStatement      gui=NONE   guifg=#FF00BF   guibg=#3B0025
    hi htmlTag            gui=NONE   guifg=#ffffff   guibg=NONE

    " CSS
    hi link cssBraces      Normal
    hi link cssIdentifier  Label
    hi link cssClassName   Label
    hi link cssTagName     Function
    hi link cssBoxProp     Special
    hi link cssFontRender  Special
    hi link cssFontProp    Special
    hi link cssTextProp    Special
    hi link cssColorProp   Special
    hi link cssRenderProp  Special
    hi link cssgeneratedContentProp  Special
    hi link cssCommonAttr  WarningMsg
    hi link cssRenderAttr  WarningMsg
    hi link cssBoxAttr     WarningMsg

    " C
    hi cSpecialCharacter  gui=NONE   guifg=#ffffff   guibg=NONE
    hi cFormat            gui=NONE   guifg=#ffffff   guibg=NONE

    " Vim Interface
    hi SignColumn         gui=NONE   guifg=#666666   guibg=#222222

    " NERDTree
    hi Directory          gui=NONE   guifg=#85B2FE   guibg=#1C3644

    " vim
    hi link vimCommand    Special
    hi link vimGroup      WarningMsg

    if v:version >= 700
        hi Pmenu          gui=NONE   guifg=#ffffff   guibg=#222222
        hi PmenuSel       gui=BOLD   guifg=#ffffff   guibg=#666666
        hi PmenuSbar      gui=BOLD   guifg=#00ff00   guibg=#222222
        hi PmenuThumb     gui=BOLD   guifg=#ffffff   guibg=#222222

        hi SpellBad     gui=undercurl guisp=#cc6666
        hi SpellRare    gui=undercurl guisp=#cc66cc
        hi SpellLocal   gui=undercurl guisp=#cccc66
        hi SpellCap     gui=undercurl guisp=#66cccc

        hi MatchParen     gui=NONE   guifg=#FF00FF   guibg=#4A0000
    endif
endif

" vim: set et :
