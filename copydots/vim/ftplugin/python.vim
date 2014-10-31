setlocal tabstop=4
setlocal softtabstop=4
setlocal shiftwidth=4
setlocal textwidth=80
setlocal smarttab
setlocal expandtab

setlocal complete+=k~/.vim/syntax/python.vim isk+=.,(

setlocal smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class

" Highlight matching braces
setlocal showmatch
" Show line and column number
setlocal ruler

" use pydoc for K
setlocal keywordprg=pydoc

" Set tab and \n to be visiable characters
setlocal listchars=tab:»\ ,eol:¬
setlocal list

" Highlight extra whitespace at the end of a line
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
