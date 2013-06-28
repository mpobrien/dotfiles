set statusline+=%o
set t_Co=256
set visualbell
set noerrorbells
set nocompatible
syntax on
set smartindent
set autoindent
set expandtab
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
set cul
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
autocmd BufRead *.py set makeprg=python\ -c\ \"import\ py_compile,sys;\ sys.stderr=sys.stdout;\ py_compile.compile(r'%')\"
autocmd BufRead *.py set efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m
autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd BufRead *.go set filetype=go
autocmd BufRead *.java set makeprg=ant
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


call NERDTreeAddKeyMap({
       \ 'key': 'yy',
       \ 'callback': 'NERDTreeYankNode',
       \ 'quickhelpText': 'yank current node to buffer' })

call NERDTreeAddKeyMap({
       \ 'key': 'ya',
       \ 'callback': 'NERDTreeYankPath',
       \ 'quickhelpText': 'yank current node path to default register' })

call NERDTreeAddKeyMap({
       \ 'key': 'dd',
       \ 'callback': 'NERDTreeCutNode',
       \ 'quickhelpText': 'cut current node to buffer' })

call NERDTreeAddKeyMap({
       \ 'key': 'p',
       \ 'callback': 'NERDTreePasteToNode',
       \ 'quickhelpText': 'paste buffer to current node' })

call NERDTreeAddKeyMap({
       \ 'key': 'DD',
       \ 'callback': 'NERDTreeRmNode',
       \ 'quickhelpText': 'remove current node recursively' })

let g:SzToolNodeBuf = ""
let g:SzToolOpType = ""
let g:SzToolParentOfRmNode = {}


function! NERDTreeYankNode()
  call NodeToBuf("yank")
endfunction

function! NERDTreeCutNode()
  call NodeToBuf("cut")
endfunction

function! NERDTreeYankPath()
    let curNode = g:NERDTreeFileNode.GetSelected()
    if curNode != {}
        echomsg 'node: ' . curNode.path.str() . " path yanked to @0. "
        let @" = curNode.path.str()
    endif
endfunction

function! NERDTreeRmNode()
    let curNode = g:NERDTreeFileNode.GetSelected()
    let parent = curNode.parent
    let curPath = curNode.path.str()
    python FileUtil.fileOrDirRm(vim.eval("curPath"))
    call parent.refresh()
    call NERDTreeRender()
endfunction

function! NERDTreePasteToNode()
    let curNode = g:NERDTreeFileNode.GetSelected()
    if curNode == {}
      return
    endif 
    let curPath = curNode.path.str()
    if g:SzToolNodeBuf != ""
      if g:SzToolOpType == "yank" 
        python FileUtil.fileOrDirCp(vim.eval("g:SzToolNodeBuf"),vim.eval("curPath"))
      else
        python FileUtil.fileOrDirMv(vim.eval("g:SzToolNodeBuf"),vim.eval("curPath"))
      endif
      echomsg 'node: ' . curNode.path.str() . " pasted. "
      let g:SzToolNodeBuf = ""
      call curNode.refresh()
      if g:SzToolParentOfRmNode != {}
        call g:SzToolParentOfRmNode.refresh()
      endif
      call NERDTreeRender()
    endif
endfunction


function! NodeToBuf(opType)
    let curNode = g:NERDTreeFileNode.GetSelected()
    if curNode != {}
        echomsg 'node: ' . curNode.path.str() . " yanked. "
        let g:SzToolNodeBuf = curNode.path.str()
        let g:SzToolOpType = a:opType
        let g:SzToolParentOfRmNode = curNode.parent
    endif
endfunction

