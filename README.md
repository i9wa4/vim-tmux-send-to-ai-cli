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
