let s:save_cpo = &cpo
set cpo&vim

let s:quicklearn = {}
let s:source = {
      \ 'name': 'quicklearn',
      \ }
let s:quicklearn['c/clang/intermediate'] = {
      \ 'command': 'clang',
      \ 'exec': [
      \   '%c %o %s -S -emit-llvm -o %s:p:r.ll',
      \   'cat %s:p:r.ll %a',
      \   'rm -f %s:p:r.ll'],
      \ 'tempfile': '%{tempname()}.c'}
let s:quicklearn['c/gcc/intermediate'] = {
      \ 'command': 'gcc',
      \ 'exec': [
      \   '%c %o %s -S -o %s:p:r.s',
      \   'cat %s:p:r.s %a',
      \   'rm -f %s:p:r.s'],
      \ 'tempfile': '%{tempname()}.c'}
let s:quicklearn['haskell/ghc/intermediate'] = {
      \ 'command': 'ghc',
      \ 'exec': [
      \   '%c %o -ddump-simpl -dsuppress-coercions %s',
      \   'rm %s:p:r %s:p:r.o %s:p:r.hi'],
      \ 'cmdopt': '-v0 --make',
      \ 'tempfile': '%{tempname()}.hs'}
let s:quicklearn['coffee/intermediate'] = {
      \ 'command': 'coffee',
      \ 'exec': ['%c %o -s %s %a'],
      \ 'tempfile': '%{tempname()}.hs'}
let s:quicklearn['ruby/intermediate'] = {
      \ 'command': 'ruby',
      \ 'exec': ['%c %o %s %a'],
      \ 'cmdopt': '--dump=insns',
      \ 'tempfile': '%{tempname()}.rb'}

for k in keys(s:quicklearn)
  let v = s:quicklearn[k]
  let s:quicklearn[k].quickrun_command = printf(
        \ 'QuickRun -command %s %s -cmdopt %s',
        \ string(get(v, 'command', '')),
        \ join(map(get(v, 'exec', ''), '"-exec " . string(v:val)'), ' '),
        \ string(get(v, 'cmdopt', '')))
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
        \ "action__type": ": ",
        \ }'))
endfunction

let &cpo = s:save_cpo
