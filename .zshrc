export ZSH="$HOME/.oh-my-zsh"
export SHELL="/bin/zsh"
export TERM="ghostty"
export BROWSER="qutebrowser"
export EDITOR="nvim"

ZSH_THEME="pmcgee" # https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
CASE_SENSITIVE="false" # use case-sensitive completion
HYPHEN_INSENSITIVE="true" # use hyphen-insensitive completion
zstyle ':omz:update' mode disabled  # update mode: disabled | auto | reminder
export LANG=en_US.UTF-8

DISABLE_MAGIC_FUNCTIONS="true" # Uncomment the following line if pasting URLs and other text is messed up.
# ENABLE_CORRECTION="true" # Uncomment the following line to enable command auto-correction.

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
COMPLETION_WAITING_DOTS="true"

# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
plugins=(git)

function zvm_config() {
  ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT
}
plugins+=(zsh-vi-mode)

source $ZSH/oh-my-zsh.sh

unsetopt AUTO_CD
alias dotfiles="/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME"
alias rm="rm -rv"
alias ls="exa -lh --header --group-directories-first --sort Name"
alias la="exa -lah --header --group-directories-first --sort Name"
alias flogout="pkill -KILL -u $(whoami)"

alias toby="sudo mount -t nfs 192.168.1.6:/mnt /mnt/toby && cd /mnt/toby"


# c
export LD_LIBRARY_PATH="/usr/local/lib:$LD_LIBRARY_PATH"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
[ -s "/home/nate/.bun/_bun" ] && source "/home/nate/.bun/_bun" # bun completions

# zig
export ZVM_PATH="$HOME/.config/zvm"
export ZVM_INSTALL="$ZVM_PATH/bin"

# go
export GOPATH=$HOME/programs/go
export PATH=$GOPATH/bin:$PATH
export PATH=$HOME/go/bin:$PATH
export GVM_ROOT=/home/nate/.gvm # https://github.com/moovweb/gvm
[[ -s "/home/nate/.gvm/scripts/gvm" ]] && source "/home/nate/.gvm/scripts/gvm" # https://github.com/moovweb/gvm

export PATH="$ZVM_INSTALL:$PATH"
export PATH=/usr/local/go/bin:$PATH
export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=$HOME/.cargo/bin:$PATH
export PATH=$HOME/.local/bin:$PATH
export PATH=$HOME/.local/bin/dwmblocks:$PATH
export PATH="/home/nate/.turso:$PATH"
export PATH="/snap/bin:$PATH"

bindkey '^H' backward-delete-word

export LOG="$HOME/.log"
MAXSIZE=$((50 * 1024 * 1024)) # 50 MB

# Only start logging if not already under script
if [[ -z "$UNDER_SCRIPT" ]]; then
  # Rotate if too big
  if [[ -f $LOG && $(stat -c%s "$LOG") -gt $MAXSIZE ]]; then
    mv "$LOG" "$LOG.$(date +%Y%m%d%H%M%S)"
  fi

  export UNDER_SCRIPT=1
  exec script -q -f "$LOG"
fi

