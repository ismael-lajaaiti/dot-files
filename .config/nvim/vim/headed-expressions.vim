" dealing with headed expressions and their arguments
" a headed expression is of the form head(arg1,arg2,..) or with []
" you can act from inside with - or , or from before with -- or ,,
" repeat a letter (orelse) to act on [] and keep it single for ()
" Parametrize all this so it better adapts to either language:
"   - repeated (bool) to define the repeated version.
"   - wrappers (left and right) to define whether it's (), [], {} etc.
"   - head_isk to alter the &iskeyword option while working on the head.
"   - modifier like "<buffer>" or "".
function! DefineHeadedMappings(repeated, w_l, w_r, head_isk, modifier)
  " To restore isk after the operation.
  let additional_isk=""
  if a:head_isk != ""
    let additional_isk="',".a:head_isk."'"
  endif
  let get_isk=":let isk_safe_from_headed_operation=&isk<cr>"
  let alter_isk=":let &isk=&isk.".additional_isk."<cr>"
  let reset_isk=":let &isk=isk_safe_from_headed_operation<cr>"
  let macros = [
        \ ["type", "map", "repeated map", "macro", "comment"],
        \ ["nmap",     "-hi" , "-hhi" , "<Plug>ExtendedFtSearchFForward".a:w_l."l" ,  0, "Head inside."],
        \ ["nmap",     "--hi", "--hhi", "<Plug>ExtendedFtSearchFBackward".a:w_r."%l", 0, "Head inside from after."],
        \ ["nnoremap", "-ho",  "-hho",  "va".a:w_r."ovbb",                            1, "Get out to the head (head out)."],
        \ ["nmap",     "--ho", "--hho", "<Plug>ExtendedFtSearchFBackward".a:w_r."%b", 1, "Head out from after."],
        \ ["nmap",     "-ha",  "-hha",  "vi".a:w_r."vh%l",                            0, "Head after from inside."],
        \ ["nmap",     "--ha", "--hha", "<Plug>ExtendedFtSearchFForward".a:w_l."%l",  0, "Head after from before."],
        \ ["nnoremap", "-ch",  "-cch",  "vi".a:w_r."ovbbcw",                          2, "Change head."],
        \ ["nmap",     "--ch", "--cch", "f".a:w_l."l<R>",                             0, "Change head from before."],
        \ ["nnoremap", "-kh",  "-kkh",  "va".a:w_r."<esc>`>x`<vbd",                   1, "Kill head (behead)."],
        \ ["nmap",     "--kh", "--kkh", "f".a:w_l."l<R>",                             0, "Kill head from before."],
        \ ["vmap",     "-ah",  "-aah",  "<Plug>VSurround".a:w_r."gvovi",              0, "Add head (selection)."],
        \ ["nmap",     "-ah",  "-aah",  "viw<R>",                                     2, "Add head (word)."],
        \ ["nnoremap", "-ar",  "-aar",  "vi".a:w_r."va,<space>",                      0, "Append argument."],
        \ ["nnoremap", ",sh",  ",ssh",  "va".a:w_r."ob",                              2, "Select whole expression."],
        \ ["nmap",     ",,sh", ",,ssh", "<Plug>ExtendedFtSearchFForward".a:w_l."l<R>",0, "Select whole expression from before."],
        \ ["end"]
        \ ]
  let macros = macros[1:-2]
  let last_map = "" " Useful to recycle macros.
  for macro in macros
      let type = macro[0]
      if a:repeated
        let map = macro[2]
      else
        let map = macro[1]
      endif
      let cmd = substitute(macro[3], "<R>", last_map, "")
      if macro[4] && a:head_isk != ""
        if macro[4] == 2 " Special-case commands ending in insert mode.
          let cmd = get_isk.alter_isk.cmd.'<C-O>'.reset_isk
        else
          let cmd = get_isk.alter_isk.cmd.reset_isk
        endif
      endif
      exec type." ".a:modifier." ".map." ".cmd
      let last_map = map
  endfor
endfunction
" we're gonna need to forget about this small feature:
noremap <buffer> - <nop>
" Defaults for every file.
call DefineHeadedMappings(0, "(", ")", "", "")
call DefineHeadedMappings(1, "[", "]", "", "")
" A few more ones about arguments.
nnoremap ,sa :call SelectArgument(0)<CR>o
vnoremap ,sa <esc>:call SelectArgument(0)<CR>
" kill the argument
nnoremap -ka :call SelectArgument(1)<CR>d
vnoremap -ka <esc>:call SelectArgument(1)<CR>d
" change the argument
nnoremap -ca :call SelectArgument(0)<CR>c<space>
vnoremap -ca <esc>:call SelectArgument(0)<CR>c<space>
" navigate to the previous/next argument
nnoremap <M-l> :call NextArgument(1)<CR>
vnoremap <M-l> :<bs><bs><bs><bs><bs>:call NextArgument(1)<CR>
nnoremap <M-h> :call NextArgument(0)<CR>
vnoremap <M-h> :<bs><bs><bs><bs><bs>:call NextArgument(0)<CR>
