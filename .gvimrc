" .gvimrc configuration

" Window size
set lines=60
set columns=100
set mousemodel=popup

" No menu, and no toolbar or scrollbars
set guioptions-=m
set guioptions-=T
set guioptions-=l
set guioptions-=L
set guioptions-=r
set guioptions-=R

" Customised tab labels
set guitablabel=%N\ %m\ %t

if has("gui_win32")
    " set guifont=Andale_Mono:h8:cRUSSIAN
    " set guifont=Lucida_Console:h10:cRUSSIAN
    " set guifont=Lucida_Sans_Typewriter:h8:cRUSSIAN
    " set guifont=Courier_New:h10:cDEFAULT
    set guifont=DejaVu_Sans_Mono:h10:cRUSSIAN
    " set guifont=Liberation_Mono:h10:cRUSSIAN
    set lines=67 columns=100
elseif has("gui_macvim")
    "set guifont=cattleless
    set guifont=Monaco:h12.00
endif
