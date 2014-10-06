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

" Set tab and \n to be visiable characters
setlocal listchars=tab:»\ ,eol:¬
setlocal list

highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

