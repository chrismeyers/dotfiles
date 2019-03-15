## Fix pathogen.vim loading errors on Windows
From a Windows command prompt:
```
> cd C:\Users\Chris\vimfiles
> mklink /D autoload C:\Users\Chris\.vim\autoload
> mklink /D bundle C:\Users\Chris\.vim\bundle
```

## Native Vim 8 Package Manager
  * Create the `~/.vim/pack/plugins/start` and `~/.vim/pack/plugins/opt` directories.
  * Put plugins that should be loaded on startup in  `~/.vim/pack/plugins/start`.

See [this article](https://shapeshed.com/vim-packages/) for more information.

## Plugin submodules
Add a new plugin:
  * `cd ~/dotfiles`
  * `git submodule add https://github.com/username/plugin.git Common/vim/.vim/pack/plugins/[start|opt]/plugin`

Clone `dotfiles` repo with plugins:
  * `cd ~`
  * `git clone --recursive https://github.com/chrismeyers/dotfiles.git`

Clone submodules after `dotfiles` repo has been cloned:
  * `cd ~/dotfiles`
  * `git submodule update --init --recursive`

Remove a plugin:
  * `cd ~/dotfiles`
  * `git submodule deinit Common/vim/.vim/pack/plugins/[start|opt]/plugin`
  * `git rm -r Common/vim/.vim/pack/plugins/[start|opt]/plugin`
  * `rm -r .git/modules/Common/vim/.vim/pack/plugins/[start|opt]/plugin`

Update a plugin:
  * `cd ~/dotfiles/Common/vim/.vim/pack/plugins/[start|opt]/plugin`
  * `git pull origin master`

Update all plugins:
  * `cd ~/dotfiles`
  * `git submodule foreach git pull origin master`

See [this gist](https://gist.github.com/manasthakur/d4dc9a610884c60d944a4dd97f0b3560) for more information.
