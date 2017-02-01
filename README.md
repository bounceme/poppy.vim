# poppy.vim
vim port of highlightparentheses.el which gives rainbow parens propagating from the cursor

Enable like:
`au! cursorhold * call PoppyInit()`
`au! cursormoved * call PoppyInit()`

modify highlight groups by changing `g:poppyhigh`, which is a list of highlight group names
