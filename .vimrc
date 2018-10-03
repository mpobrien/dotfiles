set exrc
set secure
set t_Co=256
set visualbell
set noerrorbells
set nocompatible
syntax on
set nowrap
set smartindent
set autoindent
set tabstop=4
set softtabstop=4
set shiftwidth=4
set ruler
set incsearch
set virtualedit=all
set nu
set guioptions-=T
set guioptions-=m
set guioptions-=r
set backspace=indent,eol,start
set wildmenu
set wildmode=longest,list
set ic
set scs
"set cul
set wildignore="*/node_modules"
set switchbuf=split,usetab
filetype plugin indent on
if !has("gui_running")
    set t_Co=256
    colorscheme jellybeans
else
    colorscheme jellybeans
endif
nmap <silent>,t :Files<CR>
"nmap <silent>,t :CommandT<CR>
let g:ctrlp_cmd = ',t'


set winminheight=0

	map <C-J> <C-W>j<C-W>_
	map <C-K> <C-W>k<C-W>_
	map <C-L> <C-W>l<C-W>_
	map <C-H> <C-W>h<C-W>_
	map <C-K> <C-W>k<C-W>_
    nnoremap j gj
    nnoremap k gk
	map <S-H> gT
	map <S-L> gt


nmap <F8> :TagbarToggle<CR>

function! ClangFormat()
    let view = winsaveview()
    silent %!clang-format
    call winrestview(view)
endfunction

"open the tag under cursor, in a new tab
:nnoremap <silent><Leader><C-]> <C-w><C-]><C-w>T
autocmd BufRead *.py set colorcolumn=80 makeprg=python\ -c\ \"import\ py_compile,sys;\ sys.stderr=sys.stdout;\ py_compile.compile(r'%')\"
autocmd BufRead *.py set efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m
autocmd BufRead *.html set expandtab
autocmd BufRead *.js set colorcolumn=80 expandtab shiftwidth=2 tabstop=2 softtabstop=2
autocmd BufWrite *.c :call ClangFormat()
autocmd BufWrite *.h :call ClangFormat()
autocmd BufWrite *.cpp :call ClangFormat()
autocmd FileType python set colorcolumn=80 omnifunc=pythoncomplete#Complete expandtab sw=2 ts=2
autocmd FileType html set expandtab softtabstop=2 tabstop=2 shiftwidth=2
autocmd FileType gotplhtml set expandtab softtabstop=2 tabstop=2 shiftwidth=2
autocmd FileType javascript set colorcolumn=100 expandtab shiftwidth=2 tabstop=2 softtabstop=2

let g:prettier#autoformat = 0
autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md,*.vue PrettierAsync

"autocmd FileType javascript set formatprg=prettier\ --stdin
"autocmd BufWritePre *.js exe "normal! gggqG\<C-o>\<C-o>zz"

autocmd FileType go set colorcolumn=100
autocmd FileType go :GoInstallBinaries

"autocmd BufRead,BufNewFile *.go       setlocal ft=go ts=8 sw=8 noexpandtab

autocmd BufRead *.java set makeprg=ant colorcolumn=80 expandtab
autocmd BufRead *.java set efm=%A\ %#[javac]\ %f:%l:\ %m,%-Z\ %#[javac]\ %p^,%-C%.%#
"autocmd BufRead *.java set noexpandtab
autocmd BufRead *.jinc set filetype=jsp
autocmd BufRead *.email set filetype=velocity

augroup filetypedetect 
    au BufNewFile,BufRead *.pig set filetype=pig syntax=pig 
augroup END 


" Smart commenting - ,c to comment a line and ,u to uncomment
" au FileType haskell,vhdl,ada let b:comment_leader = '-- '
" au FileType vim let b:comment_leader = '" '
" "au FileType c,cpp,java,go let b:comment_leader = '// '
" au FileType sh,make,python,yaml let b:comment_leader = '# '
" au FileType tex let b:comment_leader = '% '
" noremap <silent> ,c :<C-B>sil <C-E>s/^/<C-R>=escape(b:comment_leader,'\/')<CR>/<CR>:noh<CR>
" noremap <silent> ,u :<C-B>sil <C-E>s/^\V<C-R>=escape(b:comment_leader,'\/')<CR>//e<CR>:noh<CR> 

function! InsertTabWrapper()
      let col = col('.') - 1
      if !col || getline('.')[col - 1] !~ '\k'
          return "\<tab>"
      else
          return "\<c-p>"
      endif
endfunction

inoremap <tab> <c-r>=InsertTabWrapper()<cr>

set foldcolumn=3
set foldmethod=marker
let g:showmarks_enable=0
let g:showmarks_include='abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
function! PreviewColor(rgbval)
	exec "hi temp guibg=" . a:rgbval
	echo a:rgbval
	echohl temp | echo "          " | echohl None
	echohl temp | echo "          " | echohl None
	echohl temp | echo "          " | echohl None
	echohl temp | echo "          " | echohl None
	echohl temp | echo "          " | echohl None
	echohl temp | echo "          " | echohl None
endfunction

"nmap ,t :NERDTree<Enter>

set guifont=Menlo:h12

vnoremap P p<ESC>:let @@=@0<Enter>


fun! s:SelectHTML()
  let n = 1
  while n < 50 && n < line("$")
    " check for go template
    if getline(n) =~ '{{\s*\(define\|template\|range\|with\)'
      set ft=gotplhtml
      return
    endif
    if getline(n) =~ '{%\s*\(extends\|block\|macro\|set\|if\|for\|include\|trans\)\>'
      set ft=htmljinja
      return
    endif
    " check for django
    if getline(n) =~ '{%\s*\(extends\|block\|comment\|ssi\|if\|for\|blocktrans\)\>'
      set ft=htmldjango
      return
    endif
    " check for mako
    if getline(n) =~ '<%\(def\|inherit\)'
      set ft=mako
      return
    endif
    " check for genshi
    if getline(n) =~ 'xmlns:py\|py:\(match\|for\|if\|def\|strip\|xmlns\)'
      set ft=genshi
      return
    endif
    let n = n + 1
  endwhile
  " go with html
  set ft=html
endfun

autocmd FileType html,xhtml,xml,htmldjango,htmljinja,eruby,mako setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2
autocmd BufNewFile,BufRead *.rhtml setlocal ft=eruby
autocmd BufNewFile,BufRead *.mako setlocal ft=mako
autocmd BufNewFile,BufRead *.tmpl setlocal ft=htmljinja
autocmd BufNewFile,BufRead *.py_tmpl setlocal ft=python
autocmd BufNewFile,BufRead *.html,*.htm  call s:SelectHTML()
autocmd FileType css setlocal expandtab shiftwidth=4 tabstop=4 softtabstop=4
set list listchars=tab:●·,trail:·

let g:slime_target = "tmux"


call plug#begin('~/.vim/plugged')
" On-demand loading
Plug 'nanotech/jellybeans.vim'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'wincent/Command-T'
Plug 'fatih/vim-go'
Plug 'mattn/emmet-vim'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'pangloss/vim-javascript'
"Plug 'mxw/vim-jsx'
Plug 'Chiel92/vim-autoformat'
"Plug 'Valloric/YouCompleteMe'
Plug 'majutsushi/tagbar'
Plug 'gf3/peg.vim'
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'tomtom/tlib_vim'
Plug 'garbas/vim-snipmate'
Plug 'ternjs/tern_for_vim', { 'do': 'npm install' }

Plug 'rdnetto/YCM-Generator', { 'branch': 'stable' }
Plug 'leafgarland/typescript-vim'

Plug 'w0rp/ale'

Plug 'neoclide/vim-jsx-improve'
Plug 'justinj/vim-pico8-syntax'

Plug 'keith/swift.vim'
Plug 'cespare/vim-toml'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'jpalardy/vim-slime.git'
Plug 'pboettch/vim-cmake-syntax'

Plug 'prettier/vim-prettier', {
  \ 'do': 'yarn install',
  \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue'] }


" Add plugins to &runtimepath
call plug#end()

" Override eslint with local version where necessary.
"let local_eslint = finddir('node_modules', '.;') . '/.bin/eslint'
"if matchstr(local_eslint, "^\/\\w") == ''
  "let local_eslint = getcwd() . "/" . local_eslint
"endif
"if executable(local_eslint)
  "let g:syntastic_javascript_eslint_exec = local_eslint
"endif

"let g:syntastic_javascript_eslint_args = ['--fix']
" enable autoread to reload any files from files when checktime is called and
" the file is changed
"set autoread
"au VimEnter *.js au BufWritePost *.js checktime

highlight Pmenu ctermbg=238 gui=bold
set tabpagemax=100

vnoremap <C-r> "hy:%s/<C-r>h//g<left><left>

hi QuickFixLine term=reverse ctermbg=52

