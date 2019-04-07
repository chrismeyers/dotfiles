### Set environment variables
set -gx PYTHONDONTWRITEBYTECODE "1"
set -gx EDITOR "subl --wait"
set -gx GCC_COLORS "error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01"
set -gx GOPATH "$HOME/Documents/Development/go"

### Set path variables
set -gx PATH \
  (brew --prefix coreutils)/libexec/gnubin \
  /usr/local/bin \
  /usr/local/sbin \
  /usr/local/opt/texinfo/bin \
  /usr/local/opt/gettext/bin \
  $HOME/Library/Android/sdk/platform-tools \
  $HOME/Library/Android/sdk/tools \
  $HOME/Library/Python/3.7/bin \
  /opt/apache-maven-3.3.9/bin \
  $HOME/.composer/vendor/bin \
  $HOME/.pub-cache/bin \
  /Applications/Postgres.app/Contents/Versions/latest/bin \
  $GOPATH/bin \
  $PATH

### Additional aliases
source $HOME/.config/fish/aliases.fish
