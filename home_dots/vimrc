call pathogen#runtime_append_all_bundles()
call pathogen#helptags()

" vim behaves like vim and not vi
set nocompatible

syntax on
set mouse=n
" Hide mouse when typing
set mousehide

set background=dark
colorscheme vibrantink

filetype plugin indent on

set laststatus=2
set ruler
set number

let NERDTreeIgnore=['\.pyc']

if has("autocmd")
  autocmd BufNewFile,BufRead *.rss setfiletype xml
endif

if exists('+colorcolumn')
  set colorcolumn=81
else
  au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>81v.\+', -1)
endif

set spelllang=eng_US
