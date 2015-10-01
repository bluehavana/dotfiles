setlocal tabstop=8
setlocal softtabstop=8
setlocal shiftwidth=8
setlocal noexpandtab

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

