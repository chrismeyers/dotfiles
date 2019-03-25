function remote --description 'Mount remote folder using SSHFS and open in Sublime'
  switch (count $argv)
    case 0
      echo "Please include a host from your .ssh/config file."

    case 1
      set_color 00BCD4
      echo "Mounting $argv[1]..."
      set_color normal
      cd ~/Documents/Development/remote
      mkdir $argv[1]
      umount $argv[1]
      sshfs -o follow_symlinks -o transform_symlinks -o defer_permissions $argv[1]:. $argv[1]
      cd $argv[1]
      subl .
      ssh $argv[1] -t "cd $argv[2]; bash"

    case 2
      set_color 00BCD4
      echo "Mounting $argv[1]:$argv[2]..."
      set_color normal
      cd ~/Documents/Development/remote
      mkdir $argv[1]
      umount -f $argv[1]
      sshfs -o follow_symlinks -o transform_symlinks -o defer_permissions $argv[1]:$argv[2] $argv[1]
      cd $argv[1]
      subl .
      ssh $argv[1] -t "cd $argv[2]; bash"
  end
end
