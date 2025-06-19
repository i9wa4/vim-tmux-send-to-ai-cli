# vim-tmux-send-to-claude-code

A Vim plugin that allows you to send text from Vim to a tmux pane running Claude Code. This enables seamless integration between your text editor and AI assistant.

## Features

- Send yanked text to Claude Code
- Send entire buffer to Claude Code
- Send visual selection to Claude Code
- Send specific line ranges to Claude Code
- Configurable tmux target pane

## Requirements

- Unix-like system (Linux, macOS, etc.)
- tmux
- Claude Code running in a tmux pane

## Installation

### Using [vim-plug](https://github.com/junegunn/vim-plug)

```vim
Plug 'i9wa4/vim-tmux-send-to-claude-code'
```

### Using [Vundle](https://github.com/VundleVim/Vundle.vim)

```vim
Plugin 'i9wa4/vim-tmux-send-to-claude-code'
```

### Using [dein](https://github.com/Shougo/dein.vim)

```vim
call dein#add('i9wa4/vim-tmux-send-to-claude-code')
```

## Configuration

### Target Pane

The plugin automatically detects Claude Code panes in the current tmux window by searching for `claude` processes. You can set a fallback target pane for cases where automatic detection fails:

```vim
let g:claude_code_target = 'session:window.pane'
```

Default: `''` (empty, relies on automatic detection)

## Usage

### Key Mappings

The plugin provides `<Plug>` mappings that you can map to your preferred keys.

Example configuration:
```vim
nmap <Leader>cy <Plug>(send-to-claude-code-yanked)
nmap <Leader>cb <Plug>(send-to-claude-code-buffer)
vmap <Leader>cv <Plug>(send-to-claude-code-visual)
```

### Commands

- `:ClaudeCodeSendYanked` - Send yanked text
- `:ClaudeCodeSendBuffer` - Send entire buffer
- `:[range]ClaudeCodeSendRange` - Send specific line range

### Custom Mappings

```vim
nmap <Leader>cy <Plug>(send-to-claude-code-yanked)
nmap <Leader>cb <Plug>(send-to-claude-code-buffer)
vmap <Leader>cv <Plug>(send-to-claude-code-visual)
```

## Examples

### Basic Usage

1. Start Claude Code in a tmux pane
2. Note the tmux target (e.g., `main:0.1`)
3. Configure the target in your vimrc:
   ```vim
   let g:claude_code_target = 'main:0.1'
   ```
4. In Vim, yank some text and press `<Space>cy` to send it to Claude Code

### Send Specific Lines

```vim
:10,20ClaudeCodeSendRange
```

This sends lines 10-20 to Claude Code.

## Limitations

- The plugin searches for Claude Code panes in the current tmux window only
- If multiple Claude Code panes exist in the same window, the first one found will be used as the target
- Automatic detection relies on finding 'claude' processes; if the process name differs, manual configuration via `g:claude_code_target` may be needed

## License

MIT
