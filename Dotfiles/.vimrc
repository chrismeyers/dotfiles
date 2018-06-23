"" ===========================================================================
"" .vimrc - vim configuration file
"" Author: Chris Meyers
"" NOTE: Some settings taken from http://vim.wikia.com/wiki/Example_vimrc
"" ===========================================================================

" General ====================================================================
"" Set 'nocompatible' to ward off unexpected things that your distro might
"" have made, as well as sanely reset options when re-sourcing .vimrc
set nocompatible

"" Enable syntax highlighting
syntax on

"" Raise a dialog asking to save if a command fails due to unsaved changes
set confirm

"" Disable beep and flash
set noeb vb t_vb=

"" Keep the same indent level as the current line
set autoindent

"" Use <F11> to toggle between 'paste' and 'nopaste'
set pastetoggle=<F11>

"" Enable hybrid line numbers
set number relativenumber

"" Theming
colorscheme desert
set background=dark

"" Allow backspacing over autoindent, line breaks and start of insert action
set backspace=indent,eol,start


" Searching ==================================================================
"" Highlight searches
set hlsearch

"" Ignore case unless a capital letter is used
set ignorecase
set smartcase


" Statusline =================================================================
"" Always display the status line
set laststatus=2


" Command Window =============================================================
"" Better command-line completion
set wildmenu

"" Show partial commands in the last line of the screen
set showcmd

"" Increase command window height
set cmdheight=2


" Indentation ================================================================
"" Attempt to determine the type of a file based on its name and possibly its
"" contents. Use this to allow intelligent auto-indenting for each filetype,
"" and for plugins that are filetype specific.
filetype indent plugin on

"" Indentation settings for using 2 spaces instead of tabs.
"" Do not change 'tabstop' from its default value of 8 with this setup.
set shiftwidth=2
set softtabstop=2
set expandtab
 
"" Indentation settings for using hard tabs for indent. Display tabs as
"" four characters wide.
"set shiftwidth=4
"set tabstop=4


" Mouse ======================================================================
"" Enable the mouse everywhere
set mouse=a


" Key Mappings ===============================================================
"" <F1> opens Explorer (in current split)
map <F1> :Ex<CR>

"" <F2> opens Vexplorer (left of current split)
map <F2> :Vex<CR>

"" <C-L> (redraw) also turns off search highlighting until the next search
nnoremap <C-L> :nohl<CR><C-L>
