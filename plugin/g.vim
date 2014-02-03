" vim-g - The handy Google lookup for Vim
" Maintainer:   Szymon Wrozynski
" Version:      0.0.6
"
" Installation:
" Place in ~/.vim/plugin/g.vim or in case of Pathogen:
"
"     cd ~/.vim/bundle
"     git clone https://github.com/szw/vim-g.git
"
" License:
" Copyright (c) 2012 Szymon Wrozynski. Distributed under the same terms as Vim itself.
" See :help license
"
" Usage:
" https://github.com/szw/vim-g/blob/master/README.md
"

if exists("g:loaded_vim_g") || &cp || v:version < 700
    finish
endif

let g:loaded_vim_g = 1

if !exists("g:vim_g_open_command")
    if substitute(system('uname'), "\n", "", "") == 'Darwin'
        let g:vim_g_open_command = "open"
    else
        let g:vim_g_open_command = "xdg-open"
    endif
endif

if !exists("g:vim_g_perl_command")
    let g:vim_g_perl_command = "perl"
endif

if !exists("g:vim_g_query_url")
    let g:vim_g_query_url = "http://google.com/search?q="
endif

command! -nargs=* -range G :call s:goo('', <f-args>)
command! -nargs=* -range Gf :call s:goo(&ft, <f-args>)

fun! g#Goo(text)
    call s:goo('', a:text)
endfun

fun! s:goo(ft, ...)
    let sel = getpos('.') == getpos("'<") ? getline("'<")[getpos("'<")[2] - 1:getpos("'>")[2] - 1] : ''

    if a:0 == 0
        let words = [a:ft, empty(sel) ? expand("<cword>") : sel]
    else
        let query = join(a:000, " ")
        let quotes = len(substitute(query, '[^"]', '', 'g'))
        let words = [a:ft, query, sel]

        if quotes > 0 && quotes % 2 != 0
            call add(words, '"')
        endif

        call filter(words, 'len(v:val)')
    endif

    let query = substitute(join(words, " "), '^\s*\(.\{-}\)\s*$', '\1', '')
    let query = substitute(query, '"', '\\"', 'g')

    let lines = [g:vim_g_perl_command, g:vim_g_open_command, g:vim_g_query_url, query]

    call writefile(lines, expand("~/vim-g-debug.txt"))

    silent! exe "! goo_query=\"$(" . g:vim_g_perl_command .
                \" -MURI::Escape -e 'print uri_escape($ARGV[0]);' \"" . query . "\")\" && " .
                \g:vim_g_open_command . ' "' . g:vim_g_query_url . "$goo_query" . '" >> ~/vim-g-debug.txt 2>&1 &' | redraw!
endfun
