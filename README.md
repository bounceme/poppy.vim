# poppy.vim
vim port of highlightparentheses.el which gives rainbow parens propagating from the cursor

Enable like:
`au! cursormoved * call PoppyInit()`

or:
`au! cursormoved *.lisp call PoppyInit()`

modify coloring by changing `g:poppyhigh`, which is a list of highlight group names.
