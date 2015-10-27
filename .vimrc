" scheme
colorscheme desert

" tab setting
set tabstop=4
set softtabstop=4
set shiftwidth=4
set noexpandtab
set smarttab
set cindent
set nu

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

" for Vundle
set nocompatible              " be iMproved  
filetype off                  " required!  

set rtp+=~/.vim/bundle/vundle/  
call vundle#rc()  

" let Vundle manage Vundle  
" required!   
" Bundle 'gmarik/vundle'  

" 可以通过以下四种方式指定插件的来源  
" a) 指定Github中vim-scripts仓库中的插件，直接指定插件名称即可，插件明中的空格使用“-”代替。  
" Bundle 'L9'  

" b) 指定Github中其他用户仓库的插件，使用“用户名/插件名称”的方式指定  
" Bundle 'tpope/vim-fugitive'  
" Bundle 'Lokaltog/vim-easymotion'  
" Bundle 'rstacruz/sparkup', {'rtp': 'vim/'}  
" Bundle 'tpope/vim-rails.git'  

" Bundle 'Conque-Shell'
Plugin 'scrooloose/nerdtree'
Plugin 'Xuyuanp/nerdtree-git-plugin'
" Bundle 'NERDTree'

" c) 指定非Github的Git仓库的插件，需要使用git地址  
" Bundle 'git://git.wincent.com/command-t.git'  

" d) 指定本地Git仓库中的插件  
" Bundle 'file:///Users/gmarik/path/to/plugin'  

filetype plugin indent on     " required!  
