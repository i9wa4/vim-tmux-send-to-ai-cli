if exists('g:loaded_tmux_send_to_ai_cli')
  finish
endif
let g:loaded_tmux_send_to_ai_cli = 1

command! -nargs=0 AiCliSendBuffer call tmux_send_to_ai_cli#send_buffer()
command! -range AiCliSendRange <line1>,<line2>call tmux_send_to_ai_cli#send_range()
command! -nargs=0 AiCliSendCurrentLine call tmux_send_to_ai_cli#send_current_line()
command! -nargs=0 AiCliSendParagraph call tmux_send_to_ai_cli#send_paragraph()

command! -nargs=0 AiCliSendBufferAll call tmux_send_to_ai_cli#send_buffer(0, 0, 1)
command! -range AiCliSendRangeAll <line1>,<line2>call tmux_send_to_ai_cli#send_range(0, 0, 1)
command! -nargs=0 AiCliSendCurrentLineAll call tmux_send_to_ai_cli#send_current_line(0, 0, 1)
command! -nargs=0 AiCliSendParagraphAll call tmux_send_to_ai_cli#send_paragraph(0, 0, 1)

nnoremap <Plug>(tmux-send-to-ai-cli-buffer) <Cmd>call tmux_send_to_ai_cli#send_buffer(v:count ? v:count : 0, v:count ? 1 : 0)<CR>
vnoremap <Plug>(tmux-send-to-ai-cli-visual) :<C-u>call tmux_send_to_ai_cli#send_visual(v:count ? v:count : 0, v:count ? 1 : 0)<CR>
nnoremap <Plug>(tmux-send-to-ai-cli-current-line) <Cmd>call tmux_send_to_ai_cli#send_current_line(v:count ? v:count : 0, v:count ? 1 : 0)<CR>
nnoremap <Plug>(tmux-send-to-ai-cli-paragraph) <Cmd>call tmux_send_to_ai_cli#send_paragraph(v:count ? v:count : 0, v:count ? 1 : 0)<CR>

nnoremap <Plug>(tmux-send-to-ai-cli-buffer-all) <Cmd>call tmux_send_to_ai_cli#send_buffer(0, 0, 1)<CR>
vnoremap <Plug>(tmux-send-to-ai-cli-visual-all) :<C-u>call tmux_send_to_ai_cli#send_visual(0, 0, 1)<CR>
nnoremap <Plug>(tmux-send-to-ai-cli-current-line-all) <Cmd>call tmux_send_to_ai_cli#send_current_line(0, 0, 1)<CR>
nnoremap <Plug>(tmux-send-to-ai-cli-paragraph-all) <Cmd>call tmux_send_to_ai_cli#send_paragraph(0, 0, 1)<CR>
