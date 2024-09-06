. ~/.zsh/config
. ~/.zsh/aliases
. ~/.zsh/completion

source "$HOME/.config/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$HOME/.config/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
source "$HOME/.config/zsh/zsh-history-substring-search/zsh-history-substring-search.zsh"

# use .localrc for settings specific to one system
[[ -f ~/.localrc ]] && . ~/.localrc