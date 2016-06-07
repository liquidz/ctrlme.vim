"if exists('g:loaded_ctrlp_list')
"  finish
"endif
"let g:loaded_ctrlp_list = 1

let s:save_cpo = &cpo
set cpo&vim

let s:V = vital#of('ctrlme')
let s:FP = s:V.import('System.Filepath')

let g:ctrlme_toml_file = get(g:, 'ctrlme_toml_file', s:FP.join($HOME, '.list.toml'))

command! MyFoo call ctrlp#init(ctrlp#ctrlme#id())
command! -nargs=? -range CtrlMe call ctrlme#open(<line1>, <line2>, <q-args>)

let &cpo = s:save_cpo
unlet s:save_cpo

