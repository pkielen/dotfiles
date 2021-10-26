" An example for a vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2019 Dec 17
"
" To use it, copy it to
"	       for Unix:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"	 for MS-Windows:  $VIM\_vimrc
"	      for Haiku:  ~/config/settings/vim/vimrc
"	    for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings, bail
" out.

set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'neoclide/coc.nvim' , {'for':['bazel', 'zig','cmake','rust', 'java','json', 'haskell', 'ts','sh', 'cs', 'yaml', 'c', 'cpp', 'd', 'go', 'python', 'dart', 'javascript', 'vim'], 'branch': 'release'}
Plugin 'junegunn/fzf', { 'do': '-> fzf#install()'}
Plugin 'junegunn/fzf.vim'
Plugin 'preservim/nerdcommenter'
Plugin 'tpope/vim-fugitive'
Plugin 'jesseleite/vim-agriculture'
Plugin 'airblade/vim-gitgutter'
Plugin 'xolox/vim-misc'
Plugin 'xolox/vim-session'
Plugin 'xolox/vim-notes'
Plugin 'itchyny/lightline.vim'
Plugin 'francoiscabrl/ranger.vim'
Plugin 'JamshedVesuna/vim-markdown-preview'
Plugin 'honza/vim-snippets'



" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
" Plugin 'tpope/vim-fugitive'
" plugin from http://vim-scripts.org/vim/scripts.html
" Plugin 'L9'
" Git plugin not hosted on GitHub
" Plugin 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
" Plugin 'file:///home/gmarik/path/to/plugin'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
" Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Install L9 and avoid a Naming conflict if you've already installed a
" different version somewhere else.
" Plugin 'ascenator/L9', {'name': 'newL9'}

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
" ==========================================================================================

if v:progname =~? "evim"
  finish
endif

" Get the defaults that most users want.
source $VIMRUNTIME/defaults.vim

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file (restore to previous version)
  if has('persistent_undo')
    set undofile	" keep an undo file (undo changes after closing)
  endif
endif

if &t_Co > 2 || has("gui_running")
  " Switch on highlighting the last used search pattern.
  set hlsearch
endif

" Put these in an autocmd group, so that we can delete them easily.
augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78
augroup END

" Add optional packages.
"
" The matchit plugin makes the % command work better, but it is not backwards
" compatible.
" The ! means the package won't be loaded right away but when plugins are
" loaded during initialization.
if has('syntax') && has('eval')
  packadd! matchit
endif

" ===========================================================================
" My settings

" Clear some mappings
let g:gitgutter_map_keys = 0

" Map Escape
imap jk <Esc>

" Set leader key
let mapleader=' '

" Disable swapfiles
set noswapfile

" Add closing bracket automatically
nmap <Leader>8 o{<CR><CR><Up><Tab>

set path=$PWD/**
set exrc
set secure
" show existing tab with 4 spaces width
set tabstop=4
" when indenting with '>', use 4 spaces width
set shiftwidth=4
" On pressing tab, insert 4 spaces
set expandtab

set list
set listchars=tab:>-
set wildmenu
set wildmode=longest:full,full

" Quickly insert an empty new line without entering insert mode
nnoremap <Leader>o o<Esc>
nnoremap <Leader>O O<Esc>

nnoremap <F2> :let @/=""<CR>
set nu
set number                     " Show current line number
set relativenumber             " Show relative line numbers

autocmd bufenter *.cpp map<leader>T :exec("tag ".expand('%:t:r').".h")<cr>
autocmd bufenter *.h map<leader>T :exec("tag ".expand('%:t:r').".cpp")<cr>

nnoremap <C-i> i_<Esc>r

" FZF settings
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.9 } }
map <Leader>f :Files<CR>
map <Leader>t :Tags<CR>
map <Leader>b :Buffers<CR>

" Remove trailing whitespace on write
autocmd BufWritePre * %s/\s\+$//e

" Fugitive Conflict Resolution
nnoremap <leader>gd :Gvdiffsplit!<CR>
nnoremap gh :diffget //2<CR>
nnoremap gl :diffget //3<CR>

" C++ syntax highlightning settings
let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1
let g:cpp_class_decl_highlight = 1
let g:cpp_experimental_template_highlight = 1

" gitgutter settings (git diff)
set updatetime=100
let g:gitgutter_highlight_lines = 1
highlight! link SignColumn LineNr
highlight link GitGutterDeleteLine DiffText
highlight GitGutterAddLine     ctermbg=236
highlight GitGutterChangeLine  ctermbg=236
highlight GitGutterDeleteLine  ctermbg=52

" ranger shortcut
let g:ranger_map_keys = 0
map <leader>d :Ranger<CR>

" Map window navigation
nmap <Leader>h :wincmd h<CR>
nmap <Leader>j :wincmd j<CR>
nmap <Leader>k :wincmd k<CR>
nmap <Leader>l :wincmd l<CR>

" Map gitgutter
nmap ghp <Plug>(GitGutterPreviewHunk)
nmap gn <Plug>(GitGutterNextHunk)
nmap gp <Plug>(GitGutterPrevHunk)


" GDB
let g:termdebug_popup = 0
let g:termdebug_wide = 163

" Lightline
set laststatus=2
let g:lightline = {
      \ 'component_function': {
      \   'filename': 'LightlineFilename',
      \ }
      \ }

function! LightlineFilename()
  let root = fnamemodify(get(b:, 'git_dir'), ':h')
  let path = expand('%:p')
  if path[:len(root)-1] ==# root
    return path[len(root)+1:]
  endif
  return expand('%')
endfunction

let &t_TI = ""
let &t_TE = ""

" Allow project specific configurations
set exrc

" Markdown preview using grip
let vim_markdown_preview_github=1

" vim-session settings
let g:session_autoload = 'no'
let g:session_autosave = 'yes'
let g:session_autosave_periodic = 5
nmap <leader>s :OpenSession<CR>





""""""""""""""""""""""""" CoC configurations """"""""""""""""""""""""""""""""
" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

set signcolumn=yes " Always show signcolumn

