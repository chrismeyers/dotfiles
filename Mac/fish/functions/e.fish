function e --description 'Edit Remote Machine with Sublime Text by mounting it'
  switch (count $argv)
    case 0
      echo "Please include a host from your .ssh/config file."
    case 1
      set_color 00BCD4
      echo "Mounting $argv[1]..."
      set_color normal
      cd ~/remote
      mkdir $argv[1]
      umount $argv[1]
      sshfs -o follow_symlinks -o transform_symlinks $argv[1]:. $argv[1]
      cd $argv[1]
      subl -n .
      ssh $argv[1]
    case 2
      set_color 00BCD4
      echo "Mounting $argv[1]:$argv[2]..."
      set_color normal
      cd ~/remote
      mkdir $argv[1]
      umount -f $argv[1]
      sshfs -o follow_symlinks -o transform_symlinks $argv[1]:$argv[2] $argv[1]
      cd $argv[1]
      subl -n .
      ssh $argv[1]
  end
end
