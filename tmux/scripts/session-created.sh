#!/bin/bash

# Session initialization script
# Called when a new tmux session is created

SESSION_NAME="$1"

case "$SESSION_NAME" in
  "main")
    # Set up main development environment
    tmux send-keys -t "$SESSION_NAME" "cd ~" C-m
    ;;
  "ide")
    # Set up IDE session with nvim
    tmux send-keys -t "$SESSION_NAME" "cd ~ && nvim" C-m
    ;;
  "backend-ide")
    # Set up backend development environment
    tmux send-keys -t "$SESSION_NAME" "cd ~" C-m
    ;;
esac