" vim-tmux-send-to-ai-cli
" Send text from Vim to tmux ai cli pane
" Author: i9wa4
" License: MIT

if exists('g:loaded_send_to_ai_cli')
  finish
endif
let g:loaded_send_to_ai_cli = 1

if !has('unix')
  echohl ErrorMsg
  echomsg 'vim-tmux-send-to-ai-cli requires Unix-like system'
  echohl None
  finish
endif

if !executable('tmux')
  echohl ErrorMsg
  echomsg 'vim-tmux-send-to-ai-cli requires tmux'
  echohl None
  finish
endif

let g:ai_cli_target = get(g:, 'ai_cli_target', 'dotfiles:0.1')

command! -nargs=0 AiCliSendYanked call send_to_ai_cli#send_yanked()
command! -nargs=0 AiCliSendBuffer call send_to_ai_cli#send_buffer()
command! -range AiCliSendRange <line1>,<line2>call send_to_ai_cli#send_range()

nnoremap <Plug>(send-to-ai-cli-yanked) <Cmd>call send_to_ai_cli#send_yanked()<CR>
nnoremap <Plug>(send-to-ai-cli-buffer) <Cmd>call send_to_ai_cli#send_buffer()<CR>
vnoremap <Plug>(send-to-ai-cli-visual) :<C-u>call send_to_ai_cli#send_visual()<CR>

