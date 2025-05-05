## Fix pathogen.vim loading errors on Windows
From a Windows command prompt:
```
> cd C:\Users\Chris\vimfiles
> mklink /D autoload C:\Users\Chris\.vim\autoload
> mklink /D bundle C:\Users\Chris\.vim\bundle
```

## Native Vim 8 Package Manager
- Create the `~/.vim/pack/plugins/start` and `~/.vim/pack/plugins/opt` directories.
- Put plugins that should be loaded on startup in  `~/.vim/pack/plugins/start`.

See [this article](https://shapeshed.com/vim-packages/) for more information.

## Plugin submodules
Add a new plugin:
  - `cd ~/dotfiles`
  - `git submodule add https://github.com/username/plugin.git Common/vim/.vim/pack/plugins/[start|opt]/plugin`
    - The SSH protocol or a relative URL can be instead of the HTTPS protocol

Submodules with relative URLs:
  - Relative URLs inherit the protocol that was used to clone the superproject and will work as long as the submodule exists in the same service as the superproject (e.g GitHub or GitLab)
  - Add a new plugin using a relative URL:
    - Same user/org as superproject: `git submodule add ../plugin.git Common/vim/.vim/pack/plugins/[start|opt]/plugin`
    - Different user/org than superproject: `git submodule add ../../username2/plugin.git Common/vim/.vim/pack/plugins/[start|opt]/plugin`
  - See [this article](https://www.damirscorner.com/blog/posts/20210423-ChangingUrlsOfGitSubmodules.html) for more information about converting submodules to a relative URL

Clone `dotfiles` repo with plugins:
  - `cd ~`
  - `git clone --recursive https://github.com/chrismeyers/dotfiles.git`

Clone submodules after `dotfiles` repo has been cloned:
  - `cd ~/dotfiles`
  - `git submodule update --init --recursive`

Remove a plugin:
  - `cd ~/dotfiles`
  - `git submodule deinit Common/vim/.vim/pack/plugins/[start|opt]/plugin`
  - `git rm -r Common/vim/.vim/pack/plugins/[start|opt]/plugin`
  - `rm -r .git/modules/Common/vim/.vim/pack/plugins/[start|opt]/plugin`
  - Manually remove any additional references in `.git/modules/...` and `.git/config` if needed

Update a plugin:
  - `cd ~/dotfiles/Common/vim/.vim/pack/plugins/[start|opt]/plugin`
  - `git pull origin [master|main]`

Update all plugins:
  - `cd ~/dotfiles`
  - `git submodule update --recursive --remote`

See [this gist](https://gist.github.com/manasthakur/d4dc9a610884c60d944a4dd97f0b3560) for more information.
