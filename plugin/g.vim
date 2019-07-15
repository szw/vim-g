" vim-g - The handy Google lookup for Vim
" Maintainer:   Szymon Wrozynski
" Version:    0.0.6
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

if !exists("g:vim_g_python_command")
  let g:vim_g_python_command = "python3"
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

execute "command! -nargs=* -range ". g:vim_g_command  ." :call s:goo('', <f-args>)"
execute "command! -nargs=* -range ". g:vim_g_f_command ." :call s:goo(&ft, <f-args>)"

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

  if has('win32')
    " Target command: start "" "<url>"
    silent! execute "! " . g:vim_g_open_command . " \"\" \"" . g:vim_g_query_url  . query . "\""
  else
    silent! execute "! goo_query=\"$(" . g:vim_g_python_command .
      \" -c 'import urllib.parse; print(urllib.parse.quote(\"". query."\"))')\" && " .
      \g:vim_g_open_command . ' "' . g:vim_g_query_url . "$goo_query" . '" > /dev/null 2>&1 &'
  endif
  redraw!
endfun
