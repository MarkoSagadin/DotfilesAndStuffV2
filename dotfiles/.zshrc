HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

# Install plugin manager and plugins
source $HOME/.zsh/antigen/antigen.zsh
antigen bundle mafredri/zsh-async
antigen bundle agkozak/zsh-z
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle hcgraf/zsh-sudo
antigen bundle zsh-users/zsh-syntax-highlighting # Needs to be last bundle
antigen apply

# Setup pure prompt
fpath+=$HOME/.zsh/pure
autoload -U promptinit; promptinit
prompt pure
zstyle :prompt:pure:git:stash show yes

setopt histignoredups # Ignore command history duplicates
setopt menu_complete # Tab completion when choice ambiguous

# I want default edior to be nvim, but bindings should be emacs like
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

# Various other paths
export PATH=$PATH:$HOME/.local/share/gem/ruby/3.0.0/bin
export PATH=$PATH:$HOME/.cargo/bin
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:/usr/java/jre1.8.0_401/bin
export PATH=$PATH:$HOME/.local/bin
export PATH=$PATH:$HOME/go/bin
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:$HOME/bin
export PATH=$PATH:$HOME/miniconda3/bin
export PATH=$PATH:$HOME/.local/share/nvim/lsp_servers/clangd/clangd/bin/
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
source /usr/share/doc/fzf/examples/key-bindings.zsh 2> /dev/null
source /usr/share/doc/fzf/examples/completion.zsh 2> /dev/null
source /usr/share/fzf/key-bindings.zsh 2> /dev/null
source /usr/share/fzf/completion.zsh 2> /dev/null
export FZF_DEFAULT_OPTS="--layout=reverse --inline-info"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/skobec/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/skobec/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/skobec/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/skobec/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
#
##compdef gt
###-begin-gt-completions-###
#
# yargs command completion script
#
# Installation: gt completion >> ~/.zshrc
#    or gt completion >> ~/.zprofile on OSX.
#
_gt_yargs_completions()
{
  local reply
  local si=$IFS
  IFS=$'
' reply=($(COMP_CWORD="$((CURRENT-1))" COMP_LINE="$BUFFER" COMP_POINT="$CURSOR" gt --get-yargs-completions "${words[@]}"))
  IFS=$si
  _describe 'values' reply
}
compdef _gt_yargs_completions gt
###-end-gt-completions-###
