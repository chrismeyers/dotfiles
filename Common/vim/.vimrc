"" ===========================================================================
"" .vimrc - vim configuration file
"" Author: Chris Meyers
"" NOTE: Some settings taken from:
""   - http://vim.wikia.com/wiki/Example_vimrc
""   - http://learnvimscriptthehardway.stevelosh.com
"" ===========================================================================

" General ====================================================================
"" Set 'nocompatible' to ward off unexpected things that your distro might
"" have made, as well as sanely reset options when re-sourcing .vimrc
set nocompatible

"" Attempt to determine the type of a file based on its name and possibly its
"" contents. Use this to allow intelligent auto-indenting for each filetype,
"" and for plugins that are filetype specific.
filetype on
filetype plugin on
filetype indent on

"" Enable syntax highlighting
syntax on

"" Raise a dialog asking to save if a command fails due to unsaved changes
set confirm

"" Disable beep and flash
set noeb vb t_vb=

"" Use <F11> to toggle between 'paste' and 'nopaste'
set pastetoggle=<F11>

"" Enable line numbers
set number

"" Enable spell check by default
set spell

"" Theming
if exists('+termguicolors')
  "" t_8f and t_8b allow color schemes to work properly in tmux
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif
colorscheme elflord
set background=dark

"" Allow backspacing over autoindent, line breaks and start of insert action
set backspace=indent,eol,start

"" Set font based on OS
if has('win32')
  set guifont=Consolas:h9:cANSI:qDRAFT
else
  if has('unix')
    let s:uname = system("uname")
    if s:uname == "Darwin\n"
      set guifont=Menlo\ Regular:h11
    elseif s:uname == "Linux\n"
      set guifont=Hack\ 11
    endif
  endif
endif

"" Hide buffers instead of closing them
set hidden


" Searching ==================================================================
"" Highlight searches
set hlsearch

"" Ignore case unless a capital letter is used
set ignorecase
set smartcase


" Splits/Tabs ================================================================
"" Open new vertical splits to the right of the current split and new
"" horizontal splits below the current split
set splitright
set splitbelow

"" Always display the tabline. This allows for easy tab management and ensures
"" the command window remains in the same place.
set showtabline=2


" Statusline =================================================================
"" Always display the status line
set laststatus=2

set statusline=%F\                          " Full path to the file
set statusline+=%y                          " Filetype of the file
set statusline+=[%{&ff}]                    " Fileformat [unix]/[dos] etc...
set statusline+=%r                          " Read-only flag
set statusline+=%m                          " Modified flag
set statusline+=%=                          " Switch to the right side
set statusline+=\ Line\ %l:%c\ of\ %L\ (%P) " Location in file


" Command Window =============================================================
"" Better command-line completion
set wildmode=longest:full,full
set wildmenu

"" Show partial commands in the last line of the screen
set showcmd

"" Increase command window height
set cmdheight=2


" Netrw File Browser =========================================================
"" Disable banner
let g:netrw_banner=0

"" Pressing <CR> on a file will open it in a new vertical split
let g:netrw_browse_split=2

"" Open splits to the right
let g:netrw_altv=1

"" Tree view
let g:netrw_liststyle=3

"" Make the browser narrower by default
let g:netrw_winsize=25


" Indentation ================================================================
"" Keep the same indent level as the current line
set autoindent

"" Always enable smarttab
set smarttab

"" Indentation settings for using 2 spaces instead of tabs.
"" Do not change 'tabstop' from its default value of 8 with this setup.
set shiftwidth=2
set softtabstop=2
set expandtab

"" Open file at last cursor position
""   For nvim, see - :help last-position-jump
""   For vim, see  - /etc/vim/vimrc
autocmd BufReadPost *
  \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
  \ |   exe "normal! g`\""
  \ | endif

"" Indentation settings for using hard tabs for indent. Display tabs as
"" 2 characters wide.
"set shiftwidth=2
"set tabstop=2

"" All filetypes should use spaces by default
autocmd FileType * set expandtab shiftwidth=2 softtabstop=2
"" Use tab characters in Makefiles
autocmd FileType make set noexpandtab shiftwidth=8 softtabstop=0
"" Use 4 spaces in Python files
autocmd FileType python set expandtab shiftwidth=4 softtabstop=4


" Mouse ======================================================================
"" Enable the mouse everywhere
set mouse=a


" Key Mappings ===============================================================
"" <F1> opens Vexplorer (left of current split)
nnoremap <F1> :Vex<CR>

"" <F2> opens Explorer (in current split)
nnoremap <F2> :Ex<CR>

"" <F6> toggles spell check
nnoremap <F6> :set spell!<CR><Bar>:echo "Spell Check: " . strpart("OffOn", 3 * &spell, 3)<CR>

"" <C-L> (redraw) also turns off search highlighting until the next search
nnoremap <C-L> :nohl<CR><C-L>

"" <C-Up|Down|Left|Right> provide simplified split movement
nnoremap <C-Up> <C-w><Up>
nnoremap <C-Down> <C-w><Down>
nnoremap <C-Left> <C-w><Left>
nnoremap <C-Right> <C-w><Right>
