# vim-tmux-send-to-ai-cli

A Vim plugin that allows you to send text from Vim to a tmux pane running AI CLI. This enables seamless integration between your text editor and AI assistant.

## Features

- Send yanked text to AI CLI
- Send entire buffer to AI CLI
- Send visual selection to AI CLI
- Send specific line ranges to AI CLI
- Send current line to AI CLI
- Send current paragraph to AI CLI
- Configurable tmux target pane

## Requirements

- Unix-like system (Linux, macOS, etc.)
- tmux
- AI CLI running in a tmux pane

## Installation

### Using [vim-plug](https://github.com/junegunn/vim-plug)

```vim
Plug 'i9wa4/vim-tmux-send-to-ai-cli'
```

### Using [Vundle](https://github.com/VundleVim/Vundle.vim)

```vim
Plugin 'i9wa4/vim-tmux-send-to-ai-cli'
```

### Using [dein](https://github.com/Shougo/dein.vim)

```vim
call dein#add('i9wa4/vim-tmux-send-to-ai-cli')
```

## Configuration

### Target Pane

The plugin automatically detects AI CLI panes in the current tmux window by searching for `ai` processes. You can set a fallback target pane for cases where automatic detection fails:

```vim
let g:ai_cli_target = 'session:window.pane'
```

Default: `''` (empty, relies on automatic detection)

## Usage

### Key Mappings

The plugin provides `<Plug>` mappings that you can map to your preferred keys.

Example configuration:
```vim
nmap <Leader>ay <Plug>(send-to-ai-cli-yanked)
nmap <Leader>ab <Plug>(send-to-ai-cli-buffer)
vmap <Leader>av <Plug>(send-to-ai-cli-visual)
nmap <Leader>al <Plug>(send-to-ai-cli-current-line)
nmap <Leader>ap <Plug>(send-to-ai-cli-paragraph)
```

### Commands

- `:AiCliSendYanked` - Send yanked text
- `:AiCliSendBuffer` - Send entire buffer
- `:[range]AiCliSendRange` - Send specific line range
- `:AiCliSendCurrentLine` - Send current line
- `:AiCliSendParagraph` - Send current paragraph

### Custom Mappings

```vim
nmap <Leader>ay <Plug>(send-to-ai-cli-yanked)
nmap <Leader>ab <Plug>(send-to-ai-cli-buffer)
vmap <Leader>av <Plug>(send-to-ai-cli-visual)
nmap <Leader>al <Plug>(send-to-ai-cli-current-line)
nmap <Leader>ap <Plug>(send-to-ai-cli-paragraph)
```

## Examples

### Basic Usage

1. Start AI CLI in a tmux pane
2. Note the tmux target (e.g., `main:0.1`)
3. Configure the target in your vimrc:
   ```vim
   let g:ai_cli_target = 'main:0.1'
   ```
4. In Vim, yank some text and press `<Space>cy` to send it to AI CLI

### Send Specific Lines

```vim
:10,20AiCliSendRange
```

This sends lines 10-20 to AI CLI.

## Limitations

- The plugin searches for AI CLI panes in the current tmux window only
- If multiple AI CLI panes exist in the same window, the first one found will be used as the target
- Automatic detection relies on finding 'ai' processes; if the process name differs, manual configuration via `g:ai_cli_target` may be needed

## License

MIT
