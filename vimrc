" Modeline and Notes
" vim: set foldmarker={,} foldlevel=0 foldmethod=marker :
"
" Author: Steve Francia
" Maintainer: Joao Borges
" Last Change: 2016 Dec 10

" Windows Compatible {
	" On Windows, also use '.vim' instead of 'vimfiles'; this makes synchronization
	" across (heterogeneous) systems easier.
	if has('win32') || has('win64')
	  set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
	endif
" }

" Setup Bundle Support {
" The next two lines ensure that the ~/.vim/bundle/ system works
	runtime! autoload/pathogen.vim
	silent! call pathogen#runtime_append_all_bundles()
" }


"    set t_kD=[3~
    
" Basics {
	set nocompatible 		" must be first line
    if has('gui_running')
        set background=light     " Assume a light background
        color default
    else
        set background=dark
        color desert
    endif
" }

" General {
    set term=xterm-256color
	filetype plugin indent on  	" Automatically detect file types.
	syntax on 					" syntax highlighting
	set mouse=a					" automatically enable mouse usage
	set autochdir 				" always switch to the current file directory..
	" not every vim is compiled with this, use the following line instead
     "autocmd BufEnter * if bufname("") !~ "^\[A-Za-z0-9\]*://" | lcd %:p:h | endif
	scriptencoding utf-8
	set autowrite
	set shortmess+=filmnrxoOtT     	" abbrev. of messages (avoids 'hit enter')
	set viewoptions=folds,options,unix,slash " better unix / windows compatibility
	set viewoptions=folds,options,cursor,unix,slash " better unix / windows compatibility
	set virtualedit=onemore 	   	" allow for cursor beyond last character
	set history=1000  				" Store a ton of history (default is 20)

	" Setting up the directories {
		set backup 						" backups are nice ...
        " Moved to function at bottom of the file
		set backupdir=$HOME/.vimbackup//  " but not when they clog .
		set directory=$HOME/.vimswap// 	" Same for swap files
		set viewdir=$HOME/.vimviews// 	" same but for view files

		"" Creating directories if they don't exist
		silent execute '!mkdir -p $HOME/.vimbackup'
		silent execute '!mkdir -p $HOME/.vimswap'
		silent execute '!mkdir -p $HOME/.vimviews'
"		au BufWinLeave * silent! mkview  "make vim save view (state) (folds, cursor, etc)
"		au BufWinEnter * silent! loadview "make vim load view (state) (folds, cursor, etc)
	" }
" }

" Vim UI {
" TODO: changed for different colorschemes according to gui
"	color desert    	       		" load a colorscheme
"	color default    	       		" load a colorscheme
"    let g:molokai_original = 1
    set gfn=Inconsolata\ Medium\ 10 " guifont
	set tabpagemax=15 				" only show 15 tabs
	set showmode                   	" display the current mode

    "set cursorline  				" highlight current line
    "hi cursorline guibg=#eeeeee guifg=black	" highlight bg color of current line
"	hi CursorColumn guibg=#333333   " highlight cursor

	if has('cmdline_info')
		set ruler                  	" show the ruler
		set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " a ruler on steroids
		set showcmd                	" show partial commands in status line and
									" selected characters/lines in visual mode
	endif

	if has('statusline')
		set laststatus=1           	" show statusline only if there are > 1 windows
		" Use the commented line if fugitive isn't installed
		set statusline=%<%f\ %=\:\b%n%y%m%r%w\ %l,%c%V\ %P " a statusline, also on steroids
		"set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P
	endif

	set backspace=indent,eol,start 	" backspace for dummys
	set linespace=0 				" No extra spaces between rows
	set nu 							" Line numbers on
	set showmatch                  	" show matching brackets/parenthesis
	set incsearch 					" find as you type search
	set hlsearch 					" highlight search terms
	set winminheight=0 				" windows can be 0 line high
	set ignorecase 					" case insensitive search
	set smartcase 					" case sensitive when uc present
	set wildmenu 					" show list instead of just completing
	set wildmode=list:longest,full 	" comand <Tab> completion, list matches, then longest common part, then all.
	set whichwrap=b,s,h,l,<,>,[,]	" backspace and cursor keys wrap to
"	set scrolljump=5 				" lines to scroll when cursor leaves screen
"	set scrolloff=3 				" minimum lines to keep above and below cursor
	set foldenable  				" auto fold code
	set gdefault					" the /g flag on :s substitutions by default
    set title
" }

" Format
" ting {
"	set nowrap                     	" wrap long lines
	set autoindent                 	" indent at the same level of the previous line
	set shiftwidth=4               	" use indents of 4 spaces
	set expandtab 	       		    " convert tabs to spaces
	set tabstop=4 					" an indentation every four columns
	set smarttab                    " intelligent tabulation
	set textwidth=72
    set columns=80
	"set matchpairs+=<:>            	" match, to be used with %
	set pastetoggle=<F12>          	" pastetoggle (sane indentation on pastes)
	"set comments=sl:/*,mb:*,elx:*/  " auto format comment blocks
" }

" Key Mappings {

	" Easier moving in tabs and windows
	map <C-J> <C-W>j<C-W>_
	map <C-K> <C-W>k<C-W>_
	map <C-L> <C-W>l<C-W>_
	map <C-H> <C-W>h<C-W>_
	map <C-K> <C-W>k<C-W>_
	map <S-H> gT
	map <S-L> gt

	" Stupid shift key fixes
	"cmap W w
	"cmap WQ wq
	"cmap wQ wq
	"cmap Q q
	"cmap Tabe tabe

	" Yank from the cursor to the end of the line, to be consistent with C and D.
	nnoremap Y y$

	" Shortcuts
	" Change Working Directory to that of the current file
    cmap cwd lcd %:p:h
" }

" GUI Settings {
	" GVIM- (here instead of .gvimrc)
	if has('gui_running')
		set guioptions-=T          	" remove the toolbar
		set lines=40               	" 40 lines of text instead of 24,
	endif
" }

" Some added Functions {
	" To 'save' a file
    function! MSave()
        
        if expand("%") == ""
        if has("gui_running")
                let fname = input("SALVO! - Pressione <ENTER>")
            browse write
            else
            let fname = input("-> Salvar como: ")
                if fname == ""
                return
            endif
            execute "write " . fname
        endif
        else
        let fname = input("SALVO! - Pressione <ENTER>")
        write!
        endif
    endfunction

	" To 'save as' a file
    function! MSaveAs()
        if has("gui_running")
        browse saveas
        else
        let fname = input("-> Salvar como: ")
            if fname == ""
                return
        endif
        execute "w " . fname
        endif
    endfunction
               
	" To quit
    function! MyQuit()
        execute "quit"
    endfunction

 	" remember the last cursor position on a file
    set viminfo='10,\"30,:20,%,n~/.viminfo
    au BufReadPost * if line("'\"")|execute("normal `\"")|endif


    " Toggle comments on/off
    fu! CommOnOff()
      if !exists('g:hiddcomm')
        let g:hiddcomm=1 | hi Comment ctermfg=black  guifg=#2d2d2d
      else
        unlet g:hiddcomm | hi Comment guifg=#99968b gui=italic
      endif
    endfu

	" inserting files
    "map <F6> :r /part/hda5/gen/www/mossol/jaime2/source/doc/header.txt<cr>
    "imap <F6> <esc>:r /part/hda5/gen/www/mossol/jaime2/source/doc/header.txt<cr> i

"    :fixdel

	" util macros
    :abbreviate #d #define
    :abbreviate #i \begin{itemize}<cr>\item<cr>\end{itemize}
    :abbreviate #e \begin{enumerate}<cr>\item<cr>\end{enumerate}
    :abbreviate #v \begin{verbatim}<cr>\end{verbatim}
    :abbreviate #m \begin{minted}{}<cr>\end{minted}
    :abbreviate #l \begin{lstlisting}<cr>\end{lstlisting}
    :abbreviate \i \item
    :abbreviate #b \begin{}<cr>\end{}
    :abbreviate #g \begin{figure}<cr>\centering<cr>\includegraphics[]{}<cr>\end{figure}
    :abbreviate #q \begin{equation}<cr>\end{equation}
    :abbreviate #a \begin{align}<cr>\end{align}
    :abbreviate #f \frame<cr>{<cr>\frametitle{}<cr>}

    :runtime! syntax/thtml.vim
    runtime macros/matchit.vim

	augroup filetypedetect
		au! BufRead,BufNewFile *nc setfiletype nc
	augroup END

	" configurações para o vim-latex
    set shellslash
    " IMPORTANT: grep will sometimes skip displaying the file name if you
    " search in a singe file. This will confuse latex-suite. Set your grep
    " program to alway generate a file-name.
    set grepprg=grep\ -nH\ $*

	"switch spellcheck languages
    let g:myLang = 0
    let g:myLangList = [ "nospell", "pt", "en_us" ]

    "loop through languages
    function! MySpellLang()
        let g:myLang = g:myLang + 1
        if g:myLang >= len(g:myLangList) | let g:myLang = 0 | endif

        if g:myLang == 0 | set nospell | endif
        if g:myLang == 1 | setlocal spell spelllang=pt | endif
        if g:myLang == 2 | setlocal spell spelllang=en_us | endif

        echo "language:" g:myLangList[g:myLang]
    endf
    
	"set spell spelllang=pt
	set nospell
	
	" save file
    inoremap <F2> <C-O>:call MSave()<CR>
    map <F2> <C-O>:call MSave()<CR>

	" file save as ...
    inoremap <C-F2> <C-O>:call MSaveAs()<CR>
    map <C-F2> <C-O>:call MSaveAs()<CR>
    
    " Taglist Toggle
    inoremap <F3> <C-O>:TlistToggle<CR>
    map <F3> <C-O>:TlistToggle<CR>
    
    " NERDTree
    inoremap <C-F3> <C-O>:NERDTreeToggle<CR>
    map <C-F3> <C-O>:NERDTreeToggle<CR>

	" next buffer
    inoremap <F4> <C-O>:bnext<CR>
    map <F4> <C-O>:bnext<CR>

	" previous buffer
    inoremap <C-F4> <C-O>:bprevious<CR>
    map <C-F4> <C-O>:bprevious<CR>

	" open file
    inoremap <C-F5> <C-O>:browse confirm e<CR>
    map <C-F5> <C-O>:browse confirm e<CR>

	" switch spell language
    map <F6> :call MySpellLang()<CR>
    imap <F6> <C-o>:call MySpellLang()<CR> 

	" auto completion of words presents in text
    imap <F7> <c-n>
    imap <F8> <c-x><c-n>
    
    " calling the :make
    inoremap <F9> <C-O>:make<CR>
    map <F9> <C-O>:make<CR>

	" quiting
    inoremap <F10> <C-O>:call MyQuit()<CR>
    map <F10> <C-O>:call MyQuit()<CR>

	" closing
    inoremap <C-F10> <C-O>:close<CR>
    imap <C-F10> <C-O>:close<CR>

	" toggle comments
    map <F11>:call CommOnOff()<cr>
    imap <F11> <esc>:call CommOnOff()<cr> i

    :nnoremap <C-D> "=strftime("%c")<CR>P
    :inoremap <C-D> <C-R>=strftime("%c")<CR>

" Valid mappings
"   <F2>     Save
"   <C-F2>   Save as
"   <F3>     FuzzyFind
"   <C-F3>   NERDTree
"   <F4>     Next buffer
"   <C-F4>   Previous buffer
"   <F5>     CheckSyntax
"   <C-F5>   Open file (GUI)
"   <F6>     Switch spell languages (nospell, pt, en_us)
"   <F7>     Auto-Completion of word
"   <F8>     Auto-Completion of words (following the text)
"   <F10>    Quit
"   <C-F10>  Close
"   <F11>    Toggle comments


" Not quite working yet
"function InitializeDirectories()
  "let separator = "."
  "let parent = $HOME
  "let prefix = '.vim'
  "let dir_list = {
			  "\ 'backup': 'backupdir',
			  "\ 'views': 'viewdir',
			  "\ 'swap': 'directory' }

  "for [dirname, settingname] in items(dir_list)
	  "let directory = parent . '/' . prefix . dirname . "/"
	  "if exists("*mkdir")
		  "if !isdirectory(directory)
			  "call mkdir(directory)
		  "endif
	  "endif
	  "if !isdirectory(directory)
		  "echo "Warning: Unable to create backup directory: " . directory
		  "echo "Try: mkdir -p " . directory
	  "else
		  "" Adding an extra trailing slash so it stores the path and not just the
		  "" filename so there aren't collisions for backups
		  "" Windows Vista / 7 has UAC issues, so setting $temp as fallback
		  "exec "set " . settingname . "='" . directory . "/'," . $temp
	  "endif
  "endfor
"endfunction
"call InitializeDirectories() 
