# My Dotfile

Personal configuration files for my development environment.

## Contents

- `nvim/` — Neovim configuration
- `kitty/` — Kitty terminal configuration and themes
- `zsh/` — Zsh configuration
- `fastfetch/` — Fastfetch configuration and images
- `zellij/` — Zellij configuration, including the `zellij-attention` plugin and `Option+1..9` tab switching

## Installation

Look up each directory for detailed installation instructions.

For Zellij specifically:

```bash
mkdir -p ~/.config/zellij/plugins
cp zellij/config.kdl ~/.config/zellij/config.kdl
cp zellij/plugins/zellij-attention.wasm ~/.config/zellij/plugins/zellij-attention.wasm
```

On macOS, configure your terminal Option key to send `Esc+` / Meta so Zellij can receive `Option+1` through `Option+9` as `Alt 1` through `Alt 9`.
