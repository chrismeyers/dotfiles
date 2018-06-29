## Fix pathogen.vim loading errors on Windows
From a Windows command prompt:
```
> cd C:\Users\Chris\vimfiles
> mklink /D autoload C:\Users\Chris\.vim\autoload
> mklink /D bundle C:\Users\Chris\.vim\bundle
```

