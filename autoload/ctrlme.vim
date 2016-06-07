let s:save_cpo = &cpo
set cpo&vim

let s:V = vital#of('ctrlme')
let s:FP = s:V.import('System.Filepath')
let s:_  = s:V.import('Underscore').import()
let s:TOML = s:V.import('Text.TOML')

function! ctrlme#load_toml(toml_file) abort
  return s:TOML.parse_file(a:toml_file)
endfunction

function! ctrlme#get_candidates(toml, keyword) abort
  if a:keyword == ''
    let keywords = keys(a:toml)
  else
    let keywords = [a:keyword]
  endif

  let res = []
  for key in keywords
    for dict in a:toml[key]
      let line = printf("%s\t[%s]\t%s", dict['name'], key, dict['action'])
      call add(res, line)
    endfor
  endfor

  return res
endfunction

function! ctrlme#open(from, to, arg) abort
  let g:ctrlp#ctrlme#range = [0, 0]
  if a:from != a:to
    let g:ctrlp#ctrlme#range = [a:from, a:to]
  endif
  let g:ctrlp#ctrlme#keyword = a:arg

  echo printf("[%s]", a:arg)
  
  call ctrlp#init(ctrlp#ctrlme#id())
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
