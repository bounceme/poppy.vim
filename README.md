# poppy.vim
vim port of [highlightparentheses.el](https://github.com/tsdh/highlight-parentheses.el) which gives rainbow parens propagating from the cursor

Enabled with autocmds ( :h autocommand )

example:

`au! cursormoved * call PoppyInit()`

or:

`au! cursormoved *.lisp call PoppyInit()`

or even make a mapping:

```
augroup Poppy
  au!
augroup END
nnoremap <silent> <leader>hp :call clearmatches() \| let g:poppy = -get(g:,'poppy',-1) \|
      \ exe 'au! Poppy CursorMoved *' . (g:poppy > 0 ? ' call PoppyInit()' : '') <cr>
```

modify coloring by changing `g:poppyhigh`, which is a list of highlight group names.
