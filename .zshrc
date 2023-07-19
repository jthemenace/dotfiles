setopt histignorealldups sharehistory
unsetopt beep

# vi keybindings
bindkey -v
bindkey '^R' history-incremental-search-backward

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

# Only look in local shell history when using up or down arrows(otherwise sometimes will be out of order)
# https://superuser.com/questions/446594/separate-up-arrow-lookback-for-local-and-global-zsh-history
bindkey "${key[Up]}" up-line-or-local-history
bindkey "${key[Down]}" down-line-or-local-history

up-line-or-local-history() {
    zle set-local-history 1
    zle up-line-or-history
    zle set-local-history 0
}
zle -N up-line-or-local-history
down-line-or-local-history() {
    zle set-local-history 1
    zle down-line-or-history
    zle set-local-history 0
}
zle -N down-line-or-local-history

# Use modern completion system
autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# Git branch colored prompt
autoload -Uz add-zsh-hook
autoload -Uz vcs_info

add-zsh-hook precmd vcs_info

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' formats " %F{gray}%c%u(%b)%f"
zstyle ':vcs_info:*' actionformats " %F{gray}%c%u(%b)%f %a"
zstyle ':vcs_info:*' stagedstr "%F{green}"
zstyle ':vcs_info:*' unstagedstr "%F{magenta}"
zstyle ':vcs_info:*' check-for-changes true

zstyle ':vcs_info:git*+set-message:*' hooks git-untracked

+vi-git-untracked() {
    if git --no-optional-locks status --porcelain 2> /dev/null | grep -q "^??"; then
          hook_com[staged]+="%F{red}"
    fi
}

setopt PROMPT_SUBST
export PROMPT='%F{green}%n@%m:%F{blue}%~%F{reset}$vcs_info_msg_0_ %# '
export PATH=/opt/neovim/usr/bin:$PATH

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias omh='cd /omh;TERM=vt220 /usr/bin/php /omh/omh_main.php'
alias tc='tmux kill-session -C'
alias cdo='cd /u/www/htdocs/onyx'
alias cat='batcat --plain'
alias oa='/onyx/sys/onyx_admin.php'
alias vi='nvim'
function vig () {
  nvim -p $(git grep -l -i $1)
}
cheat () {
  curl "cheat.sh/$1"
}

export EDITOR=nvim
export BAT_THEME="Enki-Tokyo-Night"
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
# Must be last line
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
