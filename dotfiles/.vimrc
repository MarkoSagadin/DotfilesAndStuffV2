set nocompatible    " Work as VIM not like VI, should be on top

" Will automaticaly install vim-plug and all plugins if empty
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif


""""""""""""""""""""""""""
"List of plugins
""""""""""""""""""""""""""
call plug#begin('~/.vim/plugged')
Plug 'lervag/vimtex'
Plug 'scrooloose/nerdtree'
Plug 'SirVer/ultisnips'
Plug 'christoomey/vim-tmux-navigator'
Plug 'airblade/vim-gitgutter'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
Plug 'rhysd/vim-grammarous'
Plug 'majutsushi/tagbar'
Plug 'wincent/terminus'
Plug 'itchyny/lightline.vim'
Plug 'preservim/nerdcommenter'
Plug 'mileszs/ack.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'svermeulen/vim-subversive'
Plug 'tpope/vim-fugitive'
Plug 'kkoomen/vim-doge', { 'do': { -> doge#install() } }
Plug 'tell-k/vim-autopep8'

" Color schemes and syntax highlight
Plug 'connorholyday/vim-snazzy'
Plug 'sudar/vim-arduino-syntax'
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'zeis/vim-kolor'
Plug 'morhetz/gruvbox'
Plug 'altercation/vim-colors-solarized'
Plug 'srcery-colors/srcery-vim'
Plug 'goldie-lin/vim-dts'
" should be last
Plug 'ryanoasis/vim-devicons'
call plug#end()

let g:lsp_cxx_hl_use_text_props = 1
let g:ackprg = 'ag --nogroup --nocolor --column'

""""""""""""""""""""""""""
" Colorscheme settings
""""""""""""""""""""""""""
let used_colorscheme = "dracula"     " It can be snazzy, dracula, solarized or gruvbox


if used_colorscheme ==# "snazzy"
let g:lightline = {
\ 'colorscheme': 'snazzy',
\ 'active': {
\   'left': [ [ 'mode', 'paste' ],
\             [ 'readonly', 'filename', 'modified' ] ]
\ },
\ }

" Use autocmd to force lightline update.
colorscheme snazzy
set background=dark
elseif used_colorscheme ==# "dracula"
let g:lightline = {
\ 'colorscheme': 'dracula',
\ 'active': {
\   'left': [ [ 'mode', 'paste' ],
\             [ 'readonly', 'filename', 'modified' ] ]
\ },
\ }

" Use autocmd to force lightline update.
colorscheme dracula
"set background=dark
elseif used_colorscheme ==# "gruvbox"
let g:lightline = {'colorscheme': 'gruvbox'}
let g:gruvbox_bold=1
let g:gruvbox_italic=1
let g:gruvbox_termcolors=16
set background=light
colorscheme gruvbox
elseif used_colorscheme ==# "solarized"
let g:lightline = {'colorscheme': 'solarized'}
colorscheme solarized
set background=light
let g:solarized_termcolors=16
else
echom "Unsupported colorscheme, please check option used_colorscheme in ~/.vimrc"
finish
endif

""""""""""""""""""""""""""
" General settings
""""""""""""""""""""""""""
syntax enable                   " enable automatic syntax
set clipboard^=unnamed,unnamedplus " connect system clipboard with Vim clipboard
set tabstop=4                   " number of visual spaces per TAB
set softtabstop=4               " number of spaces in tab when editing
set shiftwidth=4                " number of spaces when indenting with >
set expandtab                   " tabs are spaces
set number                      " show line numbers
set showcmd                     " show command in bottom bar
set cursorline                  " highlight current line
set colorcolumn=80              " highlight specified column for line wraping
filetype indent on              " load filetype-specific indent files
set wildmenu                    " visual autocomplete for command menu
set lazyredraw                  " redraw only when we need to.
set showmatch                   " highlight matching [{()}]
set foldenable                  " enable folding
set foldlevelstart=10           " open most folds by default
set foldnestmax=10              " 10 nested fold max
set guioptions-=m               " remove menu bar in gui version
set guioptions-=T               " remove toolbar in gui version
set guioptions-=L               " remove left-hand scroll bar in gui version
set belloff=all                 " Disable beeping
set fileformat=unix             " LF endings, so that Github doesn't bother me
set splitright                  " Opens new split windows to the right
set backspace=indent,eol,start  " Backspace will work normaly in insert mode
set linebreak                   " Editor window does not break words in the middle anymore.
set encoding=utf-8              " For special slovenian characters"
set fileencoding=utf-8          " For special slovenian characters"
set scrolloff=5                 " This is amazing, cursor won't go to
                                " the end of the screen when scrolling
set updatetime=100              " Needed for gitgutter and coc plugin
set laststatus=2                " Always show statusline
set incsearch                   " Find the next match as we type the search
set ignorecase                  " Ignore case when searching...
set smartcase                   " ...unless we type a capital
set signcolumn=number           " Merge sign cloumn into numbers column
set hidden                      " TextEdit might fail if hidden is not set.
set noswapfile                  " Copy large files without problems from
                                " System clipboard
set shortmess+=c                " Don't pass messages to |ins-completion-menu|.


""""""""""""""""""""""""""
" General Key mappings
""""""""""""""""""""""""""
" Map leader key to space, map it to NOP before doing anything
nnoremap <SPACE> <Nop>
let mapleader = " "

" jk is now a escape from insert mode
inoremap jk <esc>

" Jumping in and out of tags
nnoremap <leader>i g<C-]>
nnoremap <leader>o <C-t>

" Going back and forward between buffers, delete buffer
nnoremap  <leader>j :bn<CR>
nnoremap  <leader>k :bp<CR>
nnoremap  <leader>q :bd<CR>

" B will jump to the end of line
" E will jump to the start
" $ and ^ won't do anything
nnoremap B ^
nnoremap E $
nnoremap $ <nop>
nnoremap ^ <nop>

" gb for moving between buffers
nnoremap gb :ls<CR>:b<Space>

" No cursor movement, resize instead
nnoremap <Left>  :vertical resize +1<CR>
nnoremap <Right> :vertical resize -1<CR>

" Edit vimr configuration file directly from the vim
nnoremap confe :e $MYVIMRC<CR>
" Reload vims configuration file directly from the vim
nnoremap confr :source $MYVIMRC<CR>

""""""""""""""""""""""""""
" Spell check settings
""""""""""""""""""""""""""
hi clear SpellBad
hi SpellBad cterm=underline
hi SpellBad ctermfg=1


""""""""""""""""""""""""""
" Tmux *send commands* commands
""""""""""""""""""""""""""
" Very magical command, I can now send commands to other tmux panel
" autocmd FileType python nnoremap <silent> <C-Y> :wa \| exe "!tmux send -t 1 'python3 uart_fetch.py' Enter"<CR>
nnoremap <silent> <C-d> :wa \| exe "!tmux send -t 1 'arduino-cli compile --fqbn IRNAS:stm32l0:IRNAS-env-module-L072Z pmp --build-path /home/skobec/work/irnas-lorawan-base/build && arduino-cli upload --fqbn IRNAS:stm32l0:IRNAS-env-module-L072Z -p /dev/ttyACM0 --input-dir build' Enter"<CR>


"nnoremap <silent> <C-m> :wa \| exe "!tmux send -t 2 'minicom' Enter"<CR>
"nnoremap <silent> <C-f> :wa \| exe "!tmux send -t 1 'west build -b nrf52dk_nrf52832 && west flash --runner jlink' Enter"<CR>
"nnoremap <silent> <C-f> :wa \| exe "!tmux send -t 1 'west build -b nrf52840dk_nrf52840 && west flash --runner jlink' Enter"<CR>
"nnoremap <silent> <C-f> :wa \| exe "!tmux send -t 1 'west build -b nrf9160dk_nrf9160ns && west flash' Enter"<CR>
"nnoremap <silent> <C-f> :wa \| exe "!tmux send -t 1 'west build -b nrf9160_pca10090ns && west flash' Enter"<CR>
"nnoremap <silent> <C-f> :wa \| exe "!tmux send -t 1 'west build -b nucleo_wb55rg && west flash' Enter"<CR>
nnoremap <silent> <C-y> :wa \| exe "!tmux send -t 1 'inv test -s test_action' Enter"<CR>


""""""""""""""""""""""""""
" Specific plugin settings
""""""""""""""""""""""""""
" Vimtex
let g:vimtex_view_method = 'zathura'
let g:tex_flavor = 'latex'

" Git Gutter
let g:gitgutter_max_signs = 2000

" Tags files locations
:set tags=./tags,tags,../../tags    "Used to tell where tags are located
:set tags+=$ZEPHYR_BASE/tags        "Points to tags in Zephyr folder
:set tags+=~/work/nrf5_sdk/tags
:set tags+=~/Work/nrf5_sdk/tags
:set tags+=~/work/memfault-firmware-sdk/tags

" Nerdtree
" open nerdtree with ctrl+c
map <silent> <C-c> :NERDTreeToggle<CR>

" Tagbar
" open Tagbar with ctrl+x
map <silent> <C-x> :TagbarToggle<CR>

" UltiSnips
"let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"
let g:UltiSnipsEditSplit="vertical"

" NerdCommenter
let g:NERDCreateDefaultMappings = 0

" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1

" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'
let g:NERDCustomDelimiters = { 'c': { 'left': '//','right': '' } }

" Toggle comments with ctrl+l
nmap <C-l> <plug>NERDCommenterToggle
xmap <C-l> <plug>NERDCommenterToggle

" FZF mappings
let g:fzf_preview_window = []
nmap <silent> <C-p> :GFiles<CR>
nmap <silent> <C-m> :Files<CR>
nmap <silent> <C-b> :Buffers<CR>

" Rename word under cursor in all open buffers
nnoremap <Leader>s :bufdo %s/\<<C-r><C-w>\>//g<Left><Left>
set wildignore=*.o,*.a,*.d,*.so,*.pyc,*.swp,.git/*,*.class

" Clang format
" Detect .clang-format file in parent directory and format on every save
let g:clang_format#detect_style_file = 1
let g:clang_format#auto_format = 1
autocmd FileType python noremap <buffer> <F8> :call Autopep8()<CR>

" Fugitive Conflict Resolution
nnoremap <leader>gd :Gvdiffsplit!<CR>
nnoremap gdh :diffget //2<CR>
nnoremap gdl :diffget //3<CR>

" Needed for syntax highligthing in devicetree files
autocmd BufRead,BufNewFile *.dts,*.dtsi,*.overlay set filetype=dts

" Needed for syntax highligthing in markdown files
au BufNewFile,BufFilePre,BufRead *.md set filetype=markdown

" Use different identation in yaml files
autocmd FileType yaml setlocal shiftwidth=2 softtabstop=2 expandtab

" Subversive mappings
nmap s <plug>(SubversiveSubstitute)
nmap ss <plug>(SubversiveSubstituteLine)
nmap S <plug>(SubversiveSubstituteToEndOfLine)

" Function for trimming whitespace, call it with :TrimWhiteSpace
fun! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun

command! TrimWhitespace call TrimWhitespace()

function! FormatAndTrimeOnSave()
    :call TrimWhitespace()
endfunction
autocmd BufWritePre *.h,*.c,*.cc,*.cpp,*.py call FormatAndTrimeOnSave()
