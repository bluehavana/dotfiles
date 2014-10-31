setlocal tabstop=2
setlocal shiftwidth=2
setlocal softtabstop=2
setlocal expandtab

set smartindent

" Highlight matching braces
set showmatch
" Show line and column number
set ruler
set number

" use ri for K
setlocal keywordprg=ri

" Set tab and \n to be visiable characters
set listchars=tab:»\ ,eol:¬
set list

" Highlight extra whitespace at the end of a line
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
