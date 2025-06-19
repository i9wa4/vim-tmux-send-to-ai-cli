" vim-tmux-send-to-claude-code
" Send text from Vim to tmux claude code pane
" Author: i9wa4
" License: MIT

if exists('g:loaded_send_to_claude_code')
  finish
endif
let g:loaded_send_to_claude_code = 1

if !has('unix')
  echohl ErrorMsg
  echomsg 'vim-tmux-send-to-claude-code requires Unix-like system'
  echohl None
  finish
endif

if !executable('tmux')
  echohl ErrorMsg
  echomsg 'vim-tmux-send-to-claude-code requires tmux'
  echohl None
  finish
endif

let g:claude_code_target = get(g:, 'claude_code_target', 'dotfiles:0.1')

command! -nargs=0 ClaudeCodeSendYanked call send_to_claude_code#send_yanked()
command! -nargs=0 ClaudeCodeSendBuffer call send_to_claude_code#send_buffer()
command! -range ClaudeCodeSendRange <line1>,<line2>call send_to_claude_code#send_range()

nnoremap <Plug>(send-to-claude-code-yanked) <Cmd>call send_to_claude_code#send_yanked()<CR>
nnoremap <Plug>(send-to-claude-code-buffer) <Cmd>call send_to_claude_code#send_buffer()<CR>
vnoremap <Plug>(send-to-claude-code-visual) :<C-u>call send_to_claude_code#send_visual()<CR>

