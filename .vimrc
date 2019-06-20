" Syntax{{{
set modelines=1
filetype plugin indent on
set backspace=indent,eol,start
set number
set scrolloff=10
set splitbelow
set splitright
set incsearch
syntax enable
" }}}
" Functions {{{
function! StripTrailingWhitespaces()
	" save last search & cursor position
	let _s=@/
	let l = line(".")
	let c = col(".")
	%s/\s\+$//e
	let @/=_s
	call cursor(l, c)
endfunction

nnoremap <leader>s :call StripTrailingWhitespaces()<CR>

function! DecryptFilePre()
	set viminfo=
	set noswapfile
	set nowritebackup
	set nobackup
	set bin
	set spell
	set scrolloff=16
	let g:deoplete#disable_auto_complete=1
	nnoremap <buffer> <F3> o<ESC>o<ESC>i-<ESC>44.o<C-R>=strftime("%a %d %b %Y %l:%M:%S %p %Z")<CR><ESC>kyyjpoTITLE:
	inoremap *shrug* ¯\_ツ_/¯
endfunction

function! DecryptFilePost()
	:%!gpg -d 2>/dev/null
	set nobin
	set filetype=markdown
endfunction

function! EncryptFilePre()
	set bin
	:%!gpg --symmetric --cipher-algo AES256 2>/dev/null
endfunction

function! EncryptFilePost()
	silent u
	set nobin
	set filetype=markdown
endfunction

function! BufSel(pattern)
	let bufcount = bufnr("$")
	let currbufnr = 1
	let nummatches = 0
	let firstmatchingbufnr = 0
	while currbufnr <= bufcount
		if(bufexists(currbufnr))
			let currbufname = bufname(currbufnr)
			if(match(currbufname, a:pattern) > -1)
				echo currbufnr . ": ". bufname(currbufnr)
				let nummatches += 1
				let firstmatchingbufnr = currbufnr
			endif
		endif
		let currbufnr = currbufnr + 1
	endwhile
	if(nummatches == 1)
		execute ":buffer ". firstmatchingbufnr
	elseif(nummatches > 1)
		let desiredbufnr = input("Enter buffer number: ")
		if(strlen(desiredbufnr) != 0)
			execute ":buffer ". desiredbufnr
		endif
	else
		echo "No matching buffers"
	endif
endfunction
function! ToggleComment(commentPrefix)
	let initialMatch="^\\s*" . a:commentPrefix . ".*$"
	if matchstr(getline(line(".")),initialMatch) == ''
		:let executeString="s:^\\(^\\s*\\):\\1" . a:commentPrefix . " :"
	else
		:let executeString="s:\\(^\\s*\\)" . a:commentPrefix . "\\s*:\\1:"
	endif
	:execute executeString
endfunction

function! MaximizeToggle()
	if exists("s:maximize_session")
		exec "source " . s:maximize_session
		call delete(s:maximize_session)
		unlet s:maximize_session
		let &hidden=s:maximize_hidden_save
		unlet s:maximize_hidden_save
	else
		let s:maximize_hidden_save = &hidden
		let s:maximize_session = tempname()
		set hidden
		exec "mksession! " . s:maximize_session
		only
	endif
endfunction
fun! SetupCommandAlias(from, to)
	exec 'cnoreabbrev <expr> '.a:from
				\ .' ((getcmdtype() is# ":" && getcmdline() is# "'.a:from.'")'
				\ .'? ("'.a:to.'") : ("'.a:from.'"))'
endfun
" }}}
" Spaces and tabs {{{
set tabstop=4
set softtabstop=4
set shiftwidth=4
set linebreak
set whichwrap=[,]
" }}}
" Highlighting {{{
colorscheme elflord
set hlsearch
set wildmenu
set showmatch
highlight DiffAdd    cterm=bold ctermfg=10 ctermbg=17 gui=none guifg=bg guibg=Red
highlight DiffDelete cterm=bold ctermfg=10 ctermbg=17 gui=none guifg=bg guibg=Red
highlight DiffChange cterm=bold ctermfg=10 ctermbg=17 gui=none guifg=bg guibg=Red
highlight DiffText   cterm=bold ctermfg=10 ctermbg=88 gui=none guifg=bg guibg=Red

syn match OpenBraces /{{/ conceal
syn match CloseBraces /}}/ conceal
set conceallevel=2
hi MyItalics gui=italic cterm=italic term=italic ctermfg=Blue
hi SpellBad ctermbg=0 ctermfg=3
hi MatchParen term=reverse ctermbg=1 guibg=DarkCyan
highlight Conceal ctermfg=255 ctermbg=0
"}}}
" Mapleader {{{
nnoremap <SPACE> <Nop>
let mapleader="\<SPACE>"
let maplocalleader="\<SPACE>"
"}}}
" Normal Mode mappings {{{

command! W w
command! Q q
command! Wq wq
command! Wqa wqa
command! Qa qa

nnoremap j gj
nnoremap k gk
" Highlight the last inserted text
nnoremap gV `[v`]

" Switch windows
nnoremap <C-h> <C-W>h
nnoremap <C-l> <C-W>l
nnoremap <C-k> <C-W>k
nnoremap <C-j> <C-W>j

" Cut and paste
vnoremap <C-C> "+y
vnoremap < <gv
vnoremap > >gv
nnoremap <C-V><C-V> "+p

" json format
nnoremap <F5> :%!python -m json.tool<CR>
nnoremap <F4> :%!xmllint --format -<CR>
nnoremap <F6> :tabn<CR>

nnoremap <leader>n :bNext<CR>
nnoremap <leader>m :bprevious<CR>

" quit window
nnoremap <leader>q :q<CR>

"turn off highlighting
nnoremap <leader>/ :set hlsearch!<CR>

call SetupCommandAlias("W","w")
call SetupCommandAlias("Q","q")
" }}}
" {{{ Terminal Mode
tnoremap jk <C-\><C-n>
nnoremap <leader>z :terminal<CR>asource ~/.bash_profile<CR>clear<CR>
" }}}
" Folding {{{
set foldenable
set foldlevelstart=10
set foldmethod=indent

" }}}
" Insert Mode mappings {{{
inoremap jk <ESC>
" }}}
" Plugins {{{
if empty(glob('~/.vim/autoload/plug.vim'))
	silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
	\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
call plug#begin('~/.vim/plugged')
	function! DoRemote(arg)
		UpdateRemotePlugins
	endfunction
	" Table mode
	Plug 'dhruvasagar/vim-table-mode'
	let g:table_mode_header_fillchar='='

	" NerdTree
	Plug 'scrooloose/nerdtree'

	" Gen stuff
	Plug 'tpope/vim-surround'
	Plug 'beloglazov/vim-online-thesaurus' "Thesaurus
	Plug 'szw/vim-dict' " Dictionart
	
	Plug 'roxma/vim-hug-neovim-rpc'
	Plug 'roxma/nvim-yarp'
	Plug 'Shougo/deoplete.nvim'
	""" C plugins
	" Plug 'vim-scripts/c.vim' "IDE
	" Plug 'ludovicchabant/vim-gutentags' " Ctags

	""" vim-go
	Plug 'fatih/vim-go', { 'do' : ':GoInstallBinaries' }  

	""" fuzzy find files
	Plug 'ctrlpvim/ctrlp.vim'

	""" csv files
	Plug 'chrisbra/csv.vim'

	""" Markdown
	" Plug 'kurocode25/mdforvim/'

	""" ultisnips
	" Plug 'SirVer/ultisnips'

	""" rust
	Plug 'rust-lang/rust.vim'
	Plug 'racer-rust/vim-racer'

	" Plug 'stamblerre/gocode', { 'rtp': 'nvim', 'do': '~/.config/nvim/plugged/gocode/nvim/symlink.sh' }
	""" For note taking
	Plug 'vimwiki/vimwiki', { 'branch': 'dev' }

	""" For async linting
	Plug 'neomake/neomake'

	Plug 'christoomey/vim-tmux-navigator'
	""" For file structure
	Plug 'majutsushi/tagbar'

	""" Tags
	Plug 'ludovicchabant/vim-gutentags'
	Plug 'vim-airline/vim-airline'
	""" Searching
	Plug 'jremmen/vim-ripgrep'
	Plug 'SirVer/ultisnips'
	" Flow diagrams
	Plug 'tyru/open-browser.vim'
	Plug 'weirongxu/plantuml-previewer.vim'
	Plug 'aklt/plantuml-syntax'

	" Tmux navigation
	Plug 'christoomey/vim-tmux-navigator'

	call plug#end()
"}}}
" Plugins Configuration {{{
	"NerdTree
	nnoremap <F2> :NERDTreeToggle<CR>
	nnoremap <leader>ff :NERDTreeFind<CR>

	" Deoplete
	let g:deoplete#enable_at_startup = 1

	call deoplete#custom#source('ultisnips', 'matchers', ['matcher_fuzzy'])

	" Highlight
	let g:go_highlight_functions = 1  
	let g:go_highlight_methods = 1  
	let g:go_highlight_structs = 1  
	let g:go_highlight_operators = 1  
	let g:go_def_mode='godef'

	" close preview when leaving insert mode
	autocmd InsertLeave * if pumvisible() == 0 | pclose | endif

	""" vimwiki
	let wiki_1 = {}
	let wiki_1.path = '~/Private/notes/'
	let wiki_1.path_html = '~/Private/notes/html/'
	let wiki_1.nested_syntaxes = {'python': 'python', 'c++': 'cpp', 'c': 'c'}
	let wiki_1.index = 'main'
	let wiki_1.template_path = '~/Private/notes/templates/'
	let wiki_1.template_default = 'default'
	let wiki_1.template_ext= '.html'
	let wiki_1.css_name = 'prism.css'
	let g:vimwiki_list = [wiki_1]
	let g:vimwiki_table_mappings = 0


    let g:vimwiki_list = [wiki_1]
	
	" vim dictionary
	nnoremap <leader>D :execute 'Dict ' . shellescape(expand('<cword>'))<CR>
	
	" Ulti snips
	let g:UltiSnipsExpandTrigger="<tab>"
	let g:UltiSnipsSnippetDirectories=["custom_snippets"]
" vim:foldmethod=marker:foldlevel=1
" }}}
" Unicode aliases {{{
" }}}
" Autocommands {{{
autocmd FileType cpp set keywordprg=:term\ cppman
augroup filetype_go
	au!
	let g:go_metalinter_autosave = 1
	let g:go_auto_type_info = 1
	let g:go_term_mode = "10split"
	autocmd FileType go nnoremap <buffer> <F3> :GoRun<CR>
	autocmd FileType go nnoremap <buffer> <localleader>d :GoDef<CR>
	autocmd FileType go nnoremap <buffer> <localleader>b :GoDoc<CR>
	autocmd FileType go nnoremap <buffer> <localleader>o <C-o>
	autocmd FileType go nnoremap <buffer> <localleader>i <C-i>
	autocmd FileType go set foldlevel=2
	autocmd FileType go nnoremap <buffer> <F3> :GoRun<CR>
	autocmd FileType go nnoremap <buffer> <F12> :TagbarToggle<CR>
	autocmd FileType go nnoremap GA :GoAlternate<CR>
	autocmd FileType go vnoremap <C-A> <ESC>:call Comment()<CR>'<
augroup end
augroup encrypted_dia
	autocmd!
	autocmd FileReadPre,BufReadPre *.dia.gpg call DecryptFilePre()
	autocmd FileReadPost,BufReadPost *.dia.gpg call DecryptFilePost()
	autocmd FileWritePre,BufWritePre *.dia.gpg call EncryptFilePre()
	autocmd FileWritePost,BufWritePost *.dia.gpg call EncryptFilePost()
	autocmd FileType *.dia.gpg call deoplete#custom#option('auto_complete', v:false)
augroup end
augroup filetype_rust
	au!
	autocmd FileType rust nnoremap <buffer> <F3> :RustRun<CR>
	autocmd FileType rust nnoremap <F12> :TagbarToggle<CR>
	au FileType rust nmap gd <Plug>(rust-def)
	au FileType rust nmap gs <Plug>(rust-def-split)
	au FileType rust nmap gx <Plug>(rust-def-vertical)
	au FileType rust nmap <leader>gd <Plug>(rust-doc)
augroup end
augroup filetype wiki
	au!
	autocmd!
	autocmd BufEnter *.wiki vmap 4 S$
	autocmd BufEnter *.wiki let @o='F)2lv$hyi[[#A|pa]]Go=== pa ===o[[#Table of contents:|Back to TOC]]<br/>'
	autocmd BufEnter *.wiki let @s="istyle=\"width:600px;\""
	autocmd BufEnter *.wiki set wrap
augroup end
" }}} vim:foldmethod=marker:foldlevel=10

source ~/.config/nvim/python_host.vim " let g:python3_host_prog = '/path/to/python/virtual/env/bin/python'
