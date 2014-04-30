setlocal tabstop=2
setlocal softtabstop=2
setlocal shiftwidth=2
setlocal expandtab


setlocal smartindent

" Highlight matching braces
setlocal showmatch
" Show line and column number
setlocal ruler
setlocal number

" Set tab and \n to be visiable characters
setlocal listchars=tab:»\ ,eol:¬
setlocal list

" Highlight extra whitespace at the end of a line
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/

DelimitMateSwitch
