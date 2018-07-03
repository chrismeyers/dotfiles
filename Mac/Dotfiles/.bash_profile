source ~/.profile
if [ -f /Users/chris/.bashrc ]; then
   source /Users/chris/.bashrc
fi

# Setting PATH for Python 3.5
# The original version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.5/bin:${PATH}"
export PATH

test -e "/Users/chris/.iterm2_shell_integration.bash" && source "/Users/chris/.iterm2_shell_integration.bash"

[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion
PHP_AUTOCONF="/usr/local/bin/autoconf"
