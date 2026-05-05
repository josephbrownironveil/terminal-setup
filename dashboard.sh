#!/usr/bin/env bash

tmux new-session -d -s agent-core -n "CORE"

tmux send-keys -t agent-core:0 'clear; figlet "AGENT CORE" | lolcat; fastfetch; btop' C-m

tmux new-window -t agent-core -n "BOTS"
tmux send-keys -t agent-core:1 'watch -n 2 docker ps' C-m

tmux new-window -t agent-core -n "LOGS"
tmux send-keys -t agent-core:2 'docker logs -f $(docker ps -q)' C-m

tmux new-window -t agent-core -n "SECURITY"
tmux send-keys -t agent-core:3 'watch -n 3 "sudo ufw status verbose && ss -tulpn"' C-m

tmux attach -t agent-core
