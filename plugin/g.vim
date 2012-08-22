" vim-g - The handy Google lookup for Vim
" Maintainer:   Szymon Wrozynski
" Version:      0.0.2
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
    let g:vim_g_open_command = "xdg-open"
endif

if !exists("g:vim_g_perl_command")
    let g:vim_g_perl_command = "perl"
endif

if !exists("g:vim_g_query_url")
    let g:vim_g_query_url = "http://google.com/search?q="
endif

command! -nargs=? -range G :call s:goo('', "<args>")
command! -nargs=? -range Gf :call s:goo(&ft, "<args>")

fun! s:goo(ft, query)
    if getpos('.') == getpos("'<")
        let sel = getline("'<")[getpos("'<")[2] - 1:getpos("'>")[2] - 1]
    else
        let sel = ''
    endif

    if empty(a:query)
        if empty(sel)
            let words = [a:ft, expand("<cword>")]
        else
            let words = [a:ft, sel]
        end
    else
        let words = [a:ft, a:query, sel]
    endif

    let query = substitute(join(words, " "), '^\s*\(.\{-}\)\s*$', '\1', '')

    silent! exe "! goo_query=\"$(" . g:vim_g_perl_command .
                \" -MURI::Escape -e 'print uri_escape($ARGV[0]);' \"" . query . "\")\" && " .
                \g:vim_g_open_command . " " . g:vim_g_query_url . "$goo_query" | redraw!

endfun
