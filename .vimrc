set statusline+=%o
set t_Co=256
set visualbell
set noerrorbells
set nocompatible
syntax on
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
set switchbuf=split,usetab
filetype plugin indent on
if !has("gui_running")
    set t_Co=256
    colorscheme jellybeans
else
    colorscheme jellybeans
endif

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
autocmd BufRead *.py set colorcolumn=80 makeprg=python\ -c\ \"import\ py_compile,sys;\ sys.stderr=sys.stdout;\ py_compile.compile(r'%')\"
autocmd BufRead *.py set efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m
autocmd FileType python set  colorcolumn=80 omnifunc=pythoncomplete#Complete
"autocmd BufRead,BufNewFile *.go       setlocal ft=go ts=8 sw=8 noexpandtab

autocmd BufRead *.java set makeprg=ant colorcolumn=80
autocmd BufRead *.java set efm=%A\ %#[javac]\ %f:%l:\ %m,%-Z\ %#[javac]\ %p^,%-C%.%#
"autocmd BufRead *.java set noexpandtab
autocmd BufRead *.jinc set filetype=jsp
autocmd BufRead *.email set filetype=velocity

augroup filetypedetect 
    au BufNewFile,BufRead *.pig set filetype=pig syntax=pig 
augroup END 


" Smart commenting - ,c to comment a line and ,u to uncomment
au FileType haskell,vhdl,ada let b:comment_leader = '-- '
au FileType vim let b:comment_leader = '" '
au FileType c,cpp,java let b:comment_leader = '// '
au FileType sh,make,python let b:comment_leader = '# '
au FileType tex let b:comment_leader = '% '
noremap <silent> ,c :<C-B>sil <C-E>s/^/<C-R>=escape(b:comment_leader,'\/')<CR>/<CR>:noh<CR>
noremap <silent> ,u :<C-B>sil <C-E>s/^\V<C-R>=escape(b:comment_leader,'\/')<CR>//e<CR>:noh<CR> 

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

autocmd Syntax html,vim inoremap < <lt>><Left>

function! SetupScreen(s)
    let g:screen_sessionname = a:s
    let g:screen_windowname = "1"
endfunction

nmap ,t :NERDTree<Enter>

set guifont=Menlo:h12

vnoremap P p<ESC>:let @@=@0<Enter>
vnoremap P p<ESC>:let @@=@0<Enter>


fun! s:SelectHTML()
  let n = 1
  while n < 50 && n < line("$")
    " check for jinja
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
set list listchars=tab:»·,trail:·

if has('autocmd')
    augroup gofmtBuffer
    au!
    " Convert tabs to spaces when we open the file
    autocmd BufReadPost  *.go retab!
    autocmd BufWritePre  *.go :call GoFormatBuffer()
    " Convert tabs to spaces after we reformat and save the file
    autocmd BufWritePost *.go retab!
    augroup END
endif

function! GoFormatBuffer()
    " Save our current position
    let curr=line(".")
    " Run gofmt
    %!${GOROOT}/bin/gofmt
    " Return to our saved position
    call cursor(curr, 1)
endfunction


let g:tagbar_type_go = {
    \ 'ctagstype': 'go',
    \ 'kinds' : [
        \'p:package',
        \'f:function',
        \'v:variables',
        \'t:type',
        \'c:const'
    \]
\}

