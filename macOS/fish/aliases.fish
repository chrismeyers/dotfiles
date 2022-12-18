#========== Built-in Mods ===========
# ls variations
alias l='ls -l'
alias la='ls -la'
alias ltr='ls -ltr'
alias lad='ls -lad */' # only list directories in current directory

# Always show grep colors
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias h='history'

alias fnd='find . -iname'


#============= General ==============
# Lock computer
alias afk='/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend'

# Simulate signing out of shell session
alias reload='exec $SHELL -l'

# Command line volume control
alias quiet='osascript -e "set volume output muted true"'
alias noise='osascript -e "set volume output muted false"'
alias turndownforwhat='osascript -e "set volume 7"'

alias timer='echo "Timer started. Stop with Ctrl-D." && date && time cat && date'

# Update shell config files
alias sc='source $HOME/.config/fish/config.fish'
alias sa='source $HOME/.config/fish/aliases.fish'


#=============== Admin ==============
# Get macOS Software Updates, and update Homebrew, npm, and their installed packages
alias update='sudo softwareupdate -i -a; brew update; brew upgrade; brew cleanup; npm install npm -g; npm update -g'

# Show/hide hidden files in Finder
alias show='defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder'
alias hide='defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder'

# Rebuild Launch Services database
# Use if icons in Finder are incorrect or there are duplicates in "Open With"
alias lsdb="/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister -kill -r -domain local -domain system -domain user"

alias sshconfig='nvim $HOME/.ssh/config'


#============ Navigation ============
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias docs='cd $HOME/Documents'
alias dev='cd $HOME/dev'
alias scr='cd $HOME/dev/scripts'
alias drop='cd $HOME/Library/CloudStorage/Dropbox'
alias site='cd $HOME/dev/website'
alias mov='cd $HOME/Movies'
alias pics='cd $HOME/Pictures'
alias dt='cd $HOME/Desktop'
alias dots='cd $HOME/dotfiles'
alias dl='cd $HOME/Downloads'


#============ Programming ===========
alias gbpurge='git fetch --prune && git branch --merged | grep -E -v "\*|master|main|develop|stage|qa" | xargs -n 1 git branch -d'


#============= Web stuff ============
# Config files
alias hosts='sudo nvim /etc/hosts'

# Print IP addresses
alias publicip='dig +short myip.opendns.com @resolver1.opendns.com'
alias localip="ifconfig | grep 'inet ' | grep -Fv 127.0.0.1 | awk '{print \$2}'"

# URL utils
alias urlencode='python3 -c "import urllib.parse, sys; print(urllib.parse.quote(sys.argv[1]))"'
alias urldecode='python3 -c "import urllib.parse, sys; print(urllib.parse.unquote(sys.argv[1]))"'

# Browsers
alias chrome='/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome'


#============= Editors ==============
alias e='open -e'


#============= Scripts ==============
alias backupdots='python3 $HOME/dotfiles/backupdots.py'
