# Zellij

Personal Zellij configuration.

## Install

```bash
mkdir -p ~/.config/zellij/plugins
cp zellij/config.kdl ~/.config/zellij/config.kdl
cp zellij/plugins/zellij-attention.wasm ~/.config/zellij/plugins/zellij-attention.wasm
```

## Notes

- `Option+1` through `Option+9` jump to tabs 1 through 9.
- On macOS, configure the terminal Option key to send `Esc+` / Meta so Zellij receives these as `Alt 1` through `Alt 9`.
- The config loads the `zellij-attention.wasm` plugin from `~/.config/zellij/plugins/`.
