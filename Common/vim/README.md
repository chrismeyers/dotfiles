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
