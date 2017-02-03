# poppy.vim
vim port of [highlightparentheses.el](https://github.com/tsdh/highlight-parentheses.el) which gives rainbow parens propagating from the cursor

Enabled with autocmds ( :h autocommand )

example:

`au! cursormoved * call PoppyInit()`

or:

`au! cursormoved *.lisp call PoppyInit()`

modify coloring by changing `g:poppyhigh`, which is a list of highlight group names.
