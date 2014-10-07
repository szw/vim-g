vim-g
=====

**vim-g** is a tiny plugin that allows you to perform a quick Google search directly from Vim. It opens a new
browser window with results. **vim-g** uses Perl for url encoding.


Installation
------------

Place in *~/.vim/plugin/g.vim* or in case of Pathogen:

    cd ~/.vim/bundle
    git clone https://github.com/szw/vim-g.git

Please, don't forget to star the repository if you like (and use) the plugin. This will let me know
how many users it has and then how to proceed with further development :).


Usage
-----

To lookup a word (or words) in Google use `Google` command:

    :Google hello
    :Google start up

`Google` command can use a word under the cursor. Just move the cursor to the word and type the same command in the
command line:

    :Google

Additionally, you can select words in the visual mode exactly in the same way. Just select words and type
`:Google`. You can also prepend your selection with more clues:

    :Google function
    :Google ruby

There is also a special command named `Gf` to prepend the current file type automatically:

    :Googlef
    :Googlef strpos
    :Googlef function

Moreover, you can use double quotes (`"`) to perform [phrase
search](http://support.google.com/websearch/bin/answer.py?hl=en&answer=136861). Just enclose some words
between quotation marks as you type. Also, you don't have to close manually open quotation marks. **vim-g**
will add the missing one itself.

Examples:

    :Google "foo bar"
    :Googlef " help substitute
    :Google foo bar " something else

What's even more interesting this also works in the visual mode. Therefore, you can perform a strict phrase
search on selected words. Just select words and type:

    :Google "
    :Google "foo bar

You may want to quickly go to the first Google result of a search term. Just use `:Googlel` (l stands for *lucky*) :

    :Googlel github

*Note:* Google will perform a regular search if search terms are ambiguous.

Configuration
-------------

There are just a few global variables (options) you may set in the *.vimrc* file.

* `g:vim_g_open_command`

  Sets the command used to open the URL. In case of Ubuntu this would be
  `"xdg-open"`:

        let g:vim_g_open_command = "xdg-open"

* `g:vim_g_perl_command`

  Sets the Perl command. By default it's `"perl"`:

        let g:vim_g_perl_command = "perl"

* `g:vim_g_query_url`

  Sets the query URL. By default it points to Google of course, but you might want to place your favorite
  search engine there:

        let g:vim_g_query_url = "http://google.com/search?q="

* `g:vim_g_command`
  
  Sets the command mapping for vim-g. By default this is Google, but you may want to prefix it to something shorter such as :G or :Go
    
        let g:vim_g_command = "Go"

* `g:vim_g_f_command`

  Sets the command mapping for vim-g's file search function. By default this is Googlef, but you may want to prefix it to something shorter such as :Gf

        let g:vim_g_f_command = "Gf"


License
-------

Copyright &copy; 2012 Szymon Wrozynski and Contributors. Distributed under the same terms as Vim itself.

See `:help license`
