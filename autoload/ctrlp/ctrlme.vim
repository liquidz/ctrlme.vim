if (exists('g:loaded_ctrlp_ctrlme') && g:loaded_ctrlp_ctrlme) || v:version < 700 || &cp
  finish
endif
let g:loaded_ctrlp_ctrlme = 1

let g:ctrlp#ctrlme#range = [0, 0]
let g:ctrlp#ctrlme#keyword = ''

call add(g:ctrlp_ext_vars, {
    \ 'init'     : 'ctrlp#ctrlme#init()',
    \ 'accept'   : 'ctrlp#ctrlme#accept',
    \ 'lname'    : 'ctrlme',
    \ 'sname'    : 'ctrlme',
    \ 'type'     : 'tabs',
    \ 'sort'     : 0,
    \ 'specinput': 0,
    \ })

function! s:link_highlight(from, to) abort
  if !hlexists(a:from)
    exe 'highlight link' a:from a:to
  endif
endfunction

function! s:set_syntax() abort
  call s:link_highlight('CtrlMeTitle', 'Identifier')
  call s:link_highlight('CtrlMeComment', 'Comment')
  syntax match CtrlMeTitle '^> [^\t]\+'
  syntax match CtrlMeComment '\zs\t.*\ze$'
endfunction

function! ctrlp#ctrlme#init() abort
  call s:set_syntax()
  let toml = ctrlme#load_toml(g:ctrlme_toml_file)
  return ctrlme#get_candidates(toml, g:ctrlp#ctrlme#keyword)
endfunction

function! ctrlp#ctrlme#accept(mode, line) abort
  call ctrlp#exit()
  let action = join([
      \ printf('let l:mode = "%s"', a:mode),
      \ printf('let l:from = %d', g:ctrlp#ctrlme#range[0]),
      \ printf('let l:to = %d', g:ctrlp#ctrlme#range[1]),
      \ split(a:line, "\t")[2]
      \ ], "\n")

  "let action = printf("let mode = '%s'\n%s",
  "    \ a:mode,
  "    \ split(a:line, "\t")[2])
  execute action
endfunction

let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)
function! ctrlp#ctrlme#id() abort
  return s:id
endfunction
