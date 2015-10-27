" for Vundle
set nocompatible              " be iMproved  
filetype off                  " required!  

set rtp+=~/.vim/bundle/vundle/  
call vundle#rc()  

" let Vundle manage Vundle  
" required!   
Plugin 'gmarik/vundle'  

" 可以通过以下四种方式指定插件的来源  
" a) 指定Github中vim-scripts仓库中的插件，直接指定插件名称即可，插件明中的空格使用“-”代替。  
" Plugin 'L9'  

" b) 指定Github中其他用户仓库的插件，使用“用户名/插件名称”的方式指定  
" Plugin 'tpope/vim-fugitive'  
" Plugin 'Lokaltog/vim-easymotion'  
" Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}  
" Plugin 'tpope/vim-rails.git'  

Plugin 'Conque-Shell'
Plugin 'scrooloose/nerdtree'
Plugin 'Xuyuanp/nerdtree-git-plugin'
Plugin 'bling/vim-airline'
" Plugin 'Lokaltog/vim-powerline'

" c) 指定非Github的Git仓库的插件，需要使用git地址  
" Plugin 'git://git.wincent.com/command-t.git'  

" d) 指定本地Git仓库中的插件  
" Plugin 'file:///Users/gmarik/path/to/plugin'  

filetype plugin indent on     " required!  

" scheme
colorscheme desert

" set font
set guifont=Bitstream\ Vera\ Sans\ Mono\ 11

" tab setting
set tabstop=4
set softtabstop=4
set shiftwidth=4
set noexpandtab
set smarttab
set cindent
set nu

" setting for airline status-line
set laststatus=2

" Problem maybe in vim-airline/autoload/airline/highlighter.vim:116
" And do not use hybrid theme

let g:airline_powerline_fonts = 1
let g:bufferline_echo = 0
let g:airline_theme = 'kolor'
" AirlineTheme hybrid
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_rght_alt_sep = ''
if !exists('g:airline_symbols')
	let g:airline_symbols = {}
endif
let g:airline#extensions#hunks#enabled=0
let g:airline#extensions#branch#enabled=1
" TODO: Make branch status visiable
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''

" highlight current line
set cul
hi CursorLine   cterm=NONE ctermbg=grey ctermfg=none

" add file path to window title
set title

set autowrite

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
map <F3> :NERDTreeToggle<CR>

