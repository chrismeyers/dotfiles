# Path to your oh-my-zsh installation.
export ZSH="/home/chris/.oh-my-zsh"

### Set path variables
export GOPATH="$HOME/dev/go"
export PYENV_ROOT="$HOME/.pyenv"
export FNM_PATH="$HOME/.local/share/fnm"
export XDG_CONFIG_HOME="$HOME/.config"
export PATH="/usr/local/bin\
:/usr/local/sbin
:$GOPATH/bin\
:$PYENV_ROOT/bin\
:$FNM_PATH\
:$HOME/.local/bin\
:$PATH"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
# ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="%Y-%m-%d %H:%M:%S"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

ZSH_DISABLE_COMPFIX=true
source $ZSH/oh-my-zsh.sh

# User configuration
### Functions
git_branch () {
  if ! git rev-parse --is-inside-work-tree &> /dev/null; then
    return
  fi

  changes="$(git status --porcelain 2> /dev/null)"
  result=$?

  if [ -z $changes ]; then
    if [ $result -eq 0 ]; then
      git_status_color="%{$fg[green]%}"
    else
      # An error has occurred when checking the git status, probably in .git
      git_status_color="%{$fg[red]%}"
    fi
  else
    git_status_color="%{$fg[yellow]%}"
  fi

  branch=$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/\1/")
  max_length=25

  if [[ ${#branch} -gt $max_length ]]; then
    branch="${branch:0:$max_length}\u2026"
  fi

  echo "[%{$git_status_color%}git:$branch%{$reset_color%}]"
}

timezsh () {
  shell=${1-$SHELL}
  for i in $(seq 1 10); do /usr/bin/time $shell -i -c exit; done
}

fnmi () {
  if [ $# -lt 1 ]; then
    echo "Usage: $(basename "$0") version"
    return 1
  fi
  fnm install $1
  fnm default $1
  npm install --global yarn npm-check-updates neovim @vscode/vsce vercel
}

### Prompt format:
###   user@hostname[pwd][git_branch_and_status]
###    >
PROMPT='%n@%{$fg[red]%}%m%{$reset_color%}[%~]$(git_branch)
 > '

### Set environment variables
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad
export PYTHONDONTWRITEBYTECODE=1
export EDITOR="nvim"
export GCC_COLORS="error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01"

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias sz="exec zsh"

### Additional aliases
source $HOME/.aliases

### Pyenv setup
eval "$(pyenv init -)"

# Specifies global Python versions. The order of the versions will determine the
# priority of the version. Running `python` will invoke the first version given
# to this command. Running `python2` or `python3` will run the first version of
# 2.X.X or 3.X.X in the version list.
pyenv global 3.13.5

### Fast Node Manager setup
if [ -d "$FNM_PATH" ]; then
  eval "$(fnm env --shell zsh)"

  __fnm_cleanup () {
    # Disable exit on error for cleanup
    set +e

    if [ -n "${FNM_MULTISHELL_PATH}" ]; then
      rm -f "${FNM_MULTISHELL_PATH}"
      # Remove fnm symlinks older than 7 days
      find "$(dirname ${FNM_MULTISHELL_PATH})/" -type l -name '*_*' -mtime +7 -delete &>/dev/null
    fi
  }

  trap __fnm_cleanup EXIT

  __fnm_notify_missing () {
    # Notify if __fnm_cleanup deleted a symlink for a shell that's still active
    if [[ -n "${FNM_MULTISHELL_PATH}" && ! -L "${FNM_MULTISHELL_PATH}" ]]; then
      echo "${fg[red]}ALERT: fnm symlink missing - recreate shell!$reset_color"
    fi
  }

  add-zsh-hook precmd __fnm_notify_missing
fi
