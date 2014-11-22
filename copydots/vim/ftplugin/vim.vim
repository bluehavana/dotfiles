setlocal tabstop=2
setlocal softtabstop=2
setlocal shiftwidth=2
setlocal textwidth=80
setlocal smarttab
setlocal expandtab

" Highlight matching braces
setlocal showmatch
" Show line and column number
setlocal ruler

" use :help for K
setlocal keywordprg=

" Set tab, non-breaking space, and \n to be visiable characters
setlocal listchars=tab:»\ ,eol:¬,nbsp:⚑
setlocal list

" Highlight extra whitespace at the end of a line
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
