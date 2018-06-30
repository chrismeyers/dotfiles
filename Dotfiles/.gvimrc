"" ===========================================================================
"" .gvimrc - gvim configuration file
"" Author: Chris Meyers
"" ===========================================================================

" General ====================================================================
"" Disable beep and flash
set vb t_vb=

"" Default GUI size
set lines=35
set columns=140

"" Set font based on OS
if has('win32')
  set guifont=Consolas:h9:cANSI:qDRAFT
else
  if has('unix')
    let s:uname = system("uname")
    if s:uname == "Darwin\n"
      set guifont=Menlo\ Regular:h11
    endif
  endif
endif

"" Remove the toolbar
set guioptions-=T

