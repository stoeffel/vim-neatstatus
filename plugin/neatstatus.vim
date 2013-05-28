" NeatStatus (c) 2012 Lukasz Grzegorz Maciak
"
" Based on a script by Tomas Restrepo (winterdom.com)
" " Original available here:
" http://winterdom.com/2007/06/vimstatusline

set ls=2 " Always show status line
let g:last_mode=""



" SOLARIZED HEX     16/8 TERMCOL  XTERM/HEX   L*A*B      sRGB        HSB
" --------- ------- ---- -------  ----------- ---------- ----------- -----------
" base03    #002b36  8/4 brblack  234 #1c1c1c 15 -12 -12   0  43  54 193 100  21
" base02    #073642  0/4 black    235 #262626 20 -12 -12   7  54  66 192  90  26
" base01    #586e75 10/7 brgreen  240 #4e4e4e 45 -07 -07  88 110 117 194  25  46
" base00    #657b83 11/7 bryellow 241 #585858 50 -07 -07 101 123 131 195  23  51
" base0     #839496 12/6 brblue   244 #808080 60 -06 -03 131 148 150 186  13  59
" base1     #93a1a1 14/4 brcyan   245 #8a8a8a 65 -05 -02 147 161 161 180   9  63
" base2     #eee8d5  7/7 white    254 #d7d7af 92 -00  10 238 232 213  44  11  93
" base3     #fdf6e3 15/7 brwhite  230 #ffffd7 97  00  10 253 246 227  44  10  99
" yellow    #b58900  3/3 yellow   136 #af8700 60  10  65 181 137   0  45 100  71
" orange    #cb4b16  9/3 brred    166 #d75f00 50  50  55 203  75  22  18  89  80
" red       #dc322f  1/1 red      160 #d70000 50  65  45 220  50  47   1  79  86
" magenta   #d33682  5/5 magenta  125 #af005f 50  65 -05 211  54 130 331  74  83
" violet    #6c71c4 13/5 brmagenta 61 #5f5faf 50  15 -45 108 113 196 237  45  77
" blue      #268bd2  4/4 blue      33 #0087ff 55 -10 -45  38 139 210 205  82  82
" cyan      #2aa198  6/6 cyan      37 #00afaf 60 -35 -05  42 161 152 175  74  63
" green     #859900  2/2 green     64 #5f8700 60 -20  65 133 153   0  68 100  60


" pretty mode display - converts the one letter status notifiers to words
function! Mode()
    let l:mode = mode()

    if     mode ==# "n"  | return "NORMAL "
    elseif mode ==# "i"  | return "INSERT "
    elseif mode ==# "R"  | return "REPLACE"
    elseif mode ==# "v"  | return "VISUAL "
    elseif mode ==# "V"  | return "V-LINE "
    elseif mode ==# "^V" | return "V-BLOCK"
    elseif mode ==# "c"  | return "SEARCH "
    else                 | return l:mode
    endif

endfunc    

" Change the values for User1 color preset depending on mode
function! ModeChanged(mode)

    if     a:mode ==# "n"  | hi User1 guifg=#002b36 guibg=#859900 gui=NONE ctermfg=234 ctermbg=64 cterm=NONE
    elseif a:mode ==# "i"  | hi User1 guifg=#eee8d5 guibg=#cb4b16 gui=NONE ctermfg=254 ctermbg=166 cterm=NONE
    elseif a:mode ==# "R"  | hi User1 guifg=#eee8d5 guibg=#dc322f gui=NONE ctermfg=190 ctermbg=37 cterm=NONE
    elseif a:mode ==# "v"  | hi User1 guifg=#002b36 guibg=#b58900 gui=NONE ctermfg=254 ctermbg=160
    elseif a:mode ==# "V"  | hi User1 guifg=#002b36 guibg=#b58900 gui=NONE ctermfg=254 ctermbg=160
    elseif a:mode ==# "^V" | hi User1 guifg=#002b36 guibg=#b58900 gui=NONE ctermfg=254 ctermbg=160
    elseif a:mode ==# "c"  | hi User1 guifg=#002b36 guibg=#d33682 gui=NONE ctermfg=190 ctermbg=37 cterm=NONE
    else                   | hi User1 guifg=#002b36 guibg=#d33682 gui=NONE ctermfg=254 ctermbg=160 cterm=NONE
    endif

    if     a:mode ==# "n"  | hi User2 guifg=#859900 guibg=#073642 ctermfg=64 
    elseif a:mode ==# "i"  | hi User2 guifg=#cb4b16 guibg=#073642 ctermfg=166 
    elseif a:mode ==# "R"  | hi User2 guifg=#dc322f guibg=#073642 ctermfg=37 
    elseif a:mode ==# "v"  | hi User2 guifg=#b58900 guibg=#073642 ctermfg=160
    elseif a:mode ==# "V"  | hi User2 guifg=#b58900 guibg=#073642 ctermfg=160
    elseif a:mode ==# "^V" | hi User2 guifg=#b58900 guibg=#073642 ctermfg=160
    elseif a:mode ==# "c"  | hi User2 guifg=#d33682 guibg=#073642 ctermfg=37 cterm=NONE
    else                   | hi User2 guifg=#d33682 guibg=#073642 ctermfg=160 cterm=NONE
    endif
endfunc

" Return a string if file is modified or empty string if its not
function! Modified()
    let l:modified = &modified

    if modified == 0
        return ''
    else
        return '⚡'
endfunc


if has('statusline')

    " Status line detail:
    "
    " %f    file name
    " %F    file path
    " %y    file type between braces (if defined)
    "
    " %{v:servername}   server/session name (gvim only)
    "
    " %<    collapse to the left if window is to small
    "
    " %( %) display contents only if not empty
    "
    " %1*   use color preset User1 from this point on (use %0* to reset)
    "
    " %([%R%M]%)   read-only, modified and modifiable flags between braces
    "
    " %{'!'[&ff=='default_file_format']}
    "        shows a '!' if the file format is not the platform default
    "
    " %{'$'[!&list]}  shows a '*' if in list mode
    " %{'~'[&pm=='']} shows a '~' if in patchmode
    "
    " %=     right-align following items
    "
    " %{&fileencoding}  displays encoding (like utf8)
    " %{&fileformat}    displays file format (unix, dos, etc..)
    " %{&filetype}      displays file type (vim, python, etc..)
    "
    " #%n   buffer number
    " %l/%L line number, total number of lines
    " %p%   percentage of file
    " %c%V  column number, absolute column number
    "
    function! SetStatusLineStyle()
        " Basic color presets
        hi User1 guifg=#002b36  guibg=#859900   ctermfg=234  ctermbg=64    
        hi User2 guifg=#859900  guibg=#073642 ctermfg=64    
        hi User3 guifg=#eee8d5  guibg=#cb4b16   ctermfg=254 ctermbg=166 
        hi User4 guifg=#eee8d5  guibg=#dc322f   ctermfg=254 ctermbg=160 
        hi User5 guifg=#eee8d5  guibg=#002b36   ctermfg=254 ctermbg=234
        hi User6 guifg=#cb4b16  guibg=#073642 ctermfg=254 ctermbg=166 gui=bold cterm=bold   
        hi User7 guifg=#eee8d5  guibg=#073642   ctermfg=207 ctermbg=234
        hi User8 guifg=#268bd2  guibg=#073642 ctermfg=234 ctermbg=230

        let &stl=""
        " modified / unmodified (purple)
        let &stl.="%(%4* %{Modified()} %)%0*"
        " mode (changes color)
        let &stl.="%1*\ %{Mode()} %0*" 
        let &stl.="%2*⮀%0*" 
        " file path
        let &stl.="%7* %{getcwd()} %0*"
        " file name
        let &stl.="%6* %<%f "
        " read only, modifiable flags in brackets
        let &stl.="%([%R]%) "

        " right-aligh everything past this point
        let &stl.="%= "


        " readonly flag
        let &stl.="%(%{(&ro!=0?'(readonly)':'')} | %)"

        let &stl.="%8*%{fugitive#statusline()} %0*" 
        " file type (eg. python, ruby, etc..)
        let &stl.="%2*%( %{&filetype} %) | "
        " file format (eg. unix, dos, etc..)
        let &stl.="%{&fileformat} | "
        " file encoding (eg. utf8, latin1, etc..)
        let &stl.="%(%{(&fenc!=''?&fenc:&enc)}  %)"
        " buffer number
        let &stl.="BUF #%n " 
        "line number (pink) / total lines
        let &stl.="%2* LN %l/%L\  "
        " percentage done
        let &stl.="(%p%%)  "
        
    endfunc

    au InsertEnter * call ModeChanged(v:insertmode)
    au InsertChange * call ModeChanged(v:insertmode)
    au InsertLeave * call ModeChanged(mode())

    " Switch between the normal and vim-debug modes in the status line
    nmap _ds :call SetStatusLineStyle()<CR>
    call SetStatusLineStyle()
    " Window title
    if has('title')
        set titlestring=%t%(\ [%R%M]%)
    endif
endif
