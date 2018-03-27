if !has('reltime') || exists('*PoppyInit')
  finish
endif
let g:poppyhigh = get(g:,'poppyhigh',['identifier','constant','preproc','special','type'])

function s:highpat()
  let s:synid_cache = {}
  let stoplinebottom = line('w$')
  let stoplinetop = line('w0')
  let s:poppyhigh = deepcopy(g:poppyhigh)
  let inc = get(g:,'poppy_point_enable') && getline('.')[col('.')-1] =~ '[[({]' ? 'c' : ''
  call searchpair('\m[[({]','','noop',inc.(len(g:poppyhigh) > 1 ? 'r' : '').'nbW',"getline('.')[col('.')-1] == 'n' ||"
        \ ."s:SynAt(line('.'),col('.')) =~? 'regex\\|comment\\|string' ||"
        \ ."s:endpart(".stoplinebottom.")",stoplinetop,30)
endfunction

function s:SynAt(l,c)
  let pos = a:l.','.a:c
  if !has_key(s:synid_cache,pos)
    let s:synid_cache[pos] = synIDattr(synID(a:l,a:c,0),'name')
  endif
  return s:synid_cache[pos]
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
  let i = stridx('[({',getline('.')[col('.')-1])
  let p = searchpairpos('\V'.'[({'[i],'','\V'.'])}'[i],'nW',"s:SynAt(line('.'),col('.')) =~? 'regex\\|comment\\|string'"
        \ ,a:b,300)
  if p[0] && (line2byte(p[0])+p[1] > line2byte(s:pos[0]) + s:pos[1] || get(g:,'poppy_point_enable') && p == s:pos)
    let w:poppies += [s:matchadd(remove(add(s:poppyhigh,s:poppyhigh[0]),0), [getpos('.')[1:2],p])]
  else
    return 1
  endif
endfunction

function PoppyInit()
  let s:pos = getpos('.')[1:2] | let w:poppies = get(w:,'poppies',[])
        \ | silent! call filter(w:poppies,'matchdelete(v:val)>0') | call s:highpat()
endfunction
