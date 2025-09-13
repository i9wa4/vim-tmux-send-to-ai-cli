" vim-tmux-send-to-ai-cli
" Send text from Vim to tmux ai cli pane
" Author: i9wa4
" License: MIT

if exists('g:loaded_tmux_send_to_ai_cli')
  finish
endif
let g:loaded_tmux_send_to_ai_cli = 1

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

let g:ai_cli_target = get(g:, 'ai_cli_target', '')

command! -nargs=0 AiCliSendYanked call tmux_send_to_ai_cli#send_yanked()
command! -nargs=0 AiCliSendBuffer call tmux_send_to_ai_cli#send_buffer()
command! -range AiCliSendRange <line1>,<line2>call tmux_send_to_ai_cli#send_range()
command! -nargs=0 AiCliSendCurrentLine call tmux_send_to_ai_cli#send_current_line()
command! -nargs=0 AiCliSendParagraph call tmux_send_to_ai_cli#send_paragraph()

nnoremap <Plug>(tmux-send-to-ai-cli-yanked) <Cmd>call tmux_send_to_ai_cli#send_yanked()<CR>
nnoremap <Plug>(tmux-send-to-ai-cli-buffer) <Cmd>call tmux_send_to_ai_cli#send_buffer()<CR>
vnoremap <Plug>(tmux-send-to-ai-cli-visual) :<C-u>call tmux_send_to_ai_cli#send_visual()<CR>
nnoremap <Plug>(tmux-send-to-ai-cli-current-line) <Cmd>call tmux_send_to_ai_cli#send_current_line()<CR>
nnoremap <Plug>(tmux-send-to-ai-cli-paragraph) <Cmd>call tmux_send_to_ai_cli#send_paragraph()<CR>

