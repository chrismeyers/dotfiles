#!/usr/bin/env bash

if [ "$#" -lt 2 ]
then
  echo "usage: $0 [name] [path]"
  echo "  name: name of the entry in .ssh/config, used for mount point name"
  echo "  path: path to the code on remote server"
else
  echo "Mounting $1..."
  cd ~/dev/remote

  if [ ! -d $1 ]
  then
    mkdir $1
  fi

  umount $1
  sshfs -o follow_symlinks -o transform_symlinks -o defer_permissions $1:$2 $1
  cd $1
  phpstorm .

  echo "Connecting to $1..."
  ssh $1 -t "cd $2; bash"
fi
