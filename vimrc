""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Sections:                                                                  "
"   01. General ................. General Vim behavior, includes Vundle      "
"   02. Events .................. General autocmd events                     "
"   03. Theme/Colors ............ Colors, fonts, etc.                        "
"   04. Vim UI .................. User interface behavior                    "
"   05. Text Formatting/Layout .. Text, tab, indentation related             "
"   06. Custom Commands ......... Any custom command aliases                 "
"   07. Plugin Settings ......... Any custom command aliases                 "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 01. General                                                                "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set encoding=utf-8
set nocompatible         " get rid of Vi compatibility mode. SET FIRST!
filetype off             " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
" call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'
" git
Plugin 'tpope/vim-fugitive'
" tagbar is the new taglist
Plugin 'majutsushi/tagbar'
" cscope
Plugin 'vim-scripts/cscope.vim'
" silver search
Plugin 'rking/ag.vim'
" parantheses coloring
Plugin 'luochen1990/rainbow'
" automatic closing parens
Plugin 'Raimondi/delimitMate'
" automatic comments
Plugin 'tomtom/tcomment_vim'
" save folding & cursor position ! KINDA laggy
Plugin 'vim-scripts/restore_view.vim'

" airline
Plugin 'bling/vim-airline'

" ctrl P fuzzy search
Plugin 'kien/ctrlp.vim'
Plugin 'scrooloose/nerdtree'

" linux kernel
Plugin 'linuxsty.vim'

" syntax files
Plugin 'leshill/vim-json'
Plugin 'jtratner/vim-flavored-markdown'
" trailing white-spaces
Plugin 'ntpeters/vim-better-whitespace'

" Python
Plugin 'fs111/pydoc.vim'

" more than omni completion, jedi completion (in python)
Plugin 'Valloric/YouCompleteMe'
" YCM superseds this
" Plugin 'nvie/vim-flake8'
" Plugin 'davidhalter/jedi-vim'
" Plugin 'ervandew/supertab'

Plugin 'mephux/bro.vim'

" All of your Plugins must be added before the following line
call vundle#end()            " required
" To ignore plugin indent changes, instead use:
" filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just
" :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to
" auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

" Wildmenu
set wildmenu
set wildmode=list:longest
set wildignore+=.hg,.git,.svn                    " Version control
set wildignore+=*.aux,*.out,*.toc                " LaTeX intermediate files
set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest " compiled object files
set wildignore+=*.spl                            " compiled spelling word lists 
set wildignore+=*.sw?                            " Vim swap files
set wildignore+=*.DS_Store                       " OSX bullshit
set wildignore+=*.luac                           " Lua byte code
set wildignore+=*.pyc                            " Python byte code
set wildignore+=**.class                         " Cursed Java class files

set backspace=indent,eol,start " Make backspace behave normally.
set directory=/tmp// " swap files
set backupskip=/tmp/*,/private/tmp/*

set list listchars=tab:»\ ,trail:·

" Save when losing focus
set autowriteall " Auto-save files when switching buffers or leaving vim.
au FocusLost * silent! :wa
au TabLeave * silent! :wa

" Resize splits when the window is resized
au VimResized * exe "normal! \<c-w>=""

" Toggle spellcheck in normal mode
:map <F5> :setlocal spell! spelllang=en_us<CR>

" default yank/paste in unnamed register(clipboard)
set clipboard=unnamedplus

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 02. Events                                                                 "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
filetype plugin indent on " filetype detection[ON] plugin[ON] indent[ON]

" In Makefiles DO NOT use spaces instead of tabs
autocmd FileType make setlocal noexpandtab
" In Ruby files, use 2 spaces instead of 4 for tabs
autocmd FileType ruby setlocal sw=2 ts=2 sts=2

" Get rid of trailing whitespace highlighting in mutt.
autocmd FileType mail highlight clear ExtraWhitespace
autocmd FileType mail setlocal listchars=

" Enable omnicompletion (to use, hold Ctrl+X then Ctrl+O while in Insert mode.
set omnifunc=syntaxcomplete#Complete

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 03. Theme/Colors                                                           "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set t_Co=256              " enable 256-color mode.
syntax enable             " enable syntax highlighting (previously syntax on).
colorscheme molokai       " set colorscheme

" Prettify JSON files
autocmd BufRead,BufNewFile *.json set filetype=json
autocmd Syntax json sou ~/.vim/syntax/json.vim

" Prettify Vagrantfile
autocmd BufRead,BufNewFile Vagrantfile set filetype=ruby

" Prettify Markdown files
augroup markdown
  au!
  au BufNewFile,BufRead *.md,*.markdown setlocal filetype=ghmarkdown
augroup END

" Highlight characters that go over 80 columns (by drawing a border on the 81st)
if exists('+colorcolumn')
  set colorcolumn=81
  highlight ColorColumn ctermbg=red
else
  highlight OverLength ctermbg=red ctermfg=white guibg=#592929
  match OverLength /\%81v.\+/
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 04. Vim UI                                                                 "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set number                " show line numbers
set numberwidth=6         " make the number gutter 6 characters wide
set cul                   " highlight current line
set laststatus=2          " last window always has a statusline
set hlsearch            " Don't continue to highlight searched phrases.
set incsearch             " But do highlight as you type your search.
set ignorecase            " Make searches case-insensitive.
set ruler                 " Always show info along bottom.
set showmatch             " set show matching paranthesis
set statusline=%<%f\%h%m%r%=%-20.(line=%l\ \ col=%c%V\ \ totlin=%L%)\ \ \%h%m%r%=%-40(bytval=0x%B,%n%Y%)\%P
set title                " change the terminal's title
set visualbell           " don't beep
set noerrorbells         " don't beep

" Remove the toolbar if we're running under a GUI (e.g. MacVIM).
if has("gui_running")
  set guioptions=-t
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 05. Text Formatting/Layout                                                 "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set autoindent            " auto-indent
set tabstop=4             " tab spacing
set softtabstop=4         " unify
set shiftwidth=4          " indent/outdent by 2 columns
set shiftround            " always indent/outdent to the nearest tabstop
set expandtab             " use spaces instead of tabs
set smartindent           " automatically insert one extra level of indentation
set smarttab              " use tabs at the start of a line, spaces elsewhere

set wrap                  " wrap text
set linebreak
set nolist
set textwidth=0
set wrapmargin=0

" General Code Folding
set foldmethod=indent
set foldlevel=99
nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<Space>")<CR>
vnoremap <Space> zf

" Highlight VCS conflict markers
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 06. Custom Commands                                                        "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let $VIMHOME = $HOME."/.vim"

" Prettify JSON files making them easier to read
command PrettyJSON %!python -m json.tool

" Python configurations
autocmd FileType python setlocal shiftwidth=4 expandtab tabstop=4 softtabstop=4
autocmd FileType python map <buffer> <F4> :call Flake8()<CR>
autocmd FileType python autocmd BufWritePre * :%s/\s\+$//e

" Fix those pesky situations where you edit & need sudo to save
cmap w!! w !sudo tee % >/dev/null

nmap <silent> ,/ :nohlsearch<CR>

" s: Find this C symbol
nnoremap  <leader>fs :call cscope#find('s', expand('<cword>'))<CR>
" g: Find this definition
nnoremap  <leader>fg :call cscope#find('g', expand('<cword>'))<CR>
" d: Find functions called by this function
nnoremap  <leader>fd :call cscope#find('d', expand('<cword>'))<CR>
" c: Find functions calling this function
nnoremap  <leader>fc :call cscope#find('c', expand('<cword>'))<CR>
" t: Find this text string
nnoremap  <leader>ft :call cscope#find('t', expand('<cword>'))<CR>
" e: Find this egrep pattern
nnoremap  <leader>fe :call cscope#find('e', expand('<cword>'))<CR>
" f: Find this file
nnoremap  <leader>ff :call cscope#find('f', expand('<cword>'))<CR>
" i: Find files #including this file
nnoremap  <leader>fi :call cscope#find('i', expand('<cword>'))<CR>

nnoremap <leader>fa :call cscope#findInteractive(expand('<cword>'))<CR>
nnoremap <leader>l :call ToggleLocationList()<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 07. Plugin Settings                                                        "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:rainbow_active = 1 " 0 if you want to enable it later via :RainbowToggle

let g:tagbar_autoshowtag = 1
let g:tagbar_autofocus = 1
let g:tagbar_compact = 1
let g:tagbar_autoshowtag = 1
nnoremap <silent> <F8> :TagbarToggle<CR>

let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'  " search anything (in files, buffers and MRU files at the same time.)
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files . -co --exclude-standard']
let g:ctrlp_custom_ignore = '\v\~$|\.(o|swp|pyc|wav|mp3|ogg|blend)$|(^|[/\\])\.(hg|git|bzr)($|[/\\])|__init__\.py'
let g:ctrlp_root_markers = ['.git']
let g:ctrlp_working_path_mode = 'ra' " search for nearest ancestor like .git,.hg, and the directory of the current file
let g:ctrlp_match_window_bottom = 0 " show the match window at the top of the screen
let g:ctrlp_max_height = 10 " maxiumum height of match window
let g:ctrlp_switch_buffer = 'et' " jump to a file if it's open already
let g:ctrlp_use_caching = 1 " enable caching
let g:ctrlp_clear_cache_on_exit=0 " speed up by not removing clearing cache everytime
let g:ctrlp_show_hidden = 0 " don't show me dotfiles
let g:ctrlp_mruf_max = 250 " number of recently opened files
nmap ; :CtrlPBuffer<CR>
nmap , :CtrlPTag<CR>

" Airline configs
let g:airline#extensions#tabline#enabled = 0
" Show just the filename
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline_powerline_fonts = 1

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

" NerdTree
map <leader>t :NERDTreeToggle<CR>
let NERDTreeIgnore=['\.pyc$', '\~$']
let g:nerdtree_tabs_open_on_gui_startup = 0
let g:nerdtree_tabs_open_on_console_startup = 0

let g:ycm_register_as_syntastic_checker = 1
let g:ycm_open_loclist_on_ycm_diags = 1
let g:ycm_server_use_vim_stdout = 1
let g:ycm_server_log_level = 'info'
let g:ycm_add_preview_to_completeopt = 1
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_show_diagnostics_ui = 1
let g:ycm_collect_identifiers_from_tags_files = 1
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_goto_buffer_command = 'same-buffer'
let g:ycm_key_invoke_completion = '<C-Space>'
let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf_default.py'
let g:ycm_key_detailed_diagnostics = '<leader>d'
nnoremap <leader>g :YcmCompleter GoTo<CR>
nnoremap <leader>p :YcmCompleter GoParent<CR>
nnoremap <leader>i :YcmCompleter GoToIplementation<CR>
nnoremap <F5> :YcmForceCompileAndDiagnostics <CR>
