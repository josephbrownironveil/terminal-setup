#!/usr/bin/env bash

set -e

echo "Installing headless Agent Core terminal..."

sudo apt update && sudo apt install -y \
  zsh git curl wget unzip htop btop tmux figlet lolcat \
  fastfetch bat eza ripgrep jq ncdu tree fzf \
  ca-certificates gnupg lsb-release ufw

mkdir -p ~/agents ~/agent-control

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
  ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
fi

if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions \
  ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi

if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
  ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi

if [ -f "$HOME/.zshrc" ] && [ ! -f "$HOME/.zshrc.backup" ]; then
  cp "$HOME/.zshrc" "$HOME/.zshrc.backup"
fi

cat > ~/.zshrc << 'ZSHRC'
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME=""

plugins=(
  git
  docker
  docker-compose
  npm
  node
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

export TERM=xterm-256color
export COLORTERM=truecolor
export BAT_THEME="GitHub"
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad
export LS_COLORS="di=34:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=37;41:sg=30;43:tw=30;42:ow=30;43"
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=242"
export FZF_DEFAULT_OPTS="--color=fg:16,bg:15,hl:25,fg+:16,bg+:254,hl+:25,info:30,prompt:24,pointer:196,marker:196,spinner:24,header:24"

PROMPT='%F{24}%n@%m%f %F{28}%~%f %# '
RPROMPT='%F{240}%D{%H:%M}%f'

if command -v fastfetch >/dev/null 2>&1; then
  fastfetch
fi

alias ls="eza --color=always --group-directories-first"
alias ll="eza -la --git --color=always --group-directories-first"
alias tree="tree -C"
alias cat="batcat --theme=GitHub"
alias cls="clear"

alias sys="btop"
alias space="ncdu"
alias ports="sudo ss -tulpn"
alias firewall="sudo ufw status verbose"
alias update="sudo apt update && sudo apt upgrade -y"

alias bots="docker ps"
alias botlogs="docker logs -f"
alias agents="cd ~/agents"
alias up="docker compose up -d"
alias down="docker compose down"
alias rebuild="docker compose up -d --build"
alias logs="docker compose logs -f"

alias core="~/agent-control/dashboard.sh"
alias manage="~/agent-control/agent-manager.sh"
alias newbot="~/agent-control/create-bot.sh"
alias sec="~/agent-control/security-check.sh"
ZSHRC

if [ -d "./scripts" ]; then
  cp -r ./scripts/* ~/agent-control/
  chmod +x ~/agent-control/*.sh
fi

sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw --force enable

if command -v zsh >/dev/null 2>&1; then
  sudo chsh -s "$(which zsh)" "$USER"
fi

echo "Install complete. Run: exec zsh"
