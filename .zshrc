# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
#if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
#fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=$PATH:/Applications/Postgres.app/Contents/Versions/latest/bin:/Users/shivang/Library/Python/3.12/bin

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
source /Users/shivang/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export PATH=$HOME/development/flutter/bin:$PATH
export PATH=$HOME/.gem/bin:$PATH


# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

# pnpm
export PNPM_HOME="/Users/shivang/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# Added by Windsurf
export PATH="/Users/shivang/.codeium/windsurf/bin:$PATH"
alias python=python3
alias pip=pip3

PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"
if command -v ngrok &>/dev/null; then
    eval "$(ngrok completion)"
fi


#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
export PATH=$PATH:$HOME/go/bin

alias vi=nvim

eval "$(starship init zsh)"

source ~/powerlevel10k/powerlevel10k.zsh-theme



if ! tmux has-session -t ide 2>/dev/null; then
  tmux new-session -d -s ide
fi
if ! tmux has-session -t backend-ide 2>/dev/null; then
  tmux new-session -d -s backend-ide
fi
if tmux has-session -t main 2>/dev/null; then
  tmux new-session -d -s main
fi
alias tm=tmux
# Add to your .zshrc - create aliases for all your sessions
alias tm-ide='tmux switch-client -t ide 2>/dev/null || (tmux new-session -d -s ide && tmux switch-client -t ide)'
alias tm-main='tmux switch-client -t main 2>/dev/null || (tmux new-session -d -s main && tmux switch-client -t main)'
alias tm-backend-ide='tmux switch-client -t backend-ide 2>/dev/null || (tmux new-session -d -s backend-ide && tmux switch-client -t backend-ide)'

tmux() {
  # If tmux is already inside, just call tmux normally
  if [ -n "$TMUX" ]; then
    command tmux "$@"
    return
  fi

  # If no args are passed, always attach/create "main"
  if [ $# -eq 0 ]; then
    command tmux attach-session -t main 2>/dev/null || command tmux new-session -s main
  else
    # If user passed arguments, forward them to tmux
    command tmux "$@"
  fi
}

exit() {
  # normal exit when terminal inside nvim
  if [ -n "$NVIM" ]; then
    builtin exit "$@"
    return
  fi
  
  # normal exit when terminal inside multiple panes
  if [ -n "$TMUX" ]; then
    current_session=$(tmux display-message -p '#S')
    current_window=$(tmux display-message -p '#I')
    pane_count=$(tmux list-panes -t "${current_session}:${current_window}" | wc -l)

    if [ $pane_count -gt 1 ]; then
      # More than one pane in this window → kill only this shell/pane
      builtin exit "$@"
      return
    fi


    if [ "$current_session" = "main" ] || [ "$current_session" = "ide" ] || [ "$current_session" = "backend-ide" ]; then
      tmux detach
      return
    fi
  fi
  builtin exit "$@"
}
# Make Ctrl-D run our custom exit function
setopt IGNORE_EOF   # prevent zsh from exiting immediately on Ctrl-D

# Rebind Ctrl-D to call exit()
zle -N my-exit-widget
my-exit-widget() { exit; }
bindkey "^D" my-exit-widget

export JAVA_HOME="/Library/Java/JavaVirtualMachines/sdkman-java.jdk/Contents/Home"
