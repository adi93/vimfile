" Syntax{{{
set modelines=1
set backspace=indent,eol,start
set number
set scrolloff=10
set splitbelow
set splitright
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
	set scrolloff=16
	" let g:deoplete#disable_auto_complete=1
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
" }}}
" Spaces and tabs {{{
set tabstop=4
set softtabstop=4
set shiftwidth=4
set linebreak
set whichwrap=[,]
" }}}
" Highlighting {{{
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
nnoremap j gj
nnoremap k gk
" Highlight the last inserted text
nnoremap gV `[v`]

nnoremap <C-E> :tabn<CR>
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
nnoremap <C-[> <C-t>

nnoremap <leader>n :bNext<CR>
nnoremap <leader>m :bprevious<CR>

" quit window
nnoremap <leader>q :q<CR>

"turn off highlighting
nnoremap <leader>/ :set hlsearch!<CR>

" Maximize a split
nnoremap <C-W>O :call MaximizeToggle()<CR>
nnoremap <C-W>o :call MaximizeToggle()<CR>
" }}}
" {{{ Terminal Mode
nnoremap <leader>z :new<CR>:resize 8<CR>:set wfh<CR>:terminal<CR>asource $HOME/.bash_profile<CR>PS1="\h:\W \u$ "<CR>source ~/python/neovim/bin/activate<CR>clear<CR>
nnoremap <leader>zz :botright vnew<CR>:vertical resize 25<CR>:set wfw<CR>:terminal<CR>asource $HOME/.bash_profile<CR>PS1="\h:\W \u$ "<CR>source ~/python/neovim/bin/activate<CR>clear<CR>
tnoremap jk <C-\><C-n>
tnoremap <C-j> <C-\><C-n><C-W><C-j>
tnoremap <C-h> <C-\><C-n><C-W><C-h>
tnoremap <C-k> <C-\><C-n><C-W><C-k>
tnoremap <C-l> <C-\><C-n><C-W><C-l>
tnoremap <C-E> <C-\><C-n>:tabn<CR>
" }}}
" Folding {{{
set foldenable
set foldlevelstart=10
set foldmethod=indent

" }}}
" Insert Mode mappings {{{
inoremap jk <ESC>
" }}}
" Plugins{{{
if empty(glob('~/.config/nvim/autoload/plug.vim'))
	silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
	\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
call plug#begin('~/.config/nvim/plugged')
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

	Plug 'tpope/vim-dispatch' "Asynch execution

	Plug 'roxma/vim-hug-neovim-rpc'
	Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' } "Autocomplete

	""" C plugins
	Plug 'ludovicchabant/vim-gutentags' " Ctags

	"""vim-go
	Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

	Plug 'stamblerre/gocode', { 'rtp': 'nvim', 'do': '~/.config/nvim/plugged/gocode/nvim/symlink.sh' }
	""" For note taking
	Plug 'vimwiki/vimwiki', { 'branch': 'dev' }

	""" ultisnips
	Plug 'SirVer/ultisnips'

	""" For async linting
	" Plug 'neomake/neomake'

	""" For Tagbar
	Plug 'majutsushi/tagbar'

	""" Airline
	Plug 'vim-airline/vim-airline'

	""" fugitive, for git
	Plug 'tpope/vim-fugitive'

	Plug 'python-mode/python-mode', { 'branch': 'develop' }

	""" Searching
	Plug 'jremmen/vim-ripgrep'
	Plug 'adi93/go-test'

	Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
	Plug 'junegunn/fzf.vim'

	Plug 'airblade/vim-gitgutter'

	Plug 'SirVer/ultisnips'

	"Language server
	" Plug 'natebosch/vim-lsc'
	" tags

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

	" Deoplete
	let g:deoplete#enable_at_startup = 1

	call deoplete#custom#source('ultisnips', 'matchers', ['matcher_fuzzy'])

	" Highlight
	" let g:go_highlight_functions = 1
	" let g:go_highlight_methods = 1
	" let g:go_highlight_structs = 1
	" let g:go_highlight_operators = 1

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

	" vim dictionary
	nnoremap <leader>d :execute 'Dict ' . shellescape(expand('<cword>'))<CR>
	if exists("g:ctrlp_user_command")
		unlet g:ctrlp_user_command
	endif
	let g:ctrlp_max_depth = 40
	let g:ctrlp_max_files=0
	set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.class,*/target/*,*/test/*
	let g:deoplete#sources#rust#racer_binary='/Users/aditya/.cargo/bin/racer'
	let g:deoplete#sources#rust#rust_source_path='/Users/aditya/Private/notes/study/rust/rust-source-code/src'

	" Ulti snips
	let g:UltiSnipsExpandTrigger="<tab>"
	let g:UltiSnipsSnippetDirectories=["custom_snippets"]

	" Language server
	let g:lsc_server_commands = {'go': 'bingo'}
	let g:lsc_auto_map = v:true " Use defaults
" vim:foldmethod=marker:foldlevel=1
" }}}
" {{{ colorscheme
colorscheme elflord
" }}}
" Cscope {{{
" }}}
" Unicode aliases {{{
" }}}
" Autocommands {{{
autocmd FileType cpp set keywordprg=:term\ cppman
autocmd! BufWritePost ~/.config/nvim/init.vim source %
autocmd! BufWritePost ~/.config/nvim/plugin.vim source ~/.config/nvim/init.vim
augroup filetype_puml
	au!
	autocmd FileType plantuml nnoremap <leader>whh :PlantumlOpen<CR>
	autocmd FileType plantuml nnoremap <leader>wh :PlantumlSave<CR>
augroup end
augroup filetype_go
	au!
	let g:go_term_mode = "10split"

	"autocmd FileType go nnoremap <buffer> <F3> :GoRun<CR>
	"autocmd FileType go nnoremap <buffer> <localleader>d :GoDef<CR>
	"autocmd FileType go nnoremap <buffer> <localleader>b :GoDoc<CR>
	"autocmd FileType go nnoremap <buffer> <localleader>o <C-o>
	"autocmd FileType go nnoremap <buffer> <localleader>i <C-i>
	"autocmd FileType go nnoremap GA :GoAlternate<CR>

	autocmd FileType go set foldlevel=5
	autocmd FileType go nnoremap <buffer> <F12> :TagbarToggle<CR>
	" autocmd FileType go call neomake#configure#automake('nrwi', 500)
	autocmd FileType go vnoremap <silent> <C-P> :call ToggleComment("//")<cr>
	autocmd FileType go nnoremap <silent> <C-P> :call ToggleComment("//")<cr>
	autocmd BufWritePost *.go normal! zR
augroup end
augroup encrypted_dia
	au!
	autocmd FileReadPre,BufReadPre *.dia.gpg call DecryptFilePre()
	autocmd FileReadPost,BufReadPost *.dia.gpg call DecryptFilePost()
	autocmd FileWritePre,BufWritePre *.dia.gpg call EncryptFilePre()
	autocmd FileWritePost,BufWritePost *.dia.gpg call EncryptFilePost()
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
	autocmd BufEnter *.wiki let @o='F)2lv$hyi[[#jkA|jkpa]]jkGojk"_d^i== jkpa ==jko[[#Table of contents:|Back to TOC]]jkojko'
	autocmd BufEnter *.wiki let @s="istyle=\"width:600px;\""

	autocmd BufEnter *.wiki set wrap
augroup end
augroup filetype_java
	au!
	autocmd FileType java nnoremap <F12> :TagbarToggle<CR>
	autocmd FileType java set sidescrolloff=20
	autocmd FileType java set nowrap
augroup end
augroup filetype_python
	au!
	autocmd FileType python nnoremap <F12> :TagbarToggle<CR>
	autocmd FileType python map <leader>g :RopeGotoDefinition()<CR>
	autocmd FileType python let ropevim_enable_shortcuts = 1
	autocmd FileType python let g:pymode_rope_goto_def_newwin = "vnew"
	autocmd FileType python let g:pymode_rope_extended_complete = 1
	autocmd FileType python let g:pymode_breakpoint = 0
	autocmd FileType python let g:pymode_syntax = 1
	autocmd FileType python let g:pymode_syntax_builtin_objs = 0
	autocmd FileType python let g:pymode_syntax_builtin_funcs = 0
augroup end
augroup filetype_c
	au!
	autocmd BufEnter *.cpp,*.h,*.c set tags=./tags;~
	autocmd BufEnter *.cpp,*.h,*.c nnoremap <F12> :TagbarToggle<CR>
" }}} vim:foldmethod=marker:foldlevel=0
source ~/.config/nvim/python_host.vim " let g:python3_host_prog = '/path/to/python/virtual/env/bin/python'
