# Path to your oh-my-zsh installation.
export ZSH="/Users/chris/.oh-my-zsh"

# Set path variables
export GOPATH="$HOME/dev/go"
export JAVA_HOME="/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home"
export ANDROID_SDK_ROOT="$HOME/Library/Android/sdk"
export FOUNDATION_INFRA_PATH="$HOME/dev/foundation-infra"
export PATH="/opt/homebrew/bin\
:/opt/homebrew/sbin\
:/opt/homebrew/opt/sqlite/bin\
:/usr/local/bin\
:/usr/local/sbin\
:$GOPATH/bin\
:$HOME/.composer/vendor/bin\
:$HOME/.local/bin\
:$ANDROID_SDK_ROOT/emulator\
:$ANDROID_SDK_ROOT/platform-tools\
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
plugins=(git direnv)

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

k8s_context () {
  ctx=$(kubectl config current-context 2> /dev/null)
  result=$?

  if [ $result -ne 0 ]; then
    return
  fi

  echo "[%{$fg[cyan]%}k8s:$ctx%{$reset_color%}]"
}

kctx () {
  if [ "$#" -eq 0 ]; then
    kubectl config get-contexts
    return
  fi

  case $1 in
    'p' | 'prod')
      kubectl config use-context production-002
      ;;
    's' | 'stage')
      kubectl config use-context staging-002
      ;;
    *)
      kubectl config use-context $1
      ;;
  esac
}

### Prompt format:
###   user@hostname[pwd][current_k8s_context][git_branch_and_status]
###    >
PROMPT='%n@%{$fg[red]%}%m%{$reset_color%}[%~]$(k8s_context)$(git_branch)
 > '

### Set environment variables
export CLICOLOR=1
export LSCOLORS=ExGxBxDxCxegedabagacad
export PYTHONDONTWRITEBYTECODE=1
export EDITOR="nvim"
export GCC_COLORS="error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01"
export LESS="-i $LESS"

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

### gcloud
# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/chris/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/chris/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/chris/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/chris/google-cloud-sdk/completion.zsh.inc'; fi

### Mise version manager (Python, Node.js, Ruby, etc.)
eval "$(mise activate zsh)"
