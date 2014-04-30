setlocal tabstop=2
setlocal softtabstop=2
setlocal shiftwidth=2
setlocal textwidth=80
setlocal smarttab
setlocal expandtab


" setlocal smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class

" Highlight matching braces
setlocal showmatch
" Show line and column number
setlocal ruler

" Set tab and \n to be visiable characters
setlocal listchars=tab:»\ ,eol:¬
setlocal list

" Highlight extra whitespace at the end of a line
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/

DelimitMateSwitch
