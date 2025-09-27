" Default supported AI CLI processes
" NOTE: 'copilot' matches both GitHub Copilot CLI and other copilot commands
let s:DEFAULT_AI_CLIS = ['claude', 'codex', 'copilot', 'gemini']

function! tmux_send_to_ai_cli#send_buffer(...) abort
  let l:text = join(getline(1, '$'), "\n")
  if empty(l:text)
    echo "Buffer is empty"
    return
  endif

  let l:count = a:0 >= 1 ? a:1 : 0
  let l:explicit = a:0 >= 2 ? a:2 : 0
  call s:send_text_to_ai_cli(l:text, l:count, l:explicit, 'entire buffer')
endfunction

function! tmux_send_to_ai_cli#send_range(...) range abort
  let l:text = join(getline(a:firstline, a:lastline), "\n")
  if empty(l:text)
    echo "Selected range is empty"
    return
  endif

  let l:count = a:0 >= 1 ? a:1 : 0
  let l:explicit = a:0 >= 2 ? a:2 : 0
  call s:send_text_to_ai_cli(l:text, l:count, l:explicit, 'selected range')
endfunction

function! tmux_send_to_ai_cli#send_visual(...) abort
  let l:save_reg = getreg('"')
  let l:save_regtype = getregtype('"')

  normal! gv""y
  let l:text = getreg('"')

  call setreg('"', l:save_reg, l:save_regtype)

  if empty(l:text)
    echo "No text selected"
    return
  endif

  let l:count = a:0 >= 1 ? a:1 : 0
  let l:explicit = a:0 >= 2 ? a:2 : 0
  call s:send_text_to_ai_cli(l:text, l:count, l:explicit, 'visual selection')
endfunction

function! tmux_send_to_ai_cli#send_current_line(...) abort
  let l:text = getline('.')
  if empty(l:text)
    echo "Current line is empty"
    return
  endif

  let l:count = a:0 >= 1 ? a:1 : 0
  let l:explicit = a:0 >= 2 ? a:2 : 0
  call s:send_text_to_ai_cli(l:text, l:count, l:explicit, 'current line')
endfunction

function! tmux_send_to_ai_cli#send_paragraph(...) abort
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

  let l:count = a:0 >= 1 ? a:1 : 0
  let l:explicit = a:0 >= 2 ? a:2 : 0
  call s:send_text_to_ai_cli(l:text, l:count, l:explicit, 'current paragraph')
endfunction

function! s:send_text_to_ai_cli(text, count, explicit, description) abort
  " Handle explicit pane number
  if a:explicit && a:count > 0
    let l:target = system('tmux display-message -t .' . a:count . ' -p "#{pane_id}" 2>/dev/null | tr -d "\n"')
    if v:shell_error != 0 || empty(l:target)
      echo "Pane " . a:count . " not found in current window"
      return
    endif
  else
    " Auto-detect AI CLI pane
    let l:target = s:find_ai_cli_pane()
  endif

  if empty(l:target)
    echo "No AI CLI found in current window. Start an AI CLI (claude, codex, copilot, gemini) in a tmux pane."
    return
  endif

  " Send text using tmux send-keys -l for better performance and compatibility
  " The -l flag treats the input as literal text, preserving newlines
  call system('tmux send-keys -t ' . l:target . ' -l ' . shellescape(a:text))
  " Send Enter to submit
  call system('tmux send-keys -t ' . l:target . ' Enter')

  " Success message
  echo 'Sent ' . a:description . ' to AI CLI'
endfunction

function! s:find_ai_cli_pane() abort
  " Get panes for current window (sorted by pane index)
  let l:panes_output = system('tmux list-panes -F "#{pane_index} #{pane_pid} #{pane_id}"')

  " Build ordered list of panes
  let l:pane_list = []
  for l:line in split(l:panes_output, "\n")
    let l:parts = split(l:line)
    if len(l:parts) >= 3
      call add(l:pane_list, {'index': l:parts[0], 'pid': l:parts[1], 'id': l:parts[2]})
    endif
  endfor

  if empty(l:pane_list)
    return ''
  endif

  " Get all processes with parent PIDs
  let l:ps_output = system('ps -ax -o ppid,command')

  " Combine default and additional process names (with backward compatibility)
  let l:additional = get(g:, 'tmux_ai_cli_additional_processes',
                        \ get(g:, 'ai_cli_additional_processes', []))
  let l:process_names = uniq(sort(s:DEFAULT_AI_CLIS + l:additional))

  " Search for AI CLI in pane index order
  for l:pane in l:pane_list
    for l:line in split(l:ps_output, "\n")
      " Check if this line contains an AI CLI process
      for l:name in l:process_names
        if l:line =~# l:name && l:line !~# 'grep'
          " Extract PPID from the line
          let l:ppid = matchstr(l:line, '^\s*\zs\d\+')
          " Check if this process belongs to current pane
          if l:ppid == l:pane.pid
            return l:pane.id
          endif
        endif
      endfor
    endfor
  endfor

  return ''
endfunction
