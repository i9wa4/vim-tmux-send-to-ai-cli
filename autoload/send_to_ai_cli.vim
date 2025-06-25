function! send_to_ai_cli#send_yanked() abort
  let l:text = getreg('*')
  if empty(l:text)
    echo "No yanked text found in * register"
    return
  endif

  call s:send_text_to_ai_cli(l:text)
  echo "Sent yanked text to AI CLI"
endfunction

function! send_to_ai_cli#send_buffer() abort
  let l:text = join(getline(1, '
), "\n")
  if empty(l:text)
    echo "Buffer is empty"
    return
  endif

  call s:send_text_to_ai_cli(l:text)
  echo "Sent entire buffer to AI CLI"
endfunction

function! send_to_ai_cli#send_range() range abort
  let l:text = join(getline(a:firstline, a:lastline), "\n")
  if empty(l:text)
    echo "Selected range is empty"
    return
  endif

  call s:send_text_to_ai_cli(l:text)
  echo "Sent selected range to AI CLI"
endfunction

function! send_to_ai_cli#send_visual() abort
  let l:save_reg = getreg('"')
  let l:save_regtype = getregtype('"')

  normal! gvy
  let l:text = getreg('"')

  call setreg('"', l:save_reg, l:save_regtype)

  if empty(l:text)
    echo "No text selected"
    return
  endif

  call s:send_text_to_ai_cli(l:text)
  echo "Sent visual selection to AI CLI"
endfunction

function! s:send_text_to_ai_cli(text) abort
  let l:target = s:find_ai_cli_pane()
  if empty(l:target)
    echo "AI CLI pane not found in current window"
    return
  endif

  let l:lines = split(a:text, '\n')
  for l:line in l:lines
    let l:cmd = 'tmux send-keys -t ' . l:target . ' -- ' . shellescape(l:line)
    call system(l:cmd)
    if l:line != l:lines[-1]
      call system('tmux send-keys -t ' . l:target . ' C-j')
    endif
  endfor

  let l:enter_cmd = 'tmux send-keys -t ' . l:target . ' Enter'
  call system(l:enter_cmd)
endfunction

function! s:find_ai_cli_pane() abort
  let l:process_names = get(g:, 'ai_cli_process_names', ['claude', 'gemini'])
  let l:grep_pattern = join(l:process_names, '\|')

  let l:panes_output = system('tmux list-panes -F "#{pane_id} #{pane_pid}"')
  let l:panes = split(l:panes_output, '\n')

  for l:pane in l:panes
    let l:parts = split(l:pane)
    let l:pane_id = l:parts[0]
    let l:pid = l:parts[1]

    let l:ps_output = system('ps -ef | grep -E "' . l:pid . '" | grep -E "' . l:grep_pattern . '" | grep -v grep')
    if !empty(l:ps_output)
      return l:pane_id
    endif
  endfor

  return get(g:, 'ai_cli_target', '')
endfunction
