# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export SHELL="/bin/zsh"

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

alias dotfiles="/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"
alias la="exa -lah --header"

export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=$HOME/.cargo/bin:$PATH
export PATH=$HOME/.local/bin:$PATH











