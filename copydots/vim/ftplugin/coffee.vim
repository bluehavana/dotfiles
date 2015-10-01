setlocal tabstop=2
setlocal softtabstop=2
setlocal shiftwidth=2
setlocal textwidth=80
setlocal expandtab

" Highlight matching braces
setlocal showmatch
" Show line and column number
setlocal ruler

" Set tab, non-breaking space, and \n to be visiable characters
setlocal listchars=tab:»\ ,eol:¬,nbsp:⚑
setlocal list

" Highlight trailing whitespace
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/

" these are experimental (especially the buffer-local autocmds) to only
" highlight when not in insert mode and the cursor is at the end of the line
" TODO: These infect the :match for other buffers (specifically the BufWinLeave)
"       so that clearmatches spans buffers
" autocmd BufWinEnter <buffer> match ExtraWhitespace /\s\+$/
" autocmd InsertEnter <buffer> match ExtraWhitespace /\s\+\%#\@<!$/
" autocmd InsertLeave <buffer> match ExtraWhitespace /\s\+$/
" autocmd BufWinLeave <buffer> call clearmatches()
