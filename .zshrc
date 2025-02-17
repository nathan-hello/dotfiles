export ZSH="$HOME/.oh-my-zsh"
export SHELL="/bin/zsh"
export TERM="alacritty"
export BROWSER="firefox"

ZSH_THEME="pmcgee" # https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
CASE_SENSITIVE="false" # use case-sensitive completion
HYPHEN_INSENSITIVE="true" # use hyphen-insensitive completion
HIST_STAMPS="yyyy-mm-dd" # change the command execution timestamp shown in the history command output
zstyle ':omz:update' mode disabled  # update mode: disabled | auto | reminder
source $ZSH/oh-my-zsh.sh
export LANG=en_US.UTF-8

# DISABLE_MAGIC_FUNCTIONS="true" # Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_AUTO_TITLE="true" # Uncomment the following line to disable auto-setting terminal title.
# ENABLE_CORRECTION="true" # Uncomment the following line to enable command auto-correction.
# export MANPATH="/usr/local/man:$MANPATH"
# export ARCHFLAGS="-arch x86_64"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

unsetopt AUTO_CD
export DISTRO_ID=$(grep -oP '^ID="\K[^"]+' /etc/os-release)
alias dotfiles="/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME"
alias rm="rm -iv"
alias ls="exa -lh --header --group-directories-first --sort Name"
alias la="exa -lah --header --group-directories-first --sort Name"
alias flogout="pkill -KILL -u $(whoami)"

alias toby="sudo mount -t nfs 192.168.1.6:/mnt /mnt/toby && cd /mnt/toby"

alias snen="cd /etc/nixos && sudo nvim -u /etc/nixos/dirty/nvim/init.lua ."
alias snrs="sudo nixos-rebuild switch"
alias snrt="sudo nixos-rebuild test"

export EDITOR=nvim

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
[[ -s "/home/nate/.gvm/scripts/gvm" ]] && source "/home/nate/.gvm/scripts/gvm" # https://github.com/moovweb/gvm

export PATH="$ZVM_INSTALL:$PATH"
export PATH=/usr/local/go/bin:$PATH
export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=$HOME/.cargo/bin:$PATH
export PATH=$HOME/.local/bin:$PATH
export PATH=$HOME/.local/bin/dwmblocks:$PATH
export PATH="/home/nate/.turso:$PATH"
export PATH="/snap/bin:$PATH"


# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

bindkey "^A" beginning-of-line
bindkey "^E" end-of-line
bindkey "^B" backward-word 
bindkey "^F" forward-word
bindkey "^[[P" delete-char
bindkey '^H' backward-delete-word
