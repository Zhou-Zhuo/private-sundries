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
" Plugin 'scrooloose/syntastic'
 
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
set tabstop=8
set softtabstop=8
set shiftwidth=8
set noexpandtab
set smarttab
set cindent
set nu


" setting for airline status-line
set laststatus=2

" show command typing in normal mode on status-line
set showcmd

" Problem maybe in vim-airline/autoload/airline/highlighter.vim:116
" And do not use hybrid theme

set background=dark
"set t_Co=256
"let g:solarized_termcolor=256
"colorscheme solarized
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

nnoremap <Leader>w i/*  */<ESC>2hi
nnoremap <Leader>ww i/*<CR><CR>/<ESC>ka<SPACE>
inoremap <C-o> <CR>
nnoremap <C-h> <pageup>
nnoremap <C-l> <pagedown>

map <Leader>f <Plug>(easymotion-f)
map <Leader><Leader>f <Plug>(easymotion-F)

" set wrap lbr
" set fo+=mM

" highlight current line
set cul
"hi CursorLine cterm=NONE ctermbg=8 ctermfg=none

" Disable YCM syntax check
let g:ycm_register_as_syntastic_checker=0

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

" NERDTree key-bind
nnoremap <F2> :NERDTree<CR>
nnoremap <F3> :NERDTreeToggle<CR>
nnoremap <F4> :TlistToggle<CR>

"nnoremap <C-k> :b#<CR>


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
endif

set cscopequickfix=s-,c-,d-,i-,t-,e-,g-


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
	let l:obj_filename = '/tmp/syn_chk_obj'
	let l:makefile_name = '/tmp/syn_chk_makefile'
	silent execute '!if [ -f '.b:synmake_inc.' ];then; echo "include '.b:synmake_inc.'">'.l:makefile_name.';else; echo ""> '.l:makefile_name.';fi;echo "'.l:obj_filename.': '.l:src_filename.'">>'.l:makefile_name.';echo "	@\$(CC) \$< -Wall -c -o \$@ \$(CFLAGS)">>'.l:makefile_name
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

inoremap ( ()<Left>
inoremap { {<CR> <CR>}<Up><End><Backspace>
inoremap () ()
inoremap {} {}
