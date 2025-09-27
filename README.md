# vim-tmux-send-to-ai-cli

Stop copying and pasting. Send Vim text directly to AI CLIs in tmux.

Intelligent pane detection. No manual pane IDs or session names needed.

Read [help](doc/tmux_send_to_ai_cli.txt) for details.

## 1. Features

### 1.1. Supported AI CLIs

- Claude Code
- Codex CLI
- GitHub Copilot CLI
- Gemini CLI
- Additional CLIs can be configured (see `:help g:ai_cli_additional_processes`)

### 1.2. Send methods

- Current line: Send the line where your cursor is
- Current paragraph: Send the paragraph around your cursor
- Visual selection: Send highlighted text
- Entire buffer: Send the whole file you're editing
- Yanked text: Send text from * register
- Line ranges: Send specific lines (e.g., lines 10-20)

### 1.3. Target selection

- Auto-detection: Automatically finds AI CLI panes in tmux
- Pane selection: Send to specific pane by number
