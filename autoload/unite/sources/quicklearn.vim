let s:save_cpo = &cpo
set cpo&vim

" fmap([a, b, c], f) => [f(a), f(b), f(c)]
" fmap(a, f) => [f(a)]
function! s:fmap(xs, f)
  if type(a:xs) == type([])
    return map(a:xs, a:f)
  else
    return map([a:xs], a:f)
  endif
endfunction

let g:quicklearn_gcc_remote_url = get(g:, 'quicklearn_gcc_remote_url', 'localhost')

let s:quicklearn = {}
let s:source = {
      \ 'name': 'quicklearn',
      \ }
let s:quicklearn['c/clang/intermediate'] = {
      \ 'meta': {
      \   'parent': 'c/clang'},
      \ 'exec': '%c %o %s -S -emit-llvm -o -'}
let s:quicklearn['c/clang-O3/intermediate'] = {
      \ 'meta': {
      \   'parent': 'c/clang'},
      \ 'cmdopt': '-O3',
      \ 'exec': '%c %o %s -S -emit-llvm -o -'}
let s:quicklearn['cpp/clang/intermediate'] = {
      \ 'meta': {
      \   'parent': 'cpp/clang++'},
      \ 'exec': '%c %o %s -S -emit-llvm -o -'}
let s:quicklearn['cpp/clang-O3/intermediate'] = {
      \ 'meta': {
      \   'parent': 'cpp/clang++'},
      \ 'cmdopt': '-O3',
      \ 'exec': '%c %o %s -S -emit-llvm -o -'}
let s:quicklearn['c/gcc/intermediate'] = {
      \ 'meta': {
      \   'parent': 'c/gcc'},
      \ 'exec': '%c %o %s -S -o -'}
let s:quicklearn['c/gcc-32/intermediate'] = {
      \ 'meta': {
      \   'parent': 'c/gcc'},
      \ 'cmdopt': '-m32',
      \ 'exec': '%c %o %s -S -o -'}
let s:quicklearn['c/gcc-remote/intermediate'] = {
      \ 'meta': {
      \   'parent': 'c/gcc'},
      \ 'exec': 'ssh ' . g:quicklearn_gcc_remote_url . ' %c %o %s -S -o -'}
let s:quicklearn['haskell/ghc/intermediate'] = {
      \ 'meta': {
      \   'parent': 'haskell/ghc'},
      \ 'exec': [
      \   '%c %o -ddump-simpl -dsuppress-coercions %s',
      \   'rm %s:p:r %s:p:r.o %s:p:r.hi'],
      \ 'cmdopt': '-v0 --make'}
let s:quicklearn['coffee/intermediate'] = {
      \ 'meta': {
      \   'parent': '_'},
      \ 'exec': ['%c %o -cbp %s %a']}
let s:quicklearn['ruby/intermediate'] = {
      \ 'meta': {
      \   'parent': 'ruby'},
      \ 'cmdopt': '--dump=insns'}

" inheritance
for s:k in keys(s:quicklearn)
  let s:v = s:quicklearn[s:k]
  for item in ['command', 'exec', 'cmdopt', 'tempfile', 'eval_template']
    let ofParent = get(g:quickrun#default_config[s:v.meta.parent], item)
    if type(ofParent) != type(0) || ofParent != 0
      let s:quicklearn[s:k][item] = get(s:v, item, ofParent)
    endif
    unlet ofParent
  endfor
  unlet! s:k s:v
endfor

" build quickrun command
for s:k in keys(s:quicklearn)
  let s:v = s:quicklearn[s:k]
  let s:quicklearn[s:k].quickrun_command = printf(
        \ 'QuickRun %s %s %s -cmdopt %s',
        \ s:v.meta.parent == '_' ? '' : '-type ' . s:v.meta.parent,
        \ get(s:v, 'command') ? '-command ' . string(s:v.command) : '',
        \ join(s:fmap(get(s:v, 'exec', []), '"-exec " . string(v:val)'), ' '),
        \ string(get(s:v, 'cmdopt', '')))
  unlet! s:k s:v
endfor
lockvar s:quicklearn

function! unite#sources#quicklearn#define()
  return s:source
endfunction

function! s:source.gather_candidates(args, context)
  let configs = filter(copy(s:quicklearn), 'v:key =~ "^" . &filetype . "/"')

  return values(map(configs, '{
        \ "word": substitute(v:key, "/intermediate$", "", ""),
        \ "source": s:source.name,
        \ "kind": ["command"],
        \ "action__command": v:val.quickrun_command,
        \ }'))
        "\ "action__type": ": ",
endfunction

let &cpo = s:save_cpo
