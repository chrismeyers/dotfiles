### Colors and formatting variables
NORMAL="\[\033[m\]"
UNDERLINED="\e[4m"
BOLD="\[\033[1;30m\]"
RED_BOLD="\[\033[1;31m\]"
RED="\[\033[0;31m\]"
GREEN_BOLD="\[\033[1;32m\]"
GREEN="\[\033[0;32m\]"
BLUE_BOLD="\[\033[1;34m\]"
BLUE="\[\033[0;34m\]"

### Prompt format:
###   user on hostname in [pwd] (git_branch)
###    >
git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}
export PS1="\u on ${RED}\h${NORMAL} in [\w] ${GREEN}\$(git_branch)${NORMAL} \n > "

### History Settings
shopt -s histappend
export HISTCONTROL=ignoredups:ignorespace
export HISTTIMEFORMAT="%Y-%m-%dT%H:%M:%S  "
export HISTFILESIZE=500
export HISTSIZE=500

### Set environment variables
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad
export PYENV_ROOT="$HOME/.pyenv"
export PYTHONDONTWRITEBYTECODE=1
export EDITOR="nvim"
export GCC_COLORS="error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01"
export XDG_CONFIG_HOME="$HOME/.config"
export GOPATH="$HOME/Documents/Development/go"

### Set path variables
export PATH="$PYENV_ROOT/bin:$HOME/.local/bin:/usr/local/go/bin:$GOPATH/bin:$PATH"
export PYTHONPATH="$HOME/Documents/Development/python-dev:$PYTHONPATH"

### Shell optional behavior
shopt -s checkwinsize

### Additional aliases
source $HOME/.aliases

### Pyenv setup
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

# Specify shell-specific Python versions. The order of the list will determine
# the priority of the version. Running `python` will invoke the first version
# given to the command. Running `python2` will run the first version of 2.X.X.
pyenv shell 3.7.2 2.7.15

### Node Version Manager setup
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
