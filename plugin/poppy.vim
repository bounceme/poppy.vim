if !exists('*matchaddpos') || !has('reltime') || exists('*PoppyInit')
  finish
endif
let g:poppyhigh = get(g:,'poppyhigh',['identifier','constant','preproc','special','type'])

function s:highpat()
  let stoplinebottom = line('w$')
  let stoplinetop = line('w0')
  let s:poppyhigh = deepcopy(g:poppyhigh)
  call searchpair('[[({]','','[]})]','rnbW',"synIDattr(synID(line('.'),col('.'),0),'name') =~? 'regex\\|comment\\|string' || s:endpart(".stoplinebottom.")",stoplinetop,30)
endfunction

function s:endpart(b)
  let idx = index(['[','(','{'],getline('.')[col('.')-1])
  let p = searchpairpos(['\[','(','{'][idx],'','])}'[idx],'nW',"synIDattr(synID(line('.'),col('.'),0),'name') =~? 'regex\\|comment\\|string'"
        \ ,a:b,300)
  if p[0] && line2byte(p[0])+p[1] > line2byte(g:pos[0]) + g:pos[1]
    call s:addm(getpos('.')[1:2])
    call s:addend(p)
  endif
endfunction

function s:addm(p)
  let ak = s:poppyhigh[0]
  call matchaddpos(remove(s:poppyhigh,0),[a:p])
  call extend(s:poppyhigh,[ak])
endfunction
function s:addend(p)
  call matchaddpos(s:poppyhigh[-1],[a:p])
endfunction

function PoppyInit()
  let g:pos = getpos('.')[1:2] | call clearmatches() | call s:highpat()
endfunction
