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
  let l:text = join(getline(1, '$'), "\n")
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

function! send_to_ai_cli#send_current_line() abort
  let l:text = getline('.')
  if empty(l:text)
    echo "Current line is empty"
    return
  endif

  call s:send_text_to_ai_cli(l:text)
  echo "Sent current line to AI CLI"
endfunction

function! send_to_ai_cli#send_paragraph() abort
  let l:save_pos = getpos('.')
  
  " Find paragraph boundaries
  let l:start_line = search('^\s*$', 'bnW') + 1
  if l:start_line == 1 && getline(1) =~ '^\s*$'
    let l:start_line = search('^\S', 'nW')
  endif
  if l:start_line == 0
    let l:start_line = 1
  endif
  
  let l:end_line = search('^$\|^\s*$', 'nW') - 1
  if l:end_line < 0
    let l:end_line = line('$')
  endif
  
  " Make sure we include the current line
  if l:start_line > line('.')
    let l:start_line = line('.')
  endif
  if l:end_line < line('.')
    let l:end_line = line('.')
  endif
  
  let l:text = join(getline(l:start_line, l:end_line), "\n")
  
  call setpos('.', l:save_pos)
  
  if empty(l:text)
    echo "No paragraph found"
    return
  endif

  call s:send_text_to_ai_cli(l:text)
  echo "Sent current paragraph to AI CLI"
endfunction

function! s:send_text_to_ai_cli(text) abort
  let l:target = s:find_ai_cli_pane()
  if empty(l:target)
    echo "AI CLI pane not found in current session"
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

function! s:get_tmux_pane_map(tmux_flags) abort
  let l:cmd = 'tmux list-panes ' . a:tmux_flags . ' -F "#{pane_pid} #{pane_id}"'
  let l:panes_output = system(l:cmd)
  let l:pane_map = {}
  for l:line in split(l:panes_output, "\n")
    let l:parts = split(l:line)
    if len(l:parts) >= 2
      let l:pane_map[l:parts[0]] = l:parts[1]
    endif
  endfor
  return l:pane_map
endfunction

function! s:find_ai_cli_in_panes(pane_map, ps_output, process_names) abort
  for l:line in split(a:ps_output, "\n")
    let l:found_process = 0
    for l:name in a:process_names
      if l:line =~# l:name && l:line !~# 'grep'
        let l:found_process = 1
        break
      endif
    endfor

    if l:found_process
      let l:parts = split(l:line)
      if len(l:parts) >= 1
        let l:ppid = l:parts[0]
        if has_key(a:pane_map, l:ppid)
          return a:pane_map[l:ppid]
        endif
      endif
    endif
  endfor
  return ''
endfunction

function! s:find_ai_cli_pane() abort
  " Get process info once for both searches
  let l:ps_output = system('ps -ax -o ppid,command')
  let l:process_names = get(g:, 'ai_cli_process_names', ['claude', 'gemini'])

  " First, try to find in current window
  let l:pane_map = s:get_tmux_pane_map('')
  let l:result = s:find_ai_cli_in_panes(l:pane_map, l:ps_output, l:process_names)
  if !empty(l:result)
    return l:result
  endif

  " If not found in current window, search in entire session
  let l:pane_map = s:get_tmux_pane_map('-s')
  if empty(l:pane_map)
    return get(g:, 'ai_cli_target', '')
  endif
  
  let l:result = s:find_ai_cli_in_panes(l:pane_map, l:ps_output, l:process_names)
  if !empty(l:result)
    return l:result
  endif

  return get(g:, 'ai_cli_target', '')
endfunction