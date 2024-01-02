# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
zstyle ':omz:update' mode auto

plugins=(
	dirhistory
	web-search
	git
	zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

alias sz="source ~/.zshrc"
alias cz="nvim ~/.zshrc"
alias cv="cd ~/.config/nvim; nvim"
alias cg="nvim ~/.gitconfig"
alias coz="nvim ~/.oh-my-zsh"
alias jp="julia --project=."
alias jd="julia --project=docs/ docs/make.jl"
alias firefox="open -a /Applications/Firefox.app"
alias fd="firefox docs/build/index.html"
alias ra="radian"
alias cdh="cd ~"
alias sdh="cd ~ && cd \$(find * . -type d 2>/dev/null | fzf)"
alias sd="cd \$(find * . -type d 2>/dev/null | fzf)"
alias g="git"
alias wlg="watch -n 1 --color 'git lg --color'"
alias otp="open /tmp/plot.png"
alias nv="nvim"
alias skclust="ssh ismael@162.38.67.7"
alias tn="tmux new -s" # Create new tmux session.
alias ta="tmux a -t" # Attach tmux session.
alias tls="tmux list-session" # List tmux sessions.

# Merge tool.
gerge() {
    if [[ -z $2 ]]; then
        revisions=blrm
    else
        revisions=$2
    fi
    git checkout --ours $1
    git mergetool $1
}
compdef _git gerge=git-checkout

# Configure fzf.
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
export DBUS_SESSION_BUS_ADDRESS='unix:path='$DBUS_LAUNCHD_SESSION_BUS_SOCKET
