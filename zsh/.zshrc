# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/.spoof-dpi/bin:$HOME/.local/bin:$HOME/.rd/bin:$HOME/go/bin:$HOME/.cargo/bin:$PATH

# Load Zinit
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
source "${ZINIT_HOME}/zinit.zsh"

################################
# ZSH Core Configuration
################################

# Set default editor to nvim
export EDITOR="nvim"

# Increase history size
HISTFILE=~/.histfile
HISTSIZE=100000
SAVEHIST=100000

################################
# Alias
################################

alias vim='nvim'
alias vi='nvim'
alias dkr='docker run -it --rm -v `pwd`:`pwd` -w `pwd` --user "`id -u`:`id -g`"'
alias fgco='git for-each-ref --sort=-committerdate --format="%(refname:short)" refs/heads | fzf | xargs git checkout'
alias fgm='git for-each-ref --sort=-committerdate --format="%(refname:short)" refs/heads | fzf | xargs git merge'
alias gbdm="comm -12 <(git log --merges --oneline | sed -rn \"s/.*'(.*?)' into 'master'/\\1/p\" | sort) <(git branch --format='%(refname:short)' | sort) | xargs -r git branch -D"

################################
# Zinit configuration
################################

# These plugins provide many aliases - atload''
zinit wait lucid for \
        OMZL::git.zsh \
    atload"unalias grv" \
        OMZP::git

# Themes
# Provide A Simple Prompt Till The Theme Loads
PS1="READY >"
zinit ice wait'!' lucid
zinit ice depth=1; zinit light romkatv/powerlevel10k

# Annexes
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

# Plugins
zinit wait lucid light-mode for \
    OMZL::clipboard.zsh \
    OMZL::compfix.zsh \
    OMZL::directories.zsh \
    OMZL::functions.zsh \
    OMZL::key-bindings.zsh \
    OMZL::misc.zsh \
    OMZL::theme-and-appearance.zsh \
    OMZP::colored-man-pages \
    OMZP::git-auto-fetch \
  atinit"zicompinit; zicdreplay" \
    zdharma-continuum/fast-syntax-highlighting \
  atload"_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions \
  as"completion" \
    OMZP::docker/_docker \
    OMZP::docker-compose

zinit load agkozak/zsh-z

# Recommended Be Loaded Last.
zinit ice wait blockf lucid atpull'zinit creinstall -q .'
zinit load zsh-users/zsh-completions

################################
# Theme/Promt Customization
################################

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Enable stacking completion for docker
zstyle ':completion:*:*:docker:*' option-stacking yes
zstyle ':completion:*:*:docker-*:*' option-stacking yes

################################
# Environment variables
################################

export DISABLE_AUTO_TITLE='true'

export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
