function fish_prompt
  printf '%s' (whoami)
  printf ' on '

  set_color red
  echo -n (prompt_hostname)
  set_color normal
  printf ' in '

  printf '[%s]' (prompt_pwd)

  set_color green
  printf ' %s' (git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/')
  set_color normal

  # Line 2
  echo
  printf ' > '
  set_color normal
end
