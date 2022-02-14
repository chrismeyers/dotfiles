function remote --description 'Mount remote folder using SSHFS and open in PhpStorm'
  switch (count $argv)
    case 0
      echo "Please include a host from your .ssh/config file."
    case 1
      set_color 00BCD4
      echo "Mounting $argv[1]..."
      set_color normal
      cd ~/dev/remote
      if not test -d $argv[1]
        mkdir $argv[1]
      end
      umount $argv[1]
      sshfs -o follow_symlinks -o transform_symlinks -o defer_permissions $argv[1]:. $argv[1]
      cd $argv[1]
      phpstorm .
      ssh $argv[1] -t "cd $argv[2]; bash"
    case 2
      set_color 00BCD4
      echo "Mounting $argv[1]:$argv[2]..."
      set_color normal
      cd ~/dev/remote
      if not test -d $argv[1]
        mkdir $argv[1]
      end
      umount -f $argv[1]
      sshfs -o follow_symlinks -o transform_symlinks -o defer_permissions $argv[1]:$argv[2] $argv[1]
      cd $argv[1]
      phpstorm .
      ssh $argv[1] -t "cd $argv[2]; bash"
  end
end
