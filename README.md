# vim-tmux-send-to-ai-cli

Send text from Vim to a tmux pane running following AI CLIs:

- Claude Code
- Codex CLI
- Gemini CLI
- GitHub Copilot CLI
- Additional CLIs can be configured (see `:help g:ai_cli_additional_processes`)

The plugin auto-detects AI CLI panes in tmux - no manual configuration needed.

Read [help](doc/tmux_send_to_ai_cli.txt) for details.

## Installation

Using [vim-plug](https://github.com/junegunn/vim-plug):

```vim
Plug 'i9wa4/vim-tmux-send-to-ai-cli'
```

## Quick Start

Add these mappings to your vimrc:

```vim
nmap <Leader>ay <Plug>(tmux-send-to-ai-cli-yanked)
nmap <Leader>ab <Plug>(tmux-send-to-ai-cli-buffer)
vmap <Leader>av <Plug>(tmux-send-to-ai-cli-visual)
nmap <Leader>al <Plug>(tmux-send-to-ai-cli-current-line)
nmap <Leader>ap <Plug>(tmux-send-to-ai-cli-paragraph)
```

### Pane Selection

You can send text to a specific pane by prefixing the mapping with a number:
- `2<Leader>ay` - Send yanked text to pane 2
- `<Leader>ay` - Auto-detect AI CLI pane (default)
