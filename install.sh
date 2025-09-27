#!/bin/bash

# ==============================================================================
# 终端现代化开发环境一键安装脚本
#
# 功能:
# 1. 设置代理和环境变量。
# 2. 从源码编译安装核心依赖：ncurses, libevent, openssl。
# 3. 从源码编译安装核心工具：zsh, htop, tmux。
# 4. 安装预编译的现代化工具：eza, jq, lazygit。
# 5. 配置 Meslo Nerd Font 字体以支持 Powerlevel10k 主题。
# 6. 安装 Oh My Zsh 和 Zinit 插件管理器。
# 7. 生成一份完整的 .zshrc 配置文件。
#
# 作者: Gemini
# 版本: 2.0 (修复和重构版)
# ==============================================================================

# -- 脚本设置 --
# -e: 当任何命令失败时立即退出脚本
# -x: 打印出执行的每一条命令，方便调试
set -ex

# -- 初始准备 --
# 切换到用户主目录
cd ~
# 创建必要的本地安装目录
mkdir -p ~/.local/bin ~/.local/lib ~/.local/include ~/.local/share/fonts

# ==============================================================================
# 步骤 1: 设置环境变量 (为当前 Shell 会话)
# ==============================================================================
# 核心安装目录
export LOCAL_INSTALL_DIR="$HOME/.local"

# 设置代理 (如果你的环境需要)
export http_proxy="http://10.70.7.50:8412"
export https_proxy="http://10.70.7.50:8412"

# 将本地 bin 目录添加到 PATH，让系统能找到我们安装的程序
export PATH="$LOCAL_INSTALL_DIR/bin:$PATH"

# 设置编译和链接标志，告诉编译器和链接器在哪里寻找头文件和库文件
# 这对于从源码编译依赖于其他本地安装库的软件至关重要
export CFLAGS="-I$LOCAL_INSTALL_DIR/include"
export CXXFLAGS="-I$LOCAL_INSTALL_DIR/include"
export LDFLAGS="-L$LOCAL_INSTALL_DIR/lib"
export LD_LIBRARY_PATH="$LOCAL_INSTALL_DIR/lib:$LD_LIBRARY_PATH"
export PKG_CONFIG_PATH="$LOCAL_INSTALL_DIR/lib/pkgconfig:$PKG_CONFIG_PATH"

# ==============================================================================
# 步骤 2: 编译安装核心依赖
# ==============================================================================
# -- ncurses: 很多终端程序 (如 htop, tmux) 的图形界面库 --
echo "==== Installing ncurses ===="
wget https://ftp.gnu.org/pub/gnu/ncurses/ncurses-6.4.tar.gz
tar -xvf ncurses-6.4.tar.gz
(
  cd ncurses-6.4
  # CFLAGS="-fPIC" 是为了生成位置无关代码，这对于创建共享库 (.so) 很重要
  CFLAGS="-fPIC" CXXFLAGS="-fPIC" ./configure \
    --prefix="$LOCAL_INSTALL_DIR" \
    --with-shared \
    --without-debug \
    --enable-widec
  make -j$(nproc)
  make install
)
rm -rf ncurses-6.4 ncurses-6.4.tar.gz

# -- OpenSSL: 现代网络通信加密库 --
echo "==== Installing OpenSSL ===="
wget https://www.openssl.org/source/openssl-1.1.1w.tar.gz
tar -xzf openssl-1.1.1w.tar.gz
(
  cd openssl-1.1.1w
  ./config --prefix="$LOCAL_INSTALL_DIR" --openssldir="$LOCAL_INSTALL_DIR/ssl"
  make -j$(nproc)
  make install
)
rm -rf openssl-1.1.1w openssl-1.1.1w.tar.gz

# -- libevent: tmux 的依赖库，用于事件通知 --
echo "==== Installing libevent ===="
wget https://github.com/libevent/libevent/releases/download/release-2.1.12-stable/libevent-2.1.12-stable.tar.gz
tar -xzf libevent-2.1.12-stable.tar.gz
(
  cd libevent-2.1.12-stable
  ./configure --prefix="$LOCAL_INSTALL_DIR"
  make -j$(nproc)
  make install
)
rm -rf libevent-2.1.12-stable libevent-2.1.12-stable.tar.gz

# ==============================================================================
# 步骤 3: 编译和安装主要工具
# ==============================================================================
# -- zsh: 强大的 Shell --
echo "==== Installing zsh ===="
wget https://ftp.funet.fi/pub/unix/shells/zsh/zsh-5.9.tar.xz
tar -xvf zsh-5.9.tar.xz
(
  cd zsh-5.9
  ./configure --prefix="$LOCAL_INSTALL_DIR"
  make -j$(nproc)
  make install
)
rm -rf zsh-5.9 zsh-5.9.tar.xz

# -- tmux: 终端复用器 --
echo "==== Installing tmux ===="
wget https://github.com/tmux/tmux/releases/download/3.3a/tmux-3.3a.tar.gz
tar -xzf tmux-3.3a.tar.gz
(
  cd tmux-3.3a
  # 明确指定 CFLAGS 和 LDFLAGS，确保它能找到我们刚刚安装的依赖
  ./configure --prefix="$LOCAL_INSTALL_DIR" "CFLAGS=$CFLAGS" "LDFLAGS=$LDFLAGS"
  make -j$(nproc)
  make install
)
rm -rf tmux-3.3a tmux-3.3a.tar.gz

# -- htop: 增强的进程监视器 --
echo "==== Installing htop ===="
wget https://github.com/htop-dev/htop/archive/refs/tags/3.2.2.tar.gz -O htop-3.2.2.tar.gz
tar -xzf htop-3.2.2.tar.gz
(
  cd htop-3.2.2
  ./autogen.sh
  ./configure --prefix="$LOCAL_INSTALL_DIR"
  make -j$(nproc)
  make install
)
rm -rf htop-3.2.2 htop-3.2.2.tar.gz

# ==============================================================================
# 步骤 4: 安装预编译的二进制工具
# ==============================================================================
# -- eza: ls 的现代替代品 --
echo "==== Installing eza ===="
wget https://github.com/eza-community/eza/releases/download/v0.18.2/eza_x86_64-unknown-linux-musl.tar.gz
tar -xzf eza_x86_64-unknown-linux-musl.tar.gz
mv eza "$LOCAL_INSTALL_DIR/bin/"
rm eza_x86_64-unknown-linux-musl.tar.gz

# -- jq: JSON 命令行处理器 --
echo "==== Installing jq ===="
wget https://github.com/jqlang/jq/releases/download/jq-1.7.1/jq-linux-amd64 -O "$LOCAL_INSTALL_DIR/bin/jq"
chmod +x "$LOCAL_INSTALL_DIR/bin/jq"

# -- lazygit: TUI git 客户端 --
echo "==== Installing lazygit ===="
wget https://github.com/jesseduffield/lazygit/releases/download/v0.40.2/lazygit_0.40.2_Linux_x86_64.tar.gz
tar -xzf lazygit_0.40.2_Linux_x86_64.tar.gz
mv lazygit "$LOCAL_INSTALL_DIR/bin/"
rm lazygit_0.40.2_Linux_x86_64.tar.gz LICENSE

# ==============================================================================
# 步骤 5: 安装和配置字体
# ==============================================================================
echo "==== Installing MesloLGS Nerd Font ===="
FONT_DIR="$HOME/.local/share/fonts"
curl -fL "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf" --output "$FONT_DIR/MesloLGS NF Regular.ttf"
curl -fL "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf" --output "$FONT_DIR/MesloLGS NF Bold.ttf"
curl -fL "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf" --output "$FONT_DIR/MesloLGS NF Italic.ttf"
curl -fL "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf" --output "$FONT_DIR/MesloLGS NF Bold Italic.ttf"

# 刷新字体缓存
fc-cache -f -v

# ==============================================================================
# 步骤 6: 安装 Zsh 插件管理器
# ==============================================================================
# -- Oh My Zsh: 社区驱动的 zsh 配置管理框架 --
# 使用非交互模式安装，不切换 shell，不运行 zsh
echo "==== Installing Oh My Zsh ===="
RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# ==============================================================================
# 步骤 7: 生成最终的 .zshrc 配置文件
# ==============================================================================
echo "==== Generating .zshrc configuration ===="
# 使用 cat 和 EOF 一次性写入所有配置，避免多次追加，更清晰
# 如果 .zshrc 已存在，这将覆盖它，确保配置的纯净性
cat > ~/.zshrc << 'EOF'
# ==============================================================================
# Zsh Configuration
# ==============================================================================

# -- Environment Variables --
# 设置代理 (如果需要)
export http_proxy="http://10.70.7.50:8412"
export https_proxy="http://10.70.7.50:8412"

# 设置本地安装目录的 PATH 和相关编译链接变量
export LOCAL_INSTALL_DIR="$HOME/.local"
export PATH="$LOCAL_INSTALL_DIR/bin:$PATH"
export CFLAGS="-I$LOCAL_INSTALL_DIR/include"
export CXXFLAGS="-I$LOCAL_INSTALL_DIR/include"
export LDFLAGS="-L$LOCAL_INSTALL_DIR/lib"
export LD_LIBRARY_PATH="$LOCAL_INSTALL_DIR/lib:$LD_LIBRARY_PATH"
export PKG_CONFIG_PATH="$LOCAL_INSTALL_DIR/lib/pkgconfig:$PKG_CONFIG_PATH"

# -- Oh My Zsh Basic Settings (zinit 会接管大部分) --
export ZSH="$HOME/.oh-my-zsh"
# 如果你想用 Oh My Zsh 自带的主题和插件，取消下面的注释
# ZSH_THEME="robbyrussell"
# plugins=(git)
# source $ZSH/oh-my-zsh.sh

# -- Zinit (A flexible and fast Zsh plugin manager) --
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [[ ! -d "$ZINIT_HOME" ]]; then
  mkdir -p "$(dirname "$ZINIT_HOME")"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

# -- Zinit Plugin Loading --
# Powerlevel10k 主题 (非常快，强烈推荐)
zinit ice depth"1"
zinit light romkatv/powerlevel10k

# 语法高亮、自动建议、命令补全
zinit wait lucid light-mode for \
    atinit"zicompinit; zicdreplay" \
    zdharma-continuum/fast-syntax-highlighting \
    atload"_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions \
    blockf atpull'zinit creinstall -q .' \
    zsh-users/zsh-completions

# 历史子串搜索
zinit load "zsh-users/zsh-history-substring-search"

# 加载部分 Oh My Zsh 的库函数，而不是整个框架，以提高速度
zinit snippet OMZ::lib/clipboard.zsh
zinit snippet OMZ::lib/completion.zsh
zinit snippet OMZ::lib/history.zsh
zinit snippet OMZ::lib/key-bindings.zsh
zinit snippet OMZ::lib/git.zsh
zinit snippet OMZ::lib/theme-and-appearance.zsh

# -- Aliases --
alias ls='eza --icons'
alias ll='eza -l --icons'
alias la='eza -la --icons'
alias l.='eza -dla --icons .*'
alias tree='eza --tree'
alias pip='pip3'
alias vi='vim' # or nvim

# -- Powerlevel10k Instant Prompt --
# 使得 zsh 启动几乎无延迟
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# -- zsh compinit fix --
# 自动修复 Zsh 补全系统可能出现的权限问题
if [[ ! -f ~/.zsh_comp_fixed ]]; then
    compaudit | xargs chmod g-w,o-w 2>/dev/null || true
    rm -f ~/.zcompdump*
    autoload -U compinit && compinit
    touch ~/.zsh_comp_fixed
fi

EOF

# ==============================================================================
# 步骤 8: 完成
# ==============================================================================
echo "✅ All Done!"
echo "=============================================================================="
echo "环境已安装和配置完毕。"
echo "请执行以下操作来完成设置:"
echo ""
echo "1. 重新启动你的终端，或者直接运行:"
echo "   exec $LOCAL_INSTALL_DIR/bin/zsh"
echo ""
echo "2. 首次启动 Zsh 时，Powerlevel10k 配置向导会自动运行。"
echo "   请根据提示进行配置。如果向导没有出现，可以手动运行:"
echo "   p10k configure"
echo ""
echo "3. 请确保你的终端软件 (如 VSCode Terminal, iTerm2, Windows Terminal) 已"
echo "   将默认字体设置为 'MesloLGS NF' 以正确显示图标。"
echo "=============================================================================="



