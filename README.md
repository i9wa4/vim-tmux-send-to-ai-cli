# vim-tmux-send-to-ai-cli

Stop copying and pasting. Send Vim text directly to AI CLIs in tmux.

Intelligent pane detection. No manual pane IDs or session names needed.

Read [help](doc/tmux_send_to_ai_cli.txt) for details.

## Features

### Supported AI CLIs

- Claude Code
- Codex CLI
- Gemini CLI
- GitHub Copilot CLI

Additional CLIs can be configured (see `:help g:tmux_ai_cli_additional_processes`)

### Send methods

- **Current line**: Send the line where your cursor is
- **Current paragraph**: Send the paragraph around your cursor
- **Visual selection**: Send highlighted text
- **Entire buffer**: Send the whole file you're editing
- **Line ranges**: Send specific lines (e.g., lines 10-20)

### Target selection

- **Auto-detection**: Automatically finds AI CLI panes in current tmux window
  - Searches panes in pane index order (0, 1, 2...)
  - Returns the first matching AI CLI pane
- **Pane selection**: Send to specific pane by number in current window
- **All panes**: Send to all AI CLI panes at once in current window
  - Perfect for comparing responses from different AI tools (Claude, Codex, Copilot, Gemini)
  - Best-effort delivery: continues even if some panes fail
  - Success/failure counts displayed after sending

## Usage

### Basic Commands

Send to a single AI CLI pane (auto-detected):
```vim
:AiCliSendBuffer          " Send entire buffer
:AiCliSendCurrentLine     " Send current line
:AiCliSendParagraph       " Send current paragraph
:10,20AiCliSendRange      " Send lines 10-20
```

### Send to All AI CLI Panes

Send the same text to all AI CLI panes simultaneously:
```vim
:AiCliSendBufferAll       " Send entire buffer to all panes
:AiCliSendCurrentLineAll  " Send current line to all panes
:AiCliSendParagraphAll    " Send current paragraph to all panes
:10,20AiCliSendRangeAll   " Send lines 10-20 to all panes
```

**Use case:** When you have multiple AI CLI tools running (e.g., Claude, Copilot, and Gemini in different panes), you can send the same query to all of them at once and compare their responses side-by-side.

### Key Mappings

Set up custom mappings in your `.vimrc`:

```vim
" Send to single pane (auto-detected or numbered)
nmap <Leader>al <Plug>(tmux-send-to-ai-cli-current-line)
nmap <Leader>ap <Plug>(tmux-send-to-ai-cli-paragraph)
vmap <Leader>av <Plug>(tmux-send-to-ai-cli-visual)
nmap <Leader>ab <Plug>(tmux-send-to-ai-cli-buffer)

" Send to all panes at once
nmap <Leader>aL <Plug>(tmux-send-to-ai-cli-current-line-all)
nmap <Leader>aP <Plug>(tmux-send-to-ai-cli-paragraph-all)
vmap <Leader>aV <Plug>(tmux-send-to-ai-cli-visual-all)
nmap <Leader>aB <Plug>(tmux-send-to-ai-cli-buffer-all)
```

You can also send to a specific pane by prefixing with a number:
```vim
" Send to pane 2
2<Leader>al
```
