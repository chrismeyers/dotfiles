if [ -f /Users/chris/.bashrc ]; then
  source /Users/chris/.bashrc
else
  echo "WARNING: Missing /Users/chris/.bashrc!"
fi

test -e "/Users/chris/.iterm2_shell_integration.bash" && source "/Users/chris/.iterm2_shell_integration.bash"

[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion
PHP_AUTOCONF="/usr/local/bin/autoconf"
