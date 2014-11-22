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

" Set tab, non-breaking space, and \n to be visiable characters
setlocal listchars=tab:»\ ,eol:¬,nbsp:⚑
set list

" Highlight extra whitespace at the end of a line
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
