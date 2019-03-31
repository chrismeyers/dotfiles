function fish_prompt
  printf '%s' (whoami)
  printf ' on '

  set_color red
  echo -n (prompt_hostname)
  set_color normal
  printf ' in '

  printf '[%s]' (prompt_pwd)

  if test (git rev-parse --is-inside-work-tree ^ /dev/null)
    set git_branch (git --no-pager branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')

    if [ -z (git status --short) ]
      set git_status "✓"
    else
      set git_status_color "red"
      set git_status "✗"
    end

    set_color green
    printf ' (%s ' $git_branch
    set_color $git_status_color
    printf '%s' $git_status
    set_color green
    printf ')'
    set_color normal
  end

  # Line 2
  echo
  printf ' > '
  set_color normal
end
