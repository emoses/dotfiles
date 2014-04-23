
" An example for a vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2002 Sep 19
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

call pathogen#infect()

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file
endif
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching
set ignorecase
set smartcase

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

let mapleader = '\'
" Don't use Ex mode, use Q for formatting
map Q gq

" This is an alternative that also works in block mode, but the deleted
" text is lost and it only works for putting the current register.
"vnoremap p "_dp

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
  let g:spectro_saturation = 115
  let g:spectro_lightness = 135
  colorscheme spectro
  hi LineNr guibg=Grey15
  hi Folded guifg=darkblue guibg=Grey65
  hi FoldColumn guifg=darkblue guibg=Grey65
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  augroup END

  autocmd! BufWritePost .vimrc source %

  function! UpdateModifiable()
          if !exists("b:setmodifiable")
                  let b:setmodifiable = 0
          endif
          if &readonly
                  if &modifiable
                          setlocal nomodifiable
                          let b:setmodifiable = 1
                  endif
          else
                  if b:setmodifiable
                          setlocal modifiable
                  endif
          endif
  endfunction
  autocmd BufReadPost * call UpdateModifiable()
  
  autocmd TabEnter * stopinsert


else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

nnoremap <silent> <leader>, :noh<CR>
nnoremap <F4> :NERDTree<CR>
nnoremap <F3> :TagbarToggle<CR>
"Navigate splits
nnoremap <C-Up> <C-w><Up>
nnoremap <C-Down> <C-w><Down>
nnoremap <C-Left> <C-w><Left>
nnoremap <C-Right> <C-w><Right>
nnoremap <leader>e :! P4PORT=p4proxy.soma.salesforce.com:1999 P4CLIENT=emoses-wsl p4 edit %<CR>

"Completion options
set completeopt=longest,menuone,preview
inoremap <expr> <CR> pumvisible() ? '<C-y>' : "<C-g>u\<CR>"
inoremap <expr> <C-n> pumvisible() ? '<C-n>' : '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'

"Aura file mappings
function! Aura_Change_File(newExt)
    let fpath = expand("%:h")
    let dirBase = strpart(fpath, strridx(fpath, '/'))
    exe "e " . fpath . "/" . dirBase . a:newExt
endfun

nnoremap <leader>ac :call Aura_Change_File(".cmp")<CR>
nnoremap <leader>aa :call Aura_Change_File(".app")<CR>
nnoremap <leader>aj :call Aura_Change_File("Controller.js")<CR>
nnoremap <leader>as :call Aura_Change_File(".css")<CR>
nnoremap <leader>ah :call Aura_Change_File("Helper.js")<CR>
nnoremap <leader>ar :call Aura_Change_File("Renderer.js")<CR>

au Filetype html,xml,xsl source ~/.vim/plugin/closetag.vim
au BufNewFile,BufRead *.apexp,*.apexc,*.app,*.cmp,*.evt,*.intf set filetype=xml

"General text options
set tabstop=4
set shiftwidth=4
set expandtab
set number
set showtabline=2
set guioptions=aegimrLt

"Eclim options
let g:EclimJavaSearchSingleResult='tabnew'
let g:EclimDefaultFileOpenAction='tabnew'
let g:EclimLocateFileDefaultAction='tabnew'
let g:EclimLocateFileScope='workspace'

"Eclim bindings
nnoremap <C-x><C-f> :LocateFile 
nnoremap <leader><CR> :JavaSearchContext<CR>

command! Ccollab :!ccollab addgitdiffs new HEAD^ HEAD
command! CcollabAsk :!ccollab addgitdiffs ask HEAD^ HEAD

"Switch lcd or cd to the directory of the current file
command! Clcd :lcd %:p:h
command! Ccd :cd %:p:h

"Execute a command an open in a new window
:command! -nargs=* -complete=shellcmd R new | setlocal buftype=nofile bufhidden=hide noswapfile | r !<args>
