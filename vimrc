"execute pathogen#infect()
syntax on
filetype plugin indent on

" Rats
set mouse=a

" Folding
set foldenable
set foldmethod=indent
set foldlevel=1  " Show class and def, for example
set foldnestmax=4
highlight Folded ctermbg=grey ctermfg=green
highlight Comment ctermfg=green
highlight String ctermfg=9
" Space to open current fold
nnoremap <space> zA

" Searching
set incsearch  " Incremental Search

" Display
set modeline
set textwidth=79
set colorcolumn=+2
hi ColorColumn ctermbg=5
set list
set listchars=tab:>-,trail:_,extends:<,precedes:>
set backspace=indent,eol,start
set cmdheight=1
set scrolloff=4
set laststatus=2
set shortmess=a

set statusline=%<%f%h%m%r%=%b\ 0x%B\ \ %l,%c%V\ %P

" Spelling
hi clear SpellBad
hi SpellBad cterm=underline
"set spell
set spellfile=~/.vim-spell.en.utf-8.add

" Line Numbers
set number relativenumber
hi LineNr ctermfg=black ctermbg=grey
hi CursorLineNr ctermfg=black ctermbg=white

:autocmd BufRead,BufNewFile *.yaml setlocal shiftwidth=2 tabstop=2
:autocmd BufRead,BufNewFile *.html setlocal shiftwidth=2 softtabstop=2 syntax=html expandtab

" Turn on spell-checking in python files. This will only check in strings
:autocmd BufRead,BufNewFile *.py setlocal spell

let g:syntastic_python_checkers = ["python", "flake8", "pylint"]
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
