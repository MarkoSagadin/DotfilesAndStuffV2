HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

# Install zinit plugin manager
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# Completion init (cached - only regenerates once per day)
autoload -Uz compinit
_comp_files=(${ZDOTDIR:-$HOME}/.zcompdump(Nm-24))
if (( ${#_comp_files} )); then
  compinit -C
else
  compinit
fi
unset _comp_files

# Prompt - loaded synchronously (must be ready before first prompt)
zinit ice pick"async.zsh" src"pure.zsh"
zinit light sindresorhus/pure

# Plugins - loaded in turbo mode (staggered to avoid input freeze)
zinit ice wait"0a" lucid
zinit light zsh-users/zsh-completions

zinit ice wait"0b" lucid atload"_zsh_autosuggest_start"
zinit light zsh-users/zsh-autosuggestions

zinit ice wait"0c" lucid
zinit light hcgraf/zsh-sudo

# Syntax highlighting must be last
zinit ice wait"1" lucid
zinit light zsh-users/zsh-syntax-highlighting

setopt histignoredups # Ignore command history duplicates
setopt menu_complete # Tab completion when choice ambiguous

# I want default editor to be nvim, but bindings should be emacs like
export EDITOR="nvim"
bindkey -e

export MANPAGER='nvim +Man!'

### aliases
alias ls='eza'
alias cp="cp -i"                          # confirm before overwriting something
alias df='df -h'                          # human-readable sizes
alias free='free -m'                      # show sizes in MB
alias ll='ls -aglh --color=auto --group-directories-first'
alias ml='minicom'
alias cl='rm -fr build'
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."

# Consolidated PATH (deduplicated)
export PATH=$HOME/.local/bin:$HOME/bin:$PATH
export PATH=$PATH:$HOME/.local/share/gem/ruby/3.0.0/bin
export PATH=$PATH:$HOME/.cargo/bin
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:$HOME/go/bin
export PATH=$PATH:/usr/java/jre1.8.0_401/bin
export PATH=$PATH:$HOME/.local/share/nvim/lsp_servers/clangd/clangd/bin
export PATH=$PATH:$HOME/.local/share/coursier/bin
export PATH=$PATH:/opt/nvim-linux64/bin

export PRETTIERD_DEFAULT_CONFIG="~/.prettierrc"

### Various shell functions
# Fixes the issue where pressing delete key would print tilda character
bindkey  "^[[3~"  delete-char

backward-kill-dir () {
    local WORDCHARS=${WORDCHARS/\/}
    zle backward-kill-word
}
zle -N backward-kill-dir
bindkey '^[^?' backward-kill-dir

# Quick add, commit, push shortcut
function gitup() {
    git add .
    git commit -a -m "$1"
    git push
}

# Nice grep function, searches for a string recursively
function grp {
    grep -rnIi "$1" . --color;
}

# Nice find function for file names
function fnd {
    find . -name "$1";
}

# Open the Pull Request URL for your current directory's branch
# (base branch defaults to dev)
function openpr() {
  parent=`git show-branch | grep '*' | grep -v "$(git rev-parse --abbrev-ref HEAD)" | head -n1 | sed 's/.*\[\(.*\)\].*/\1/' | sed 's/[\^~].*//'`
  github_url=`git remote -v | awk '/fetch/{print $2}' | sed -Ee 's#(git@|git://)#https://#' -e 's@com:@com/@' -e 's%\.git$%%'`;
  branch_name=`git symbolic-ref HEAD | cut -d"/" -f 3,4`;
  pr_url=$github_url"/compare/"$parent"..."$branch_name
  xdg-open $pr_url;
}

# Run git push and then immediately open the Pull Request URL
function gpr() {
  branch_name=`git symbolic-ref HEAD | cut -d"/" -f 3,4`;
  git push --set-upstream origin $branch_name

  if [ $? -eq 0 ]; then
    openpr
  else
    echo 'failed to push commits and open a pull request.';
  fi
}

# For GCC color output
GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
export GCC_COLORS

# FZF settings
if [[ -d /usr/share/doc/fzf/examples ]]; then
  source /usr/share/doc/fzf/examples/key-bindings.zsh 2>/dev/null
  source /usr/share/doc/fzf/examples/completion.zsh 2>/dev/null
elif [[ -d /usr/share/fzf ]]; then
  source /usr/share/fzf/key-bindings.zsh 2>/dev/null
  source /usr/share/fzf/completion.zsh 2>/dev/null
fi
export FZF_DEFAULT_OPTS="--layout=reverse --inline-info"

# Lazy-load conda - only initialize when first used
conda() {
  unfunction conda
  __conda_setup="$('/home/skobec/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
  if [ $? -eq 0 ]; then
    eval "$__conda_setup"
  else
    if [ -f "/home/skobec/miniconda3/etc/profile.d/conda.sh" ]; then
      . "/home/skobec/miniconda3/etc/profile.d/conda.sh"
    fi
  fi
  unset __conda_setup
  conda "$@"
}

# opencode
export PATH=/home/skobec/.opencode/bin:$PATH

# Cache zoxide init output (regenerates when zoxide binary is updated)
_zoxide_cache="${XDG_CACHE_HOME:-$HOME/.cache}/zoxide_init.zsh"
if [[ ! -f "$_zoxide_cache" ]] || [[ "$(command -v zoxide)" -nt "$_zoxide_cache" ]]; then
  zoxide init --cmd cd zsh > "$_zoxide_cache"
fi
source "$_zoxide_cache"
unset _zoxide_cache

# bun completions
[ -s "/home/skobec/.bun/_bun" ] && source "/home/skobec/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# lazy load nvm
typeset -ga __lazyLoadLabels=(
	bun
	bunx
	node
	npm
	npx
	nvm
	pnpm
	pnpx
	turbo
	typescript-language-server
	yarn
    nvim
)

__load-nvm() {
	export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"

	[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
	[ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"
}

__work() {
	for label in "${__lazyLoadLabels[@]}"; do
		unset -f $label
	done
	unset -v __lazyLoadLabels

	__load-nvm
	unset -f __load-nvm __work
}

for label in "${__lazyLoadLabels[@]}"; do
	eval "$label() { __work; $label \$@; }"
done
