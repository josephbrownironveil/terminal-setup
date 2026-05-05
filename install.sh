#!/usr/bin/env bash

set -e

echo "🚀 Installing Cyber Terminal..."

sudo apt update && sudo apt install -y \
  zsh git curl wget unzip htop btop tmux figlet lolcat \
  fastfetch bat eza ripgrep jq ncdu tree fzf

# Zsh
chsh -s $(which zsh)

# Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# Plugins
git clone https://github.com/zsh-users/zsh-autosuggestions \
${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Zsh config
cat >> ~/.zshrc << 'EOF'

ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git docker docker-compose npm node zsh-autosuggestions zsh-syntax-highlighting)

# Cyber UI
clear
figlet "AGENT CORE" | lolcat
fastfetch

alias ls="eza --icons"
alias ll="eza -la --icons --git"
alias cat="batcat"
alias bots="docker ps"
alias logs="docker compose logs -f"
alias sys="btop"
alias space="ncdu"
alias agents="cd ~/agents"
alias ports="sudo ss -tulpn"
alias firewall="sudo ufw status verbose"

alias core="~/agent-control/dashboard.sh"
alias manage="~/agent-control/agent-manager.sh"
alias newbot="~/agent-control/create-bot.sh"
alias sec="~/agent-control/security-check.sh"

export TERM=xterm-256color
export COLORTERM=truecolor

EOF

# Create control folder
mkdir -p ~/agent-control

# Copy scripts
cp -r scripts/* ~/agent-control/

chmod +x ~/agent-control/*.sh

echo "✅ Install complete"
echo "👉 Restart terminal or run: zsh"
