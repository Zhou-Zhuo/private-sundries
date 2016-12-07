" for Vundle
set nocompatible              " be iMproved
filetype off                  " required!

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle
" required!
Plugin 'gmarik/vundle'

" Plugin 'L9'
Plugin 'taglist.vim'
" Too slow!
" Plugin 'dkprice/vim-easygrep'

" Plugin 'tpope/vim-fugitive'
" Plugin 'Lokaltog/vim-easymotion'
" Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Plugin 'tpope/vim-rails.git'

Plugin 'Conque-Shell'
Plugin 'scrooloose/nerdtree'
Plugin 'Xuyuanp/nerdtree-git-plugin'
Plugin 'bling/vim-airline'
" To show git status in vim status line, vim-fugitive must be installed!!
Plugin 'tpope/vim-fugitive'
Plugin 'altercation/vim-colors-solarized'
Plugin 'Valloric/YouCompleteMe'
Plugin 'kien/ctrlp.vim'
Plugin 'easymotion/vim-easymotion'
" Evernote on vim!
Plugin 'neilagabriel/vim-geeknote'
Plugin 'kakkyz81/evervim'

 
" plugins not in github
" Plugin 'git://git.wincent.com/command-t.git'

" plugins in local path:
" Plugin 'file:///Users/gmarik/path/to/plugin'

filetype plugin indent on     " required!

" scheme
" ron, slate. It seems that ron act better in C
colorscheme solarized

" syntax highlight 
syntax on

" ignore case when search
set ignorecase

" set font
set guifont=Bitstream\ Vera\ Sans\ Mono\ 11

" let backspace work normally
set bs=2

" tab setting
set cindent

function! Usetab(tab, w)
	set smarttab
	let &tabstop=a:w
	let &softtabstop=a:w
	let &shiftwidth=a:w
	if (a:tab == 0)
		set expandtab
	else
		set noexpandtab
	endif
endf

command Usetab call Usetab(1, 8)
command Usespace call Usetab(0, 4)

Usetab

set nu

" setting for airline status-line
set laststatus=2

" show command typing in normal mode on status-line
set showcmd

" nobackup file
set nobackup

" Problem maybe in vim-airline/autoload/airline/highlighter.vim:116
" And do not use hybrid theme

set background=dark
"set t_Co=256
"let g:solarized_termcolor=256
set t_Co=16
let g:airline_powerline_fonts = 1
let g:bufferline_echo = 0
let g:airline_theme = 'base16'
let g:airline_left_sep = '>'
let g:airline_left_alt_sep = '│'
let g:airline_right_alt_sep = '│'
"let g:airline_left_sep = '▶'
let g:airline_left_sep = ''
let g:airline_right_sep = '<'
"let g:airline_right_sep = '◀'
let g:airline_right_sep = ''
if !exists('g:airline_symbols')
	let g:airline_symbols = {}
endif
let g:airline_symbols.linenr = '␤'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.readonly = ''

let g:airline_mode_map = {
  \ '__' : '-',
  \ 'n'	 : 'N',
  \ 'i'  : 'I',
  \ 'R'  : 'R',
  \ 'c'  : 'C',
  \ 'v'  : 'V',
  \ 'V'  : 'V',
  \ '' : 'V',
  \ 's'  : 'S',
  \ 'S'  : 'S',
  \ '' : 'S',
  \ }

" let g:airline_extensions = ['branch', 'tabline']
"let g:airline_section_b = '%{getcwd()}'
"let g:airline_section_a = airline#section#create(['hunks', 'branch'])
"let g:airline_section_b =
" warning line is such an annoyrance
let g:airline_section_warning = ''
let g:airline#extensions#hunks#enabled=0
let g:airline#extensions#branch#enabled=1

set timeoutlen=180
set ttimeoutlen=180

let mapleader=';'
nnoremap <Leader>c :copen 5<CR>
nnoremap <Leader>cx :cclose<CR>
nnoremap <Leader>m :nohls<CR>
nnoremap <Leader>n :cn<CR>
nnoremap <Leader>b :cp<CR>
" work strange when I try to choose from quickfix window
" nnoremap <C-N> :cn<CR>
" nnoremap <C-M> :cp<CR>
" the grep trick
nnoremap <Leader>g : silent execute "grep \'\\<".shellescape(expand("<cword>"))."\\>\' -r . --exclude=tags --exclude-dir=.git "
nnoremap <Leader>gg : silent execute "grep \'\\<".shellescape(expand("<cword>"))."\\>\' -r . --exclude=tags --exclude-dir=.git "<CR>:redraw!<CR>:copen 5<CR>

"inoremap <C-o> <CR>
"nnoremap <C-h> <pageup>
"nnoremap <C-l> <pagedown>

map <Leader>f <Plug>(easymotion-f)
map <Leader><Leader>f <Plug>(easymotion-F)

" search visually selected text
vnoremap // y/<C-R>"<CR>

" set wrap lbr
" set fo+=mM

" highlight current line
set cul
"hi CursorLine cterm=NONE ctermbg=8 ctermfg=none

" Disable YCM syntax check
let g:ycm_register_as_syntastic_checker=0

set completeopt-=preview

" Popup menu color
hi Pmenu ctermfg=29 ctermbg=15 guibg=Magenta

" add file path to window title
set title
set autowrite
set background=dark
set incsearch

" restore cursor position in previous editing
function! ResCur()
	if line("'\"") <= line("$")
		normal! g`"
		return 1
	endif
endfunction

augroup resCur
	autocmd!
	autocmd BufWinEnter * call ResCur()
augroup END

" search result highlight
set hls

" ctags auto search
set tags=tags;

" undo after file close
set undofile

" NERDTree key-bind
nnoremap <F2> :NERDTree<CR>
nnoremap <F3> :NERDTreeToggle<CR>
nnoremap <F4> :TlistToggle<CR>

nnoremap <C-h> gT
nnoremap <C-l> gt

" find .ycm_extra.conf for YCM
let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/YouCompleteMe/third_party/ycmd/examples/.ycm_extra_conf.py'

" need ?
" let g:ycm_filetype_whitelist = { 'cpp': 1, 'c': 1, 'python':1, 'make':1 }

"set autochdir

" cscope
if has("cscope")
	set csprg=/usr/bin/cscope
	set csto=0
"	set cst
	set nocsverb
	nnoremap <C-j> :execute "cs find c ".expand("<cword>")<CR>
	nnoremap <C-f> :execute "cs find s ".expand("<cword>")<CR>
	nnoremap <C-g> :execute "cs find g ".expand("<cword>")<CR>
	" recursion add any database in current directory
	let cscope_db_recursion_level = 10
	let cscope_db_file = "cscope.out"
	while cscope_db_recursion_level >= 0
		if filereadable(cscope_db_file)
		    execute "cs add ".cscope_db_file
		endif
		let cscope_db_file = "../".cscope_db_file
		let cscope_db_recursion_level -= 1
	endwhile
	set csverb
	set cscopequickfix=s-,c-,d-,i-,t-,e-,g-
endif


let syn_inc_search_depth = 10
let b:synmake_inc = '.synchk_inc.mk'
let synmake_inc_path = expand('%:p:h').'/'
while syn_inc_search_depth >= 0
	if filereadable(synmake_inc_path.b:synmake_inc)
		execute 'cd '.synmake_inc_path
		break
	endif
	let synmake_inc_path = synmake_inc_path.'../'
	let syn_inc_search_depth -= 1
endwhile

function! Syn_chk()
	let l:src_filename = expand('%:p')
	let l:file_suffix = expand("%:e")
"	if l:file_suffix == 'c'
"		l:compile_cmd = 'CC'
"	elseif l:file_suffix == 'cc'
"		l:compile_cmd = 'CXX'
"	else
"		return
"	endif
	let l:obj_filename = '/tmp/syn_chk_obj'
	let l:makefile_name = '/tmp/syn_chk_makefile'
	silent execute '!if [ -f '.b:synmake_inc.' ];then; echo "include '.b:synmake_inc.'">'.l:makefile_name.';else; echo ""> '.l:makefile_name.';fi;echo "'.l:obj_filename.': '.l:src_filename.'">>'.l:makefile_name.';echo "	@\$(CXX) \$< -Wall -c -o \$@ \$(CFLAGS)">>'.l:makefile_name
	silent execute 'make -f '.l:makefile_name
	silent execute '!rm -f '.l:obj_filename
	redraw!
	try
		cc
	catch
		echo "No error!"
	endtry
endfunction

nnoremap <F5> :call Syn_chk()<CR>

python << EOF
import vim
def par_complete(insert):
	cw = vim.current.window
	cb = vim.current.buffer
	(row, col) = cw.cursor
	pref = cb[row-1][:col]
	suff = cb[row-1][col+1:]
	if len(suff) > 0:
		if suff[0].isalnum():
			insert = insert[0]
	cb[row-1] = pref+insert+suff
	cw.cursor = (row, col+1)

def par_enclose(insert):
	cw = vim.current.window
	cb = vim.current.buffer
	(row, col) = cw.cursor
	pref = cb[row-1][:col]
	suff = cb[row-1][col+1:]
	if len(suff) > 0:
		if suff[0] == insert:
			insert = ''
	cb[row-1] = pref+insert+suff
	cw.cursor = (row, col+1)

def quo_complete(quote):
	cw = vim.current.window
	cb = vim.current.buffer
	(row, col) = cw.cursor
	if col == 0:
		pref = ''
		suff = cb[row-1]
	else:
		pref = cb[row-1][:col+1]
		suff = cb[row-1][col+1:]
	if col+1 < len(cb[row-1]):
		if cb[row-1][col+1] == quote:
			quote = ''
		else:
			if not cb[row-1][col+1].isalnum():
				quote = quote+quote
	else:
		quote = quote+quote
	cb[row-1] = pref+quote+suff
	cw.cursor = (row, col+2)
EOF

function Par_complete(insert)
	let ch = getline('.')[col('.')-1]
	if (ch >= 'a' && ch <= 'z') || (ch >= 'A' && ch <= 'Z') || (ch >= '0' && ch <= '9')
		return a:insert[0]
	endif
	return a:insert."\<Left>"
endf

function Par_enclose(char)
	if getline('.')[col('.')-1] == a:char
		return "\<Right>"
	else
		return a:char
	endif
endf

function Quo_complete(quote)
	let ch = getline('.')[col('.')-1]
	if ch == a:quote
		return "\<Right>"
	endif
	if (ch >= 'a' && ch <= 'z') || (ch >= 'A' && ch <= 'Z') || (ch >= '0' && ch <= '9')
		return a:quote
	endif
	return a:quote.a:quote."\<Left>"
endf

function Py_Quo_complete(quote)
	let ch = getline('.')[col('.')-1]
	if ch == a:quote
		return "\<Right>"
	endif
	if (ch >= 'a' && ch <= 'z') || (ch >= 'A' && ch <= 'Z') || (ch >= '0' && ch <= '9')
		return a:quote
	endif
	let pref = getline('.')[col('.')-3:col('.')-2]
	if pref == a:quote.a:quote
		return a:quote.a:quote.a:quote.a:quote."\<Left>\<Left>\<Left>"
	endif
	return a:quote.a:quote."\<Left>"
endf

function Ext_CR()
	let ch1 = getline('.')[col('.')-2]
	let ch2 = getline('.')[col('.')-1]
	if (ch1 == '{' && ch2 == '}')
		return "\<CR>	\<CR>\<Up>\<End>"
	endif
	return "\<CR>"
endfunction

function! Profile4C(...)
	inoremap ( <C-r>=Par_complete('()')<CR>
	inoremap ) <C-r>=Par_enclose(')')<CR>
	inoremap " <C-r>=Quo_complete('"')<CR>
	inoremap ' <C-r>=Quo_complete("'")<CR>
	inoremap [ <C-r>=Par_complete('[]')<CR>
	inoremap ] <C-r>=Par_enclose(']')<CR>
	inoremap { <C-r>=Par_complete('{}')<CR>
	inoremap } <C-r>=Par_enclose('}')<CR>
	inoremap <CR> <C-r>=Ext_CR()<CR>
	nnoremap <Leader>w O/*  */<ESC>2hi
	nnoremap <Leader>ww O/*<CR><CR>/<ESC>ka<SPACE>
	if (0 == search('^\t', 'n'))
		call Usetab(0, 4)
	else
		if (a:0 > 0)
			call Usetab(1, a:1)
		else
			call Usetab(1, 8)
		endif
	endif
endfunction

" for python
function! Profile4Py()
	inoremap ( <C-r>=Par_complete('()')<CR>
	inoremap ) <C-r>=Par_enclose(')')<CR>
	inoremap [ <C-r>=Par_complete('[]')<CR>
	inoremap ] <C-r>=Par_enclose(']')<CR>
	inoremap " <C-r>=Py_Quo_complete('"')<CR>
	inoremap ' <C-r>=Py_Quo_complete("'")<CR>
	let $PYTHONPATH .= '/usr/lib/python3.5/site-packages'
endfunction

" put header to empty script file
function! AddHeader(header)
	if line('$') == 1 && getline(1) == ''
		silent call append(0, a:header)
		normal! G
	endif
endfunction

autocmd BufNewFile *.py :call AddHeader('#!/usr/bin/env python')
autocmd BufNewFile *.pl :call AddHeader('#!/usr/bin/env perl')
autocmd BufNewFile *.sh :call AddHeader('#!/bin/bash')
autocmd BufReadPost *.c :call Profile4C()
autocmd BufReadPost *.cc :call Profile4C()
autocmd BufReadPost *.cpp :call Profile4C(4)
autocmd BufReadPost *.cxx :call Profile4C()
autocmd BufReadPost *.h :call Profile4C()
autocmd BufReadPost *.lua :call Profile4C()
autocmd BufReadPost *.java :call Profile4C()
autocmd BufReadPost *.pl :call Profile4C()
autocmd BufReadPost *.py :call Profile4Py()
autocmd BufNewFile *.c :call Profile4C()
autocmd BufNewFile *.cc :call Profile4C()
autocmd BufNewFile *.cpp :call Profile4C()
autocmd BufNewFile *.cxx :call Profile4C()
autocmd BufNewFile *.h :call Profile4C()
autocmd BufNewFile *.lua :call Profile4C()
autocmd BufNewFile *.java :call Profile4C()
autocmd BufNewFile *.pl :call Profile4C()
autocmd BufNewFile *.py :call Profile4Py()

set fileencodings=utf-8,gbk,latin1

" for geek-note
let g:GeeknoteFormat="markdown"
