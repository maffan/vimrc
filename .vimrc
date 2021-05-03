" Plugin stuff {{{
" vim-plug {{{
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()
Plug 'dense-analysis/ale'
Plug 'tpope/vim-commentary'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'ryanoasis/vim-devicons'
Plug 'junegunn/vim-easy-align'
Plug 'tpope/vim-flagship'
Plug 'morhetz/gruvbox'
Plug 'embear/vim-localvimrc'
Plug 'preservim/nerdtree'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'vim-pandoc/vim-pandoc-syntax'
Plug 'mtth/scratch.vim'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
Plug 'yegappan/taglist'
call plug#end()
" vim-plug }}}

" Taglist
nnoremap <leader>tl :TlistToggle<CR>
let g:Glist_Show_One_File=1

" commentary
augroup c_comment
    autocmd!
    autocmd FileType c setlocal commentstring=//%s
augroup END

" flagship
set laststatus=2
set showtabline=2
set guioptions-=e

" localvimrc
let g:localvimrc_sandbox = 0
let g:localvimrc_ask = 0

" CtrlP
let g:ctrlp_clear_cache_on_exit = 1
let g:ctrlp_working_path_mode = "ra"

" NERDtree
noremap <F2> :NERDTreeToggle<CR>
nnoremap <Leader>nt :NERDTreeToggle<CR>
nnoremap <Leader>nf :NERDTreeFocus<CR>
nnoremap <Leader>nb :NERDTreeFind<CR>
" Exit Vim if NERDTree is the only window left.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() |
    \ quit | endif
" If another buffer tries to replace NERDTree, put it in the other window, and bring back NERDTree.
autocmd BufEnter * if bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 |
    \ let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif

" Colorscheme
let g:gruvbox_italic=1
set termguicolors
set background=dark
colorscheme gruvbox

" pandoc
let g:pandoc#modules#disabled = ["folding"]

" cscope
set cscopetag
if filereadable("cscope.out")
  set nocscopeverbose
  set csto=0
  cs add cscope.out
  set cscopeverbose
endif

" Terminal
tnoremap <C-[> <C-\><C-n>
tnoremap <Leader>sm <C-\><C-n>mSa
tnoremap <Leader>gm <C-\><C-n>`S

" Easy align
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" Plugin stuff }}}

" Standard stuff
set belloff=all
set mouse=a
set tabstop=4
set shiftwidth=4
set encoding=UTF-8
set ignorecase
set smartcase
set wildmode=longest,list,full

set list
set number

" Functions
function! TemplateReplace()
    " Replace '-' and '_' with spaces
    let l:title = tr(tr(expand('%:r'), '-', ' '), '_', ' ')
    " Make title case
    let l:title = substitute(l:title, '\<\(\w\)\(\w*\)\>', '\u\1\L\2', 'g')
    let l:date = strftime('%B, %e %Y')
    exec "%s/{{date}}/" . l:date . "/ge"
    exec "%s/{{title}}/" . l:title . "/ge"
    normal! G
endfun

function! MD2PDF()
  let l:mdfile = expand("%")
  let l:pdffile = expand("%:r") . ".pdf"
  execute '!pandoc ' . l:mdfile . ' -o ' . l:pdffile . ' && zathura ' . l:pdffile
endfunction

" Abbrevs
iabbrev @@ marcus.flyckt@gmail.com
iabbrev ssig --<cr>Marcus Flyckt<cr>marcus.flyckt@gmail.com

" Mappings
nnoremap - ddp
nnoremap _ kddpk
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>
nnoremap <leader>elv :LocalVimRCEdit<cr>
nnoremap <leader>slv :LocalVimRC<cr>
nnoremap <up> <nop>
nnoremap <right> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <leader>sq :mksession!<cr>:wqa<cr>
nnoremap <leader>frn vi{:s/<c-r>f/<c-r>t/gc<cr>
nnoremap Y yiw
nnoremap <leader>rw viw"tp
nnoremap <leader>c ^C
nnoremap <leader>id "=strftime('%B, %e %Y')<cr>p

inoremap <leader><c-d> <esc>ddi
inoremap <leader><c-u> <esc>viwUA
inoremap jk <esc>
inoremap <leader>c <esc>^C

vnoremap <leader>rn :s/<c-r>f/<c-r>t/gc<cr>


" Commands
" Plugsort: Sorts vim-plug rows
command! -range Plugsort <line1>,<line2>sort /.*\/\(vim-\)\=/

" Autocommands
augroup templates
    autocmd!
  autocmd BufNewFile *.md 0r ~/.vim/templates/skeleton.md | call TemplateReplace()
augroup END

augroup filetype_vim
  autocmd!
  autocmd FileType vim setlocal foldmethod=marker
augroup END

augroup nowrap_group
  autocmd!
  autocmd FileType html,xml setlocal nowrap
augroup END

augroup filetype_c
  autocmd!
  autocmd FileType c :iabbrev <buffer> mmain int main(int argc, char *argv[])<cr>{<cr>}<up>
augroup END

" ctags
set tags=./tags,tags


