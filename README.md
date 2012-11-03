vim-g
=====

**vim-g** is a tiny plugin that allows you to perform a quick Google search directly from Vim. It opens a new
browser window with results. **vim-g** uses Perl for url encoding.


Installation
------------

Place in *~/.vim/plugin/g.vim* or in case of Pathogen:

    cd ~/.vim/bundle
    git clone https://github.com/szw/vim-g.git


Usage
-----

To lookup a word (or words) in Google use `G` command:

    :G hello
    :G start up

`G` command can use a word under the cursor. Just move the cursor to the word and type the same command in the
command line:

    :G

Additionally, you can select words in the visual mode exactly in the same way. Just select words and type
`:G`. You can also prepend your selection with more clues:

    :G function
    :G ruby

There is also a special command named `Gf` to prepend the current file type automatically:

    :Gf
    :Gf strpos
    :Gf function

Moreover, you can use double quotes (`"`) to perform [phrase
search](http://support.google.com/websearch/bin/answer.py?hl=en&answer=136861). Just enclose some words
between quotation marks as you type. Also, you don't have to close manually open quotation marks. **vim-g**
will add the missing one itself.

Examples:

    :G "foo bar"
    :Gf " help substitute
    :G foo bar " something else

What's even more interesting this also works in the visual mode. Therefore, you can perform a strict phrase
search on selected words. Just select words and type:

    :G "
    :G "foo bar


Configuration
-------------

There are just a few global variables (options) you may set in the *.vimrc* file.

* `g:vim_g_open_command`

  Sets the command used to open the URL. In case of Ubuntu this could be
  `"xdg-open"` and that is the default value:

        let g:vim_g_open_command = "xdg-open"

* `g:vim_g_perl_command`

  Sets the Perl command. By default it's `"perl"`:

        let g:vim_g_perl_command = "perl"

* `g:vim_g_query_url`

  Sets the query URL. By default it points to Google of course, but you might want to place your favorite
  search engine there:

        let g:vim_g_query_url = "http://google.com/search?q="


License
-------

Copyright &copy; 2012 Szymon Wrozynski. Distributed under the same terms as Vim itself.

See `:help license`
