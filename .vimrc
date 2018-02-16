"------------------------------------------------------------------------------
"" Pathogen (http://www.vim.org/scripts/script.php?script_id=2332).
"------------------------------------------------------------------------------

filetype off " Pathogen needs to run before 'plugin on'.
call pathogen#infect()
call pathogen#helptags() " Generate helptags for everything in 'runtimepath'.
filetype plugin on

""------------------------------------------------------------------------------
" General.
" "------------------------------------------------------------------------------

set nocompatible        " Disable vi compatibility.
set undolevels=200      " Number of undo levels.
set scrolloff=10        " Keep a context (rows) when scrolling vertically.
set sidescroll=5        " Keep a context (columns) when scrolling horizontally.
set tabpagemax=1000     " Maximum number of tabs to open by the -p argument.
set esckeys             " Cursor keys in insert mode.
set ttyfast             " Improves redrawing for newer computers.
set lazyredraw          " Don't redraw during complex operations (e.g.macros).
set autowrite           " Automatically save before :next, :make etc.
set confirm             " Ask to save file before operations like :q or :e fail.
set magic               " Use 'magic' patterns (extended regular expressions).
set hidden              " Allow switching edited buffers without saving.
set nostartofline       " Keep the cursor in the current column with page cmds.
set nojoinspaces        " Insert just one space joining lines with J.
set showcmd             " Show (partial) command in the status line.
set noshowmatch         " Don't show matching brackets when typing them.
set showmode            " Show the current mode.
set shortmess+=aIoOtT   " Abbreviation of messages (avoids 'hit enter ...').
set path=.,,**          " Search in dir of the current file, cwd, and subdirs.
set nrformats-=octal    " Make incrementing 007 result into 008 rather than 010.
"
" " Backup and swap files.
set nobackup            " Disable backup files.
set noswapfile          " Disable swap files.
set nowritebackup       " Disable auto backup before overwriting a file.

" History
set history=1000        " Number of lines of command line history.
set viminfo='100,\"500,r/mnt,r~/mnt,r/media " Read/write a .viminfo file.
set viminfo+=h          " Do not store searches.
"
" " Line numbers.
set number              " Show line numbers.
"set relativenumber      " Show relative numbers instead of absolute ones.

" " Splitting.
set splitright          " Open new vertical panes in the right rather than left.
set splitbelow          " Open new horizontal panes in the bottom rather than top.

" " Security.
set secure              " Forbid loading of .vimrc under $PWD.
set nomodeline          " Modelines have been a source of vulnerabilities.

" " Indention and formatting.
set autoindent          " Indent a new line according to the previous one.
set copyindent          " Copy (exact) indention from the previous line.
set nopreserveindent    " Do not try to preserve indention when indenting.
set nosmartindent       " Turn off smartindent.
set nocindent           " Turn off C-style indent.
set fo+=q               " Allow formatting of comments with "gq".
set fo-=r fo-=o         " Turn off automatic insertion of comment characters.
set fo+=j               " Remove a comment leader when joining comment lines.
filetype indent off     " Turn off indention by filetype.
" " Override the previous settings for all file types (some filetype plugins set
" " these options to different values, which is really annoying).
au FileType * set autoindent nosmartindent nocindent fo+=q fo-=r fo-=o fo+=j

" Whitespace.
set tabstop=4           " Number of spaces a tab counts for.
set shiftwidth=4        " Number of spaces to use for each step of indent.
set shiftround          " Round indent to multiple of shiftwidth.
set noexpandtab         " Do not expand tab with spaces.

" " Wrapping.
set wrap                " Enable text wrapping.
set linebreak           " Break after words only.
set display+=lastline   " Show as much as possible from the last shown line.
set textwidth=0         " Don't automatically wrap lines.
" " Disable automatic wrapping for all files (some filetype plugins set this to
" " a different value, which is really annoying).
au FileType * set textwidth=0

"Tabline.
set showtabline=1       " Display a tabline only if there are at least two tabs.
" Use a custom function that displays tab numbers in the tabline. Based on
" http://superuser.com/a/477221.
function! MyTabLine()
	let s = ''
	let wn = ''
	let t = tabpagenr()
	let i = 1
	while i <= tabpagenr('$')
		let buflist = tabpagebuflist(i)
		let winnr = tabpagewinnr(i)
		let s .= '%' . i . 'T'
		let s .= (i == t ? '%1*' : '%2*')
		let s .= ' '
		let wn = tabpagewinnr(i,'$')
		let s .= '%#TabNum#'
		let s .= i
		let s .= (i == t ? '%#TabLineSel#' : '%#TabLine#')
		let bufnr = buflist[winnr - 1]
		let file = bufname(bufnr)
		let buftype = getbufvar(bufnr, 'buftype')
		if buftype == 'nofile'
			if file =~ '\/.'
				let file = substitute(file, '.*\/\ze.', '', '')
			endif
		else
			" Shorten file name to include only first letters of each
			" directory.
			let file = pathshorten(file)
		endif
		if file == ''
			let file = '[No Name]'
		endif
		let s .= ' ' . file . ' '
		let i = i + 1
		" Add '[+]' if one of the buffers in the tab page is modified.
		for bufnr in buflist
			if getbufvar(bufnr, '&modified')
				let s .= '[+]'
				break
			endif
		endfor
	endwhile
	let s .= '%T%#TabLineFill#%='
	return s
endfunction

set tabline=%!MyTabLine()

" Statusline.
set laststatus=2        " Always display a statusline.
set noruler             " Since I'm using a statusline, disable ruler.
set statusline=%<%f                          " Path to the file in the buffer.
set statusline+=\ %h%w%m%r%k                 " Flags (e.g. [+], [RO]).
set statusline+=\ [%{(&fenc\ ==\"\"?&enc:&fenc).(&bomb?\",BOM\":\"\")},%{&ff}] " Encoding and line endings.
set statusline+=\ %y                         " File type.
set statusline+=\ [\%03.3b,0x\%02.2B,U+%04B] " Codes of the character under cursor.
set statusline+=\ [%l/%L\ (%p%%),%v]         " Line and column numbers.

" Tell Vim which characters to show for expanded tabs, trailing whitespace,
" ends of lines, and non-breakable space.
set listchars=tab:>-,trail:#,eol:$,nbsp:~,extends:>,precedes:<

" Allow arrows at the end/beginning of lines to move to the next/previous line.
set whichwrap+=<,>,[,]

" Path/file/command completion.
set wildmenu
set wildchar=<Tab>
set wildmode=list:longest
set wildignore+=*.o,*.obj,*.pyc,*.aux,*.bbl,*.blg,.git,.svn,.hg
" Suffixes that get lower priority when doing tab completion for filenames.
" These files are less likely to be edited.
set suffixes=.bak,~,.swp,.o,.info,.aux,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc

" Code completion.
set completeopt=longest,menuone
" Do not search in included/imported files (it slows down completion, mostly
" on network filesystems).
set complete-=i
" Enable omni completion.
set omnifunc=syntaxcomplete#Complete
" set tags=./tags,./TAGS,tags,TAGS

" Searching.
set hlsearch            " Highlight search matches.
set incsearch           " Incremental search.
" Case-smart searching (make /-style searches case-sensitive only if there is
" a capital letter in the search expression).
set ignorecase
set smartcase

" Allow backspacing over everything in insert mode.
set backspace=indent,eol,start

" Sessions.
set sessionoptions=blank,buffers,curdir,globals,help,localoptions,resize,tabpages,winpos,winsize

" Disable folds by default (i.e. automatically open all folds).
set nofoldenable

" No bell sounds.
set noerrorbells visualbell t_vb=

" Encoding and end of line.
" Default file encoding for new files.
setglobal fenc=utf-8
" Detect file encoding when opening a file and try to choose from the following
" encoding list (to check what file encoding was selected run ":set fenc").
set fencs=ucs-bom,utf-8,cp1250,latin2,latin1
" Internal encoding used by Vim buffers, help and commands.
set enc=utf-8
" Terminal encoding used for input and terminal display.
set tenc=utf-8
" End of line (unix EOL is preferred over the dos one and before the mac one).
set ffs=unix,dos,mac

" Spellchecker.
" Disable spellchecking by default (F1 toggles it).
set nospell
" Language (use Shift+F1 to toggle between the Czech and English language).
set spelllang=en_us,en_gb
" Spellfile (can add/delete custom words to/from the dictionary) is enabled
" by default and stores into ~/.vim/spell/{spelllang}.{encoding}.add).

"------------------------------------------------------------------------------
" Colors.
"------------------------------------------------------------------------------

" Syntax highlighting.
syntax on

" Color scheme (my own scheme based on the standard 'koehler' color scheme).
" Thanks to the CSApprox plugin, I can use the same scheme in both the
" graphical and terminal Vims.
set term=screen-256color
colorscheme gruvbox
set bg=dark

" Switch from block-cursor to vertical-line-cursor when going into/out of
" " insert mode
let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"

" Highlight mixture of spaces and tabs.
hi SpacesTabsMixture guifg=red guibg=gray19
" Highlight mixtures only when there are at least two successive spaces to
" prevent highlighting of false positives (e.g. in git diffs, which may begin
" with a space).
match SpacesTabsMixture /^  \+\t\+[\t ]*\|^\t\+  \+[\t ]*/

"------------------------------------------------------------------------------
" Function keys.
"------------------------------------------------------------------------------
" F1: Toggle spell checker.
nnoremap <silent> <F1> :set spell!<CR>:set spell?<CR>
" F2: Toggle the display of unprintable characters.
nnoremap <silent> <F2> :set list!<CR>:set list?<CR>

" Shift+F2: Toggle the display of colorcolumn.
function! s:ToggleColorColumn()
	if &colorcolumn > 0
		set colorcolumn=""
	elseif &textwidth > 0
		let &colorcolumn = &textwidth
	else
		set colorcolumn=80
	endif
endfunction
nnoremap <silent> <S-F2> :call <SID>ToggleColorColumn()<CR>

" F3: Toggle line wrapping.
nnoremap <silent> <F3> :set nowrap!<CR>:set nowrap?<CR>

" Shift+F3: Toggle relative/absolute numbers.
nnoremap <silent> <S-F3> :set relativenumber!<CR>:set relativenumber?<CR>

"------------------------------------------------------------------------------
" Abbreviations and other mappings.
"------------------------------------------------------------------------------

" The leader and local-leader characters.
let mapleader = ','
let maplocalleader = ','

" General command aliases.
cnoreabbrev tn tabnew
" Open help in a vertical window instead of in a horizontal window.
cnoreabbrev help vert help
" Translation. It uses https://github.com/soimort/translate-shell, which has to
" be available in $PATH under name 'trs'.
"cnoreabbrev toen !trs cs:en
"cnoreabbrev tocs !trs en:cs

" Quit with Q instead of :q!.
noremap <silent> Q :q!<CR>

" Quicksave all buffers.
" (Use both :w and :wa to force write of the currently edited buffer, even if
" there are no changes. This forces removal of trailing whitespace from the
" buffer and also overwrites of the file even if it has changed, which is
" sometimes handy.)
nnoremap <silent> <C-s> :w<CR>:wa<CR>
inoremap <silent> <C-s> <Esc>:w<CR><Esc>:wa<CR>
vnoremap <silent> <C-s> <Esc>:w<CR><Esc>:wa<CR>

" Make Ctrl-e jump to the end of the line in the insert mode.
inoremap <C-e> <C-o>$

" Stay in visual mode when indenting.
vnoremap < <gv
vnoremap > >gv

" Quickly select the text I just pasted.
noremap gV `[v`]

" Hitting space in normal/visual mode will make the current search disappear.
noremap <silent> <Space> :silent nohlsearch<CR>

" Makes copy/paste system-wide. Needs vimx to function.
if has('clipboard')
    if has('unnamedplus')  " When possible use + register for copy-paste
		set clipboard=unnamed,unnamedplus
	else         " On mac and Windows, use * register for copy-paste
		set clipboard=unnamed
	endif
endif

" Insert the contents of the clipboard.
"nnoremap <silent> <Leader>P :set paste<CR>"+]P:set nopaste<CR>
"nnoremap <silent> <Leader>p :set paste<CR>"+]p:set nopaste<CR>
"vnoremap          <Leader>p "+p

" Copy the selected text into the clipboard.
"noremap <Leader>y "+y

" Cut the selected text into the clipboard.
"noremap <Leader>d "+d

" Swap the '<letter> and `<letter> functionality because the ' character is
" more easily reachable than the ` character.
nnoremap ' `
noremap ` ' 

" Join lines by <Leader>+j because I use J to go to the previous tab.
noremap <Leader>j J

" Join lines without producing any spaces. It works like gJ, but does not keep
" the indentation whitespace.
" Based on http://vi.stackexchange.com/a/440.
function! s:JoinWithoutSpaces()
	normal! gJ
	" Remove any whitespace.
	if matchstr(getline('.'), '\%' . col('.') . 'c.') =~ '\s'
		normal! dw
	endif
endfunction
noremap <silent> <Leader>J :call <SID>JoinWithoutSpaces()<CR>

" Make Y yank everything from the cursor to the end of the line.
" This makes Y act more like C or D because by default, Y yanks the current
" line (i.e. the same as yy).
noremap Y y$

" Close the opened HTML tag with Ctrl+_ (I do not use vim-closetag because it
" often fails with an error).
inoremap <silent> <C-_> </<C-x><C-o><C-x>
" Wrap function arguments.
" Requires the vim-argwrap plugin (https://github.com/FooSoft/vim-argwrap).
nnoremap <silent> <Leader>wa :ArgWrap<CR>

" Check for changes in all buffers, automatically reload them, and redraw.
nnoremap <silent> <Leader>rr :set autoread <Bar> checktime <Bar> redraw! <Bar> set noautoread<CR>

" Replaces the current word (and all occurrences).
nnoremap <Leader>rc :%s/\<<C-r><C-w>\>/
vnoremap <Leader>rc y:%s/<C-r>"/

" Changes the current word (and all occurrences).
nnoremap <Leader>cc :%s/\<<C-r><C-w>\>/<C-r><C-w>
vnoremap <Leader>cc y:%s/<C-r>"/<C-r>"

" Replace tabs with spaces.
nnoremap <Leader>rts :%s/	/    /g<CR>

" Remove ANSI color escape codes.
nnoremap <Leader>rac :%s/<C-v><Esc>\[\(\d\{1,2}\(;\d\{1,2}\)\{0,2\}\)\?[m\|K]//g<CR>

" Opening files in tabs.
"nnoremap <Leader>sni :execute 'tabe ~/.vim/snippets/' . &filetype . '.snippets'<CR>
nnoremap <Leader>bash :tabe ~/.bashrc<CR>
nnoremap <Leader>vim :tabe ~/.vimrc<CR>
" Open the corresponding BibTeX file. It is assumed that there is only a single
" .bib file.
nnoremap <Leader>bib :tabe *.bib<CR>

"----------------------------------
" Comments.
"----------------------------------
au FileType haskell,vhdl,ada let b:comment_leader = '-- '
au FileType vim let b:comment_leader = '" '
au FileType c,cpp,java let b:comment_leader = '// '
au FileType sh,make,python,perl let b:comment_leader = '# '
au FileType tex let b:comment_leader = '% '
noremap <silent> ,c :<C-B>sil <C-E>s/^/<C-R>=escape(b:comment_leader,'\/')<CR>/<CR>:noh<CR>
noremap <silent> ,u :<C-B>sil <C-E>s/^\V<C-R>=escape(b:comment_leader,'\/')<CR>//e<CR>:noh<CR>


"------------------------------------------------------------------------------
" Plugins.
"------------------------------------------------------------------------------

"---------------------------------------
" NERDTree settings 
"---------------------------------------
nnoremap <leader>n :NERDTree<CR>
nnoremap <leader>m NERDTreeFocus<CR>
nnoremap <leader>N :NERDTreeClose<CR>
nnoremap <C-c> "+y
" moving between split panes
map <silent><Leader>h <C-w>h
map <silent><Leader>j <C-w>j
map <silent><Leader>k <C-w>k
map <silent><Leader>l <C-w>l

"----------------------------------------
" python: Syntax highlighting for Python.
"----------------------------------------
let g:python_highlight_builtins=1
let g:python_highlight_exceptions=1
let g:python_highlight_doctests=1
let g:python_highlight_indent_errors=1 " I use my own highlighting of these.
let g:python_highlight_space_errors=1
let g:python_highlight_string_formatting=1
let g:python_highlight_string_format=1
let g:python_highlight_string_templates=1
let g:python_slow_sync=1
let g:python_print_as_function=1

"-----------------------------------------
" Pydiction
"-----------------------------------------

let g:pydiction_location = '/home/smonzon/.vim/bundle/pydiction/complete-dict'


"------------------------------------------------------------------------------
" File-type specific settings and other autocommands.
"------------------------------------------------------------------------------

augroup trailing_whitespace
au!
" Automatically remove trailing whitespace when saving a file.
function! s:RemoveTrailingWhitespace()
	let pattern = '\\s\\+$'
	if &ft ==# 'mail'
		" Do not remove the space from the email signature marker ("-- \n").
		let pattern = '\\(^--\\)\\@<!' . pattern
	endif
	call setline(1, map(getline(1, '$'), 'substitute(v:val, "' . pattern . '", "", "")'))
endfunction
au BufWritePre * :if !&bin | call s:RemoveTrailingWhitespace()
" Add a new command :W that can be used to write a file without removing
" trailing whitespace (sometimes, this is handy).
command! W :set eventignore=BufWritePre | w | set eventignore=""
augroup end

" Python
augroup python
au!
" The following settings are based on these guidelines:
"  - python.org/dev/peps/pep-0008
au FileType python setl expandtab     " Use spaces instead of tabs.
au FileType python setl tabstop=4     " A tab counts for 4 spaces.
au FileType python setl softtabstop=4 " Causes backspace to delete 4 spaces.
au FileType python setl shiftwidth=4  " Shift by 4 spaces.

" Go to imports.
au FileType python nnoremap <buffer> <Leader>im /^\(from\\|import\) <CR>:nohlsearch<CR>:echo<CR>

" Let F9 run the currently opened tests.
au FileType python nnoremap <buffer> <F9> :wa<CR>:!clear; nosetests %<CR>

" Let Shift+F9 run all tests.
au FileType python nnoremap <buffer> <S-F9> :wa<CR>:!clear; nosetests tests<CR>

" Let F10 run the currently opened script.
au FileType python nnoremap <buffer> <F10> :w<CR>:!clear; python %<CR>

" Splits the current window by showing the corresponding test file on the
" right-hand side.
function! s:ShowPythonTestsInSplit()
	" For e.g. main_package/subpackage/module.py, the tests are in
	" tests/subpackage/module_tests.py (a convention that I use in my
	" projects).
	let module_rel_path = expand('%')
	let tests_rel_path = substitute(module_rel_path, '\.\py$', '_tests.py', '')
	let tests_rel_path = substitute(tests_rel_path, '^[^/]*/', 'tests/', '')
	execute 'vsplit ' . tests_rel_path
endfunction

" The mapping is mimicking <Leader>as for c,cpp.
au FileType python nnoremap <buffer> <Leader>as :call <SID>ShowPythonTestsInSplit()<CR>
augroup end
