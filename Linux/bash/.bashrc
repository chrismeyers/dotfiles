### Colors and formatting variables
NORMAL="\033[0m"
UNDERLINED="\033[4m"
BOLD="\033[1;30m"
RED_BOLD="\033[1;31m"
RED="\033[0;31m"
GREEN_BOLD="\033[1;32m"
GREEN="\033[0;32m"
BLUE_BOLD="\033[1;34m"
BLUE="\033[0;34m"
YELLOW_BOLD="\033[1;33m"
YELLOW="\033[0;33m"

### Prompt format:
###   user on hostname in [pwd] git_branch_and_status
###    >
git_branch() {
  if ! git rev-parse --is-inside-work-tree &> /dev/null; then
    return
  fi

  if [ -z "$(git status --short)" ]; then
    git_status_color="${GREEN}"
  else
    git_status_color="${YELLOW}"
  fi

  git_branch=`git --no-pager branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`

  printf "${git_status_color}${git_branch}${git_status}${NORMAL}"
}

export PS1="\u on ${RED}\h${NORMAL} in [\w] \$(git_branch) \n > "

### History Settings
shopt -s histappend
export HISTCONTROL=ignoredups:ignorespace
export HISTTIMEFORMAT="%Y-%m-%dT%H:%M:%S  "
export HISTSIZE=50000

### Set environment variables
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad
export PYENV_ROOT="$HOME/.pyenv"
export PYTHONDONTWRITEBYTECODE=1
export EDITOR="nvim"
export GCC_COLORS="error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01"

### Set path variables
export GOPATH="$HOME/dev/go"
export PYENV_ROOT="$HOME/.pyenv"
export PYTHONPATH="$HOME/dev/python:$PYTHONPATH"
export XDG_CONFIG_HOME="$HOME/.config"
export PATH="$PYENV_ROOT/bin\
:/usr/lib/dart/bin\
:/usr/local/go/bin\
:$GOPATH/bin\
:$PYENV_ROOT/bin\
:$HOME/.local/bin\
:$HOME/.pub-cache/bin\
:$HOME/.poetry/bin\
:$PATH"

### Shell optional behavior
shopt -s checkwinsize

### Additional aliases
source $HOME/.aliases

### Pyenv setup
eval "$(pyenv init -)"

# Specifies global Python versions. The order of the versions will determine the
# priority of the version. Running `python` will invoke the first version given
# to this command. Running `python2` or `python3` will run the first version of
# 2.X.X or 3.X.X in the version list.
pyenv global 3.12.2 2.7.18

### Node Version Manager setup
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

# Fixes VTE configuration problem with tilix
# See: https://gnunn1.github.io/tilix-web/manual/vteconfig/
if [ $TILIX_ID ] || [ $VTE_VERSION ]; then
  source /etc/profile.d/vte.sh
fi
