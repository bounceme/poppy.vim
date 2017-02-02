if !has('reltime') || exists('*PoppyInit')
  finish
endif
let g:poppyhigh = get(g:,'poppyhigh',['identifier','constant','preproc','special','type'])
let s:matches = []

function s:highpat()
  let stoplinebottom = line('w$')
  let stoplinetop = line('w0')
  let s:poppyhigh = deepcopy(g:poppyhigh)
  call searchpair('[[({]','','[]})]','rnbW',"getline('.')[col('.')-1] =~ '[]})]' ||"
        \ ."synIDattr(synID(line('.'),col('.'),0),'name') =~? 'regex\\|comment\\|string' ||"
        \ ."s:endpart(".stoplinebottom.")",stoplinetop,30)
endfunction

if exists('*matchaddpos')
  function s:matchadd(hi,pos)
    return matchaddpos(a:hi,a:pos)
  endfunction
else
  function s:matchadd(hi,pos)
    return matchadd(a:hi,'\%' . a:pos[0][0] . 'l\%' . a:pos[0][1] . 'c\|\%' . a:pos[1][0] . 'l\%' . a:pos[1][1] . 'c')
  endfunction
endif

function s:endpart(b)
  let idx = stridx('[({',getline('.')[col('.')-1])
  let p = searchpairpos(['\[','(','{'][idx],'','])}'[idx],'nW',"synIDattr(synID(line('.'),col('.'),0),'name') =~? 'regex\\|comment\\|string'"
        \ ,a:b,300)
  if p[0] && line2byte(p[0])+p[1] > line2byte(g:pos[0]) + g:pos[1]
    call s:addm(getpos('.')[1:2],p)
  else
    return 1
  endif
endfunction

function s:addm(p,e)
  let ak = s:poppyhigh[0]
  call add(s:matches,s:matchadd(remove(s:poppyhigh,0),[a:p,a:e]))
  call add(s:poppyhigh,ak)
endfunction

function PoppyInit()
  let g:pos = getpos('.')[1:2] | silent! call filter(s:matches,'matchdelete(v:val)>0') | call s:highpat()
endfunction
