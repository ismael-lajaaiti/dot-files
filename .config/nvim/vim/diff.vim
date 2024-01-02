" switch between windows (ctrl+h,l, u and d because j and k don't work..)
" Only set locally if there are several windows, right?
function! SetWindowNavigation()
  if winnr('$') > 1
    nnoremap <buffer> <space>k :wincmd k<cr>:echo expand('%')<cr>
    nnoremap <buffer> <space>j :wincmd j<cr>:echo expand('%')<cr>
    nnoremap <buffer> <space>h :wincmd h<cr>:echo expand('%')<cr>
    nnoremap <buffer> <space>l :wincmd l<cr>:echo expand('%')<cr>
    vmap <buffer> <space>k <esc><tab>K
    vmap <buffer> <space>j <esc><tab>J
    vmap <buffer> <space>h <esc><tab>H
    vmap <buffer> <space>l <esc><tab>L
  else
    " Unmap to get <space> snappy again.k
    silent! nunmap <buffer> <space>k
    silent! nunmap <buffer> <space>j
    silent! nunmap <buffer> <space>h
    silent! nunmap <buffer> <space>l
    silent! vunmap <buffer> <space>k
    silent! vunmap <buffer> <space>j
    silent! vunmap <buffer> <space>h
    silent! vunmap <buffer> <space>l
  end
endfunction
autocmd BufEnter * call SetWindowNavigation()

" https://www.reddit.com/r/vim/comments/cn20tv/tip_histogrambased_diffs_using_modern_vim/
set diffopt=internal,vertical,filler,indent-heuristic,algorithm:histogram
set noreadonly

" Switch algorithm on-the fly.
function! DiffSwitchAlgorithm()
  let roll = ["myers", "minimal", "patience", "histogram"]
  let n = len(roll)
  " Check which one is currently in use.
  let current = split(&diffopt, ':')[1]
  let i = index(roll, current)
  let next = roll[(i + 1) % n]
  exec "set diffopt-=algorithm:".current
  exec "set diffopt+=algorithm:".next
  echo "Switched to diff algorithm: ".next."."
  diffupdate
endfunction

function! ToggleDiffHighlight()
  if &diff
    diffoff
  else
    windo silent diffthis
  endif
endfunction

" For use anywhere in vim config.
function! IsMergeMode()
  " Make it persistent through diff filtering.
  let g:merge_mode = get(g:, 'merge_mode', 0) || (&diff && winnr('$') == 4)
  return g:merge_mode
endfunction

" Transition from all vertical splits to a square layout.
"  (2) LOCAL | (4) FINAL   (<- buffer numbers)  1|3
" ------------------------                      -|-
"  (1) BASE  | (3) REMOTE  (window numbers ->)  2|4
" Called from git merge command in git config.
function! VerticalToSquareMergeLayout()
  q
  q
  split
  wincmd b
  split
  wincmd t
  b 2
  wincmd l
  b 4
  wincmd j
  b 3
  wincmd h
  b 1
  windo diffthis | setlocal nofoldenable |
                 \ setlocal foldcolumn=0 |
                 \ setlocal signcolumn=no
endfunction
" Find winnrs relatively to one another in this layout, given hljk direction.
function! OtherWindowInMergeLayout(win, dir)
  if a:win == 1 && a:dir == 'j'
    return 2
  elseif a:win == 1 && a:dir == 'l'
    return 3
  elseif a:win == 2 && a:dir == 'k'
    return 1
  elseif a:win == 2 && a:dir == 'l'
    return 4
  elseif a:win == 3 && a:dir == 'h'
    return 1
  elseif a:win == 3 && a:dir == 'j'
    return 4
  elseif a:win == 4 && a:dir == 'k'
    return 3
  elseif a:win == 4 && a:dir == 'h'
    return 2
  else
    throw "No other window in this direction."
  endif
endfunction

" Jump to the next diff against one particular buffer/window.
" This uses :diffoff to ignore other diffs.
function! OnlyDiffAgainst(dir)
  " Retrieve windows ids.
  let curwin = winnr()
  let owin = OtherWindowInMergeLayout(curwin, a:dir)
  let curwin = win_getid(curwin)
  let owin = win_getid(owin)
  " Turn diff off for everyone.
  noautocmd windo diffoff
  " Turn it back on for concerned ones.
  let cmd = "diffthis | setlocal nofoldenable | setlocal foldcolumn=0"
  noautocmd call win_execute(owin, cmd)
  noautocmd call win_execute(curwin, cmd)
  " Return back to original window.
  noautocmd call win_gotoid(curwin)
endfunction
" Reset from above and diff all windows again.
function! DiffAll()
  let curwin = win_getid(winnr())
  let curpos = getcurpos()
  noautocmd windo diffthis | setlocal nofoldenable | setlocal foldcolumn=0
  noautocmd call win_gotoid(curwin)
  call setpos('.', curpos)
endfunction

function! DiffBufEnter()
    if &diff
      setlocal nofoldenable
      setlocal foldcolumn=0
      setlocal signcolumn=no
    endif
    call SetWindowNavigation()
    nnoremap <buffer> ,Dt :call ToggleDiffHighlight()<cr>
    nnoremap <buffer> ,ds :call DiffSwitchAlgorithm()<cr>
    nnoremap <buffer> ,du :diffupdate<cr>
    if IsMergeMode()
      " Current lines with directions.
      for dir in ['h', 'l', 'j', 'k']
        exec "vnoremap <buffer> DG".dir
              \." :<home>exec \"<end>diffget <c-r>=winbufnr(OtherWindowInMergeLayout(winnr(), '".dir."'))<cr>\"<cr>"
        exec "vnoremap <buffer> DP".dir
              \." :<home>exec \"<end>diffput <c-r>=winbufnr(OtherWindowInMergeLayout(winnr(), '".dir."'))<cr>\"<cr>"
        exec "nmap <buffer> DG".dir." VDG".dir
        exec "nmap <buffer> DP".dir." VDP".dir
      endfor
    else
      " The other line.
      vnoremap <buffer> DP :diffput<cr>
      vnoremap <buffer> DG :diffget<cr>
      nmap <buffer> DP VDP
      nmap <buffer> DG VDG
    endif
    " Next/previous chunk
    nnoremap <buffer> ,dn ]c
    nnoremap <buffer> ,dp [c

    " Filter only diffs against buffer..
    nnoremap <buffer> <leader>dfl :call OnlyDiffAgainst('l')<cr>
    nnoremap <buffer> <leader>dfh :call OnlyDiffAgainst('h')<cr>
    nnoremap <buffer> <leader>dfj :call OnlyDiffAgainst('j')<cr>
    nnoremap <buffer> <leader>dfk :call OnlyDiffAgainst('k')<cr>
    " Start diffing all buffers again (then back to mark ')
    nnoremap <buffer> ,da :call DiffAll()<cr>

endfunction

function! DiffEnter()

  call DiffBufEnter()

  augroup DiffPrintFilename
    autocmd!
    autocmd BufEnter * call DiffBufEnter()
  augroup end

endfunction

autocmd VimEnter * windo call DiffEnter()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" On the track of this "force lines alignment" feature..
" https://github.com/neovim/neovim/issues/17207
" https://github.com/neovim/neovim/issues/17210
" https://github.com/vim/vim/issues/9641

" set diffexpr=->v:lua.MyDiff

lua <<EOF
function buffer_to_string(bufnr)
    local content = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    return table.concat(content, "\n")
end

function has_value(tb, val)
  for _, v in ipairs(tb) do
    if v == val then
      return true
    end
  end
  return false
end

function extract_value_from_prefix(tb, prefix)
  for _, v in ipairs(tb) do
    for v in string.gmatch(v, prefix..":(%w+)") do
      return v
    end
  end
  return nil
end

function MyDiff(bufnr_in, bufnr_new)
  local a_file = buffer_to_string(bufnr_in)
  local b_file = buffer_to_string(bufnr_new)

  local opt = vim.opt.diffopt:get()
  local copy_opt = {
    result_type = "indices",
    ignore_whitespace = has_value(opt, "iwhite"),
    ignore_whitespace_change = has_value(opt, "iwhiteall"),
    ignore_whitespace_change_at_eol = has_value(opt, "iwhiteeol"),
    ignore_blank_lines = has_value(opt, "iblank"),
    indent_heuristic = has_value(opt, "indent-heuristic"),
    algorithm = extract_value_from_prefix(opt, "algorithm"),
    ctxlen = tonumber(extract_value_from_prefix(opt, "context")),
  }
  local chunks = vim.diff(a_file, b_file, copy_opt)
  return {{2, 0, 3, 6}}
  -- return chunks
end
EOF

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

