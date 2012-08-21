" vim-g - The handy Google lookup for Vim
" Maintainer:   Szymon Wrozynski
" Version:      0.0.1
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

command! -nargs=? G :call s:goo("<args>")
command! -nargs=0 -range Gs :call s:goo(getline("'<")[getpos("'<")[2] - 1:getpos("'>")[2] - 1])

fun! s:goo(...)
    let query = a:0 > 0 ? a:1 : ""
    if empty(query)
        let query = expand("<cword>")
    endif
    let query = substitute(tolower(query), '^\s*\(.\{-}\)\s*$', '\1', '')
    silent! exe "! goo_query=\"$(" . g:vim_g_perl_command .
                \" -MURI::Escape -e 'print uri_escape($ARGV[0]);' \"" . query . "\")\" && " .
                \g:vim_g_open_command . " " . g:vim_g_query_url . "$goo_query" | redraw!
endfun
