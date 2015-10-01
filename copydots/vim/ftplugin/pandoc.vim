let g:pandoc_no_folding = 1

setlocal tabstop=4
setlocal softtabstop=4
setlocal shiftwidth=4
setlocal textwidth=80
setlocal expandtab

" setlocal smartindent cinwords=\\begin\{equation*},\\begin{array\},\\begin\{verbatim\},\\begin\{enumerate\}

" Highlight matching braces
setlocal showmatch
" Show line and column number
setlocal ruler

" Set tab, non-breaking space, and \n to be visiable characters
setlocal listchars=tab:»\ ,eol:¬,nbsp:⚑
setlocal list

" Highlight extra whitespace at the end of a line
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
