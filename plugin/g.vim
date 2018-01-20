" vim-g - The handy Google lookup for Vim
" Maintainer:   Szymon Wrozynski
" Version:      0.0.6
" Modified By:  Harold Jin
"
" Installation:
" Place in ~/.vim/plugin/g.vim or in case of Pathogen:
"
"   cd ~/.vim/bundle
"   git clone https://github.com/szw/vim-g.git
"
" License:
" Copyright (c) 2012-2014 Szymon Wrozynski and Contributors. Distributed under the same terms as Vim itself.
" See :help license
"
" Usage:
" https://github.com/szw/vim-g/blob/master/README.md
"

" setup - OS types and commands to start googling
if exists("g:loaded_vim_g") || &cp || v:version < 700
  finish
endif

let g:loaded_vim_g = 1

if !exists("g:vim_g_open_command")
  if has("win32")
    let g:vim_g_open_command = "start"
  elseif substitute(system('uname'), "\n", "", "") == 'Darwin'
    let g:vim_g_open_command = "open"
  else
    let g:vim_g_open_command = "xdg-open"
  endif
endif

if !exists("g:vim_g_query_url")
    let g:vim_g_query_url = "http://google.com/search?q="
endif

if !exists("g:vim_g_command")
    let g:vim_g_command = "Google"
endif

if !exists("g:vim_g_f_command")
    let g:vim_g_f_command = g:vim_g_command . "f"
endif

execute "command! -nargs=* -range ". g:vim_g_command  ." :call s:goo('' ,<f-args>)"
execute "command! -nargs=* -range ". g:vim_g_f_command ." :call s:goo(&ft, <f-args>)"

" ft for googling things specific to your file type
fun! s:goo(ft, ...)
    " Checks current position == visual mode start,
    " then return selections need to be made to the end selection
    " else set sel to empty
    let sel = getpos('.') == getpos("'<") ? getline("'<")[getpos("'<")[2] - 1 : getpos("'>")[2] - 1] : ''

    " if initial argument to the function is not provided
    if a:0 == 0
        " set words to be sel from previous visual select if not empty else use
        " the current word under cursor
        let words = [a:ft, empty(sel) ? expand("<cword>") : sel]
    else
        " Join all arguments passed to the function and replace all quotes
        let query = join(a:000, " ")
        " replace all characters that are not \" to count num left.
        let quotes = len(substitute(query, '[^"]', '', 'g'))
        let words = [a:ft, query, sel]
        " ensure the quotes are closed for evaluation
        if quotes > 0 && quotes % 2 != 0
            call add(words, '"')
        endif

        " remove empty value from the list, ex., empty ft or query
        call filter(words, 'len(v:val)')
    endif

    " remove spaces and use less greedy match few possible \{-} front and back
    let query = substitute(join(words, " "), '^\s*\(.\{-}\)\s*$', '\1', '')
    " escape quotes for all quotes
    let query = substitute(query, '"', '\\"', 'g')

    if has('win32')
        silent! execute "! " . g:vim_g_open_command . " \"\" \"" . g:vim_g_query_url  . query . "\""
    else
        " escape urlEncode to ensure % is quoted as \% and surrounded by '' so
        " that vim will not treat all special characters as it is
        " Also assign to goo_query in order for '' to be removed so the search
        " query will be <searchWord> instead of '<searchWord>'
        silent! execute "! goo_query=". shellescape(s:urlEncode(query),1) . " && " . g:vim_g_open_command . ' "' . g:vim_g_query_url . "$goo_query" . '" > /dev/null 2>&1 &'
    endif
    redraw!
endfun


" URL encode a string. ie. Percent-encode characters as necessary.
function! s:urlEncode(string)
    let result = ""
    let characters = split(a:string, '.\zs')
    for character in characters
        if character == " "
            let result = result . "+"
        elseif s:characterRequiresUrlEncoding(character)
            let i = 0
            while i < strlen(character)
                let byte = strpart(character, i, 1)
                let decimal = char2nr(byte)
                let result = result . "%" . printf("%02x", decimal)
                let i += 1
            endwhile
        else
            let result = result . character
        endif
    endfor
    return result
endfunction

" Returns 1 if the given character should be percent-encoded in a URL encoded
" string.
function! s:characterRequiresUrlEncoding(character)
    let ascii_code = char2nr(a:character)
    if ascii_code >= 48 && ascii_code <= 57
        return 0
    elseif ascii_code >= 65 && ascii_code <= 90
        return 0
    elseif ascii_code >= 97 && ascii_code <= 122
        return 0
    elseif a:character == "-" || a:character == "_" || a:character == "." || a:character == "~"
        return 0
    endif
    return 1
endfunction
