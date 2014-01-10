﻿"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Get out of VI's compatible mode..
set nocompatible

"Sets how many lines of history VIM har to remember
"set history = 400

"Enable filetype plugin
filetype plugin on
filetype indent on

"Set to auto read when a file is changed from the outside
set autoread

"Have the mouse enabled all the time:
set mouse=a

set ruler 

"Set mapleader
let mapleader = ","
let g:mapleader = ","

" show tab like >--- and space like ----
set list
set listchars=tab:>-,trail:-

"Fast saving
nmap <leader>w :w!<cr>
nmap <leader>f :find<cr>
map <leader>ff :only<cr>
nmap <leader>nw :set nowrap<cr>

"enable pathogen
call pathogen#infect()

"powerline{ 
  "set guifont=PowerlineSymbols\ for\ Powerline 
  "set guifont=Terminus\ 8
  set guifont=Courier_New_for_Powerline:h11
  set t_Co=256
  let g:Powerline_symbols = 'fancy' 
"}

""flymaker
"let g:FlymakerOn = 1
"let g:FlymakerMenu = 1
"
""setlocal makeprg=make
"if has("autocmd")
"    " Uses quickfix list notifications
"    "autocmd BufWritePost <buffer> :AsyncMake
"
"    " Uses flymake-like notifications
"    autocmd BufWritePost <buffer> :AsyncFlyMake
"endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Enable syntax hl
syntax enable

set nocp

"Generate symbols for ctag
"map <C-F12> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR>:cscope -bkR -s .<CR>
map <C-F12> :call GenerateSymbolLinux()<cr>
function! GenerateSymbolLinux()
  silent execute ":!ctags -R --c++-kinds=+px --fields=+iaS --extra=+q ."

  " for cscope
  cs kill -1
  silent execute ":!find . -name \"*.h\" -o -name \"*.c\"  -o -name \"*.cpp\" > cscope.files"
  silent execute ":!rm cscope.out"
  silent execute ":!cscope -bkq -i cscope.files"
  cs add cscope.out
  set cscopequickfix=s-,g-,d-,t-,e-,f-,i-
endfunction

function! GenerateSymbol()
  silent execute ":!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q ."

  " for cscope
  cs kill -1
  silent execute ":!del /f /q cscope.out"
  silent execute ":!dir /s /b *.c *.h *cpp *.hpp  > cscope.files"
  silent execute ":!cscope -b -k -q -i cscope.files"
  cs add cscope.out
  set cscopequickfix=s-,g-,d-,t-,e-,f-,i-
endfunction

" return OS type, eg: windows, or linux, mac, et.st..
function! MySys()
  if has("win16") || has("win32") || has("win64") || has("win95")
    return "windows"
  elseif has("unix")
    return "linux"
  endif
endfunction

"auto update ctags when save file
"autocmd BufWritePost *.cpp,*.c,*.h :!ctags -R --sort=yes --c++-kinds=+p --fields=+iaS --extra=+q

"Set font to Monaco 10pt
"if has("gui_running")
  set guioptions-=T
  set guioptions-=m
  set guioptions-=r
  set guioptions-=l

  let psc_style = 'cool'
  "colorscheme koehler
  colorscheme molokai
"else
"  set background = light
"  colorscheme zellner
"endif

"fold method
"set foldmethod=marker
set foldmethod=indent

"Some nice mapping to switch syntax (useful if one mixes different languages in one file)
map <leader>1 :set syntax=cheetah<cr>
map <leader>2 :set syntax=xhtml<cr>
map <leader>3 :set syntax=python<cr>
map <leader>4 :set ft=javascript<cr>
map <leader>$ :syntax sync fromstart<cr>
autocmd BufEnter * :syntax sync fromstart

"Highlight current
if has("gui_running")
  set cursorline
  hi cursorline guibg=#333333
  "hi CursorColumn guibg=#333333
endif

"Omni menu colors
hi Pmenu guibg=#333333
hi PmenuSel guibg=#555555 guifg=#ffffff

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Fileformats
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Favorite filetypes
set ffs=unix,dos,mac
nmap <leader>fd :set ff=dos<cr>
nmap <leader>fu :set ff=unix<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" VIM userinterface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Set 7 lines to the curors - when moving vertical..
set so=7
"Turn on WiLd menu
set wildmenu
"Always show current position
set ruler
"The commandbar is 2 high
set cmdheight=2
"Show line number
set nu
"Do not redraw, when running macros.. lazyredraw
set lz
"Change buffer - without saving
set hid
"Set backspace
set backspace=eol,start,indent

"Bbackspace and cursor keys wrap to
set whichwrap+=<,>,h,l

"Ignore case when searching
set ignorecase
set incsearch
"Set magic on
set magic

"No sound on errors.
set noerrorbells
set novisualbell

"show matching bracets
set showmatch
"How many tenths of a second to blink
set mat=2
"Highlight search things
set hlsearch

""""""""""""""""""""""""""""""
" Statusline
""""""""""""""""""""""""""""""
"Always hide the statusline
set laststatus=2
function! CurDir()
  let curdir = substitute(getcwd(), '/Users/amir/', "~/", "g")
  return curdir
endfunction

"Format the statusline
set statusline=\ %F%m%r%h\ %w\ \ CWD:\ %r%{CurDir()}%h\ \ \ Line:\ %l/%L:%c
""""""""""""""""""""""""""""""
" Visual
""""""""""""""""""""""""""""""
" From an idea by Michael Naumann
function! VisualSearch(direction) range
  let l:saved_reg = @"
  execute "normal! vgvy"
  let l:pattern = escape(@", '\\/.*$^~[]')
  let l:pattern = substitute(l:pattern, "\n$", "", "")
  
  if a:direction == 'b'
    execute "normal ?" . l:pattern . "^M"
  else
    execute "normal /" . l:pattern . "^M"
  endif

  let @/ = l:pattern
  let @" = l:saved_reg
endfunction

"Basically you press * or # to search for the current selection !! Really useful
vnoremap <silent> * :call VisualSearch('f')<CR>
vnoremap <silent> # :call VisualSearch('b')<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Moving around and tabs
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Map space to / and c-space to ?
map <space> /
map <c-space> ?

"Smart way to move btw. windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

"Actually, the tab does not switch buffers, but my arrows
"Bclose function ca be found in "Buffer related" section
map <leader>bd :Bclose<cr>
"map <down> <leader>bd

"Use the arrows to something usefull
map <right> :bn<cr>
map <left> :bp<cr>

"Tab configuration
map <leader>tn :tabnew <cr>
map <leader>te :tabedit
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove
map <leader>tt :tabnext <cr>
map <leader>tr :tabprevious <cr>

try
  set switchbuf=usetab
  set stal=2
catch

endtry

"Moving fast to front, back and 2 sides ;)
imap <m-$> <esc>$a
imap <m-0> <esc>0i
imap <D-$> <esc>$a
imap <D-0> <esc>0i

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General Autocommands
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Switch to current dir
map <leader>cd :cd %:p:h<cr>

au BufNewFile,BufRead *.\(vim\)\@! inoremap " ""<esc>:let leavechar='"'<cr>i
au BufNewFile,BufRead *.\(txt\)\@! inoremap ' ''<esc>:let leavechar="'"<cr>i
imap <m-l> <esc>:exec "normal f" . leavechar<cr>a
imap <d-l> <esc>:exec "normal f" . leavechar<cr>a
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General Abbrevs
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"My information
iab xdate <c-r>=strftime("%Y-%m-%d %H:%M:%S")<cr>
"iab xdate <c-r>=strftime("%c")<cr>
iab xname wallace young
iab xemail linux.whu@gmail.com


"For Pro *C
iab SQ EXEC SQL
iab SI EXECUTE IMMEDIATE
iab SD EXEC SQL BEGIN DECLARE SECTION;
iab SE EXEC SQL END DECLARE SECTION;
iab SS EXEC SQL SELECT 
iab SC EXEC SQL DECLARE  CURSOR FOR

"for pc file syntax hightlight
autocmd BufEnter *.pc  set filetype=esqlc


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Editing mappings etc.
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Remap VIM 0
map 0 ^

"Move a line of text using control
nmap <M-j> mz:m+<cr>`z
nmap <M-k> mz:m-2<cr>`z
vmap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
vmap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z

func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc

autocmd BufWrite *.py :call DeleteTrailingWS()
set completeopt=menu

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Command-line config
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
func! Cwd()
  let cwd = getcwd()
  return "e " . cwd 
endfunc

func! DeleteTillSlash()
  let g:cmd = getcmdline()

  if MySys() == "linux" || MySys() == "mac"
    let g:cmd_edited = substitute(g:cmd, "\\(.*\[/\]\\).*", "\\1", "")
  else
    let g:cmd_edited = substitute(g:cmd, "\\(.*\[\\\\]\\).*", "\\1", "")
  endif

  if g:cmd == g:cmd_edited
    if MySys() == "linux" || MySys() == "mac"
      let g:cmd_edited = substitute(g:cmd, "\\(.*\[/\]\\).*/", "\\1", "")
    else
      let g:cmd_edited = substitute(g:cmd, "\\(.*\[\\\\\]\\).*\[\\\\\]", "\\1", "")
    endif
  endif

  return g:cmd_edited
endfunc

func! CurrentFileDir(cmd)
  return a:cmd . " " . expand("%:p:h") . "/"
endfunc

"Smart mappings on the command line
cno $h e ~/
cno $d e ~/Desktop/
cno $j e ./
cno $q <C-\>eDeleteTillSlash()<cr>
cno $c e <C-\>eCurrentFileDir("e")<cr>
cno $tc <C-\>eCurrentFileDir("tabnew")<cr>
cno $th tabnew ~/
cno $td tabnew ~/Desktop/

"Bash like
cnoremap <C-A>    <Home>
cnoremap <C-E>    <End>
cnoremap <C-K>    <C-U>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Buffer realted
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Fast open a buffer by search for a name
map <c-q> :sb

"Open a dummy buffer for paste
map <leader>q :e ~/buffer<cr>

"Restore cursor to file position in previous editing session
set viminfo='10,\"100,:20,%,n~/.viminfo
au BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif

" Buffer - reverse everything ... :)
map <F9> ggVGg?

" Don't close window, when deleting a buffer
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
  let l:currentBufNum = bufnr("%")
  let l:alternateBufNum = bufnr("#")
  if buflisted(l:alternateBufNum)
    buffer #
  else
    bnext
  endif

  if bufnr("%") == l:currentBufNum
    new
  endif

  if buflisted(l:currentBufNum)
    execute("bdelete! ".l:currentBufNum)
  endif
endfunction
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Files and backups
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Turn backup off
set nobackup
set nowb
set noswapfile

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Folding
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Enable folding, I find it very useful
set nofen
set fdl=0

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Text options
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set expandtab
set shiftwidth=2
map <leader>t2 :set shiftwidth=2<cr>
map <leader>t4 :set shiftwidth=4<cr>
au FileType html,python,vim,javascript setl shiftwidth=2
au FileType html,python,vim,javascript setl tabstop=2
au FileType java,c,cpp setl shiftwidth=4
au FileType java,c,cpp setl tabstop=4
set smarttab
set lbr

set tw=500

""""""""""""""""""""""""""""""
" Indent
""""""""""""""""""""""""""""""
"Auto indent
set ai
"Smart indet
set si
"C-style indeting
set cindent
"Wrap lines
set wrap

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Spell checking
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <leader>sn ]s
map <leader>sp [s
map <leader>sa zg
map <leader>s? z=

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin configuration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""
" Vim Grep
""""""""""""""""""""""""""""""
let Grep_Skip_Dirs = 'RCS CVS SCCS .svn'
let Grep_Cygwin_Find = 1

""""""""""""""""""""""""""""""
" Yank Ring
""""""""""""""""""""""""""""""
map <leader>y :YRShow<cr>

""""""""""""""""""""""""""""""
" File explorer
""""""""""""""""""""""""""""""
"Split vertically
let g:explVertical=1

"Window size
let g:explWinSize=35
let g:explSplitLeft=1
let g:explSplitBelow=1

"Hide some files
let g:explHideFiles='^\.,.*\.class$,.*\.swp$,.*\.pyc$,.*\.swo$,\.DS_Store$'

"Hide the help thing..
let g:explDetailedHelp=0

""""""""""""""""""""""""""""""
" Minibuffer
""""""""""""""""""""""""""""""
let g:miniBufExplModSelTarget = 1
let g:miniBufExplorerMoreThanOne = 2
let g:miniBufExplModSelTarget = 0
let g:miniBufExplUseSingleClick = 1
let g:miniBufExplMapWindowNavVim = 1
let g:miniBufExplVSplit = 25
let g:miniBufExplSplitBelow=1
let g:bufExplorerSortBy = "mru"
autocmd BufRead,BufNew :call UMiniBufExplorer

""""""""""""""""""""""""""""""
" Tag list (ctags) - not used
""""""""""""""""""""""""""""""
if MySys() == "windows"
  let Tlist_Ctags_Cmd = "ctags.exe"
elseif MySys() == "linux"
  let Tlist_Ctags_Cmd = "ctags"
endif

let Tlist_Sort_Type        = "mru"
let Tlist_Show_Menu        = 1
let Tlist_Show_One_File    = 1
let Tlist_Exit_OnlyWindow  = 1
let Tlist_Use_Right_Window = 1

map <leader>t :Tlist<cr>
map <silent> <F10> :TlistToggle<cr>z

""""""""""""""""""""""""""""""
" LaTeX Suite things
""""""""""""""""""""""""""""""
set grepprg=grep\ -nH\ $*
let g:Tex_DefaultTargetFormat="pdf"
let g:Tex_ViewRule_pdf='xpdf'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Filetype generic
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""
" VIM
""""""""""""""""""""""""""""""
autocmd FileType vim map <buffer> <leader><space> :w!<cr>:source %<cr>
""""""""""""""""""""""""""""""
" HTML related
""""""""""""""""""""""""""""""
" HTML entities - used by xml edit plugin
let xml_use_xhtml = 1
"let xml_no_auto_nesting = 1
"To HTML
let html_use_css      = 1
let html_number_lines = 0
let use_xhtml         = 1

""""""""""""""""""""""""""""""
" Ruby & PHP section
""""""""""""""""""""""""""""""
autocmd FileType ruby map <buffer> <leader><space> :w!<cr>:!ruby %<cr>
autocmd FileType php compiler php
autocmd FileType php map <buffer> <leader><space> <leader>cd:w<cr>:make %<cr>

""""""""""""""""""""""""""""""
" Python section
""""""""""""""""""""""""""""""
"Run the current buffer in python - ie. on leader+space
"au FileType python so ~/vim_local/syntax/python.vim
au BufNewFile,BufRead *.py,*.pyw setf python
au FileType python so $VIM/vimfiles/syntax/python.vim
autocmd FileType python map <buffer> <leader><space> :w!<cr>:!python %<cr>
"autocmd FileType python so ~/vim_local/plugin/python_fold.vim
"Set some bindings up for 'compile' of python
autocmd FileType python set makeprg=python\ -c\ \"import\ py_compile,sys;\ sys.stderr=sys.stdout;\ py_compile.compile(r'%')\"
autocmd FileType python set efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m

"python dict dir
let g:pydiction_location = $VIM . '/vimfiles/bundle/pydiction/complete-dict'

"Run in the Python interpreter
function! Python_Eval_VSplit() range
  let src = tempname()
  let dst = tempname()
  execute ": " . a:firstline . "," . a:lastline . "w " . src
  execute ":!python " . src . " > " . dst
  execute ":pedit! " . dst
endfunction

au FileType python vmap <F7> :call Python_Eval_VSplit()<cr>
""""""""""""""""""""""""""""""
" Cheetah section
"""""""""""""""""""""""""""""""
autocmd FileType cheetah set ft=xml
autocmd FileType cheetah set syntax=cheetah

"""""""""""""""""""""""""""""""
" Vim section
"""""""""""""""""""""""""""""""
autocmd FileType vim set nofen

"Folding
function! JavaFold()
  setl foldmethod=syntax
  setl foldlevelstart=1
  syn region foldBraces start=/{/ end=/}/ transparent fold keepend extend
  syn match foldImports /\(\n\?import.\+;\n\)\+/ transparent fold

  function! FoldText()
    return substitute(getline(v:foldstart), '{.*', '{...}', '')
  endfunction

  setl foldtext=FoldText()
endfunction

"au FileType java call JavaFold()
au FileType java setl fen
au BufEnter *.sablecc,*.scc set ft=sablecc

""""""""""""""""""""""""""""""
" JavaScript section
"""""""""""""""""""""""""""""""
"au FileType javascript so ~/vim_local/syntax/javascript.vim
au BufRead,BufNewFile jquery.*.js set ft=javascript syntax=jquery
function! JavaScriptFold()
  setl foldmethod=syntax
  setl foldlevelstart=1
  syn region foldBraces start=/{/ end=/}/ transparent fold keepend extend

  function! FoldText()
    return substitute(getline(v:foldstart), '{.*', '{...}', '')
  endfunction

  setl foldtext=FoldText()
endfunction

"au FileType javascript call JavaScriptFold()
au FileType javascript setl fen
au FileType javascript setl nocindent

""""""""""""""""""""""""""""""
" HTML
"""""""""""""""""""""""""""""""
au FileType html,cheetah set ft=xml
au FileType html,cheetah set syntax=html

""""""""""""""""""""""""""""""
" C mappings
"""""""""""""""""""""""""""""""
autocmd FileType c map <buffer> <leader><space> :w<cr>:!gcc %<cr>

"""""""""""""""""""""""""""""""
" SML
"""""""""""""""""""""""""""""""
autocmd FileType sml map <silent> <buffer> <leader><space> <leader>cd:w<cr>:!sml %<cr>

""""""""""""""""""""""""""""""
" Scheme bidings
""""""""""""""""""""""""""""""
autocmd BufNewFile,BufRead *.scm map <buffer> <leader><space> <leader>cd:w<cr>:!petite %<cr>
autocmd BufNewFile,BufRead *.scm inoremap <buffer> <C-t> (pretty-print )<esc>i
autocmd BufNewFile,BufRead *.scm vnoremap <C-t> <esc>`>a)<esc>`<i(pretty-print <esc>

""""""""""""""""""""""""""""""
" SVN section
"""""""""""""""""""""""""""""""
map <F8> :new<CR>:read !svn diff<CR>:set syntax=diff buftype=nofile<CR>gg

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Cope
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"For Cope
map <silent> <leader><cr> :noh<cr>

"Orginal for all
map <leader>nn :cn<cr>
map <leader>p :cp<cr>
map <leader>c :botright cw 10<cr>
map <c-u> <c-l><c-j>:q<cr>:botright cw 10<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MISC
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Remove the Windows ^M
noremap <Leader>mm mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

"Paste toggle - when pasting something in, don't indent.
set pastetoggle=<F3>

"Remove indenting on empty lines
map <F2> :%s/\s*$//g<cr>:noh<cr>''

"Super paste
inoremap <C-v> <esc>:set paste<cr>mui<C-R>+<esc>mv'uV'v=:set nopaste<cr>

"A function that inserts links & anchors on a TOhtml export.
" Notice:
" Syntax used is:
" Link
" Anchor
function! SmartTOHtml()
  TOhtml
  try
  %s/&quot;\s\+\*&gt; \(.\+\)</" <a href="#\1" style="color: cyan">\1<\/a></g
  %s/&quot;\(-\|\s\)\+\*&gt; \(.\+\)</" \&nbsp;\&nbsp; <a href="#\2" style="color: cyan;">\2<\/a></g
  %s/&quot;\s\+=&gt; \(.\+\)</" <a name="\1" style="color: #fff">\1<\/a></g
  catch
  endtry

  exe ":write!"
  exe ":bd"
endfunction

"Max window when startup
"au GUIEnter * simalt ~x

"colorscheme desert
"set cursorcolumn

"open NERDTree with current dir
map <leader>q :NERDTree %:p:h<cr>

"Don't show the tabs
set tabpagemax=18     "max 10 tabs
set showtabline=0     "no tabs
"set showtabline=1     "default, show only after create
"set showtabline=2     "always show

"setting for FuzzyFinder
map <leader>F :FufFile<CR>
map <leader>f :FufTaggedFile<CR>
map <leader>g :FufTag<CR>
map <leader>b :FufBuffer<CR>

" config for chiness code
"{
set encoding=utf-8
set fileencodings=utf-8,chinese,latin-1
if has("win32")
 set fileencoding=chinese
else
 set fileencoding=utf-8
endif

"menu 
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim

"console
language messages zh_CN.utf-8
"}

"svn config
map <F6> :!svn diff %<CR>

"for repeat command .

"for align separator
"{ Start interactive EasyAlign in visual mode
vmap <Enter> <Plug>(EasyAlign)

" Start interactive EasyAlign with a Vim movement
nmap <Leader>a <Plug>(EasyAlign)
"}

"for auto-pair
"{ suport auto pair ([
"let g:AutoPairsFlyMode = 1
"let g:AutoPairsShortcutBackInsert = '<M-b>'
"}

"for indent vertical line (vim > 7.3)
"{
if has("gui_running")
  let g:indentLine_color_gui = '#A4E57E'
else
  let g:indentLine_color_term = 239
endif
"for tab indent
set list lcs=tab:\|\ "there must following a space
"}

