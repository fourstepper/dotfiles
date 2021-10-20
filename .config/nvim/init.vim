" -------------
call plug#begin('~/.vim/plugged')

    "Bracket surround
        Plug 'tpope/vim-surround'
    "repeat with . for vim-surround
        Plug 'tpope/vim-repeat'
    "coc.vim
        Plug 'neoclide/coc.nvim', {'branch': 'release'}
    "Vim Airline
        Plug 'vim-airline/vim-airline'
    " Fuzzy find 1
        Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    " Fuzzy find 2
        Plug 'junegunn/fzf.vim'
    " Gruvbox theme
        Plug 'morhetz/gruvbox'
    " Git stuff
        Plug 'tpope/vim-fugitive'
    " More git stuff
        Plug 'airblade/vim-gitgutter'
    " UNIX stuff in vim
        Plug 'tpope/vim-eunuch'
    " Commentary plugin
        Plug 'tpope/vim-commentary'
    " IndentLine
        Plug 'Yggdroot/indentLine'
    " Auto-pairs
        Plug 'jiangmiao/auto-pairs'
    " Ansible vault inline
        Plug 'arouene/vim-ansible-vault'
    " Rainbow brackets
        Plug 'luochen1990/rainbow'
    " Vim + Tmux = <3
        Plug 'christoomey/vim-tmux-navigator'
    " Golang
        Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
    " Terraform
        Plug 'hashivim/vim-terraform'
        Plug 'juliosueiras/vim-terraform-completion'

    call plug#end()
" -------------

" Set proper color in Vim
set termguicolors

" Set no highlight after search ends
set nohlsearch

" Check for eight line lines
set colorcolumn=120

" Use powerline fonts for the git icons to show up
let g:airline_powerline_fonts = 1

" Netrw settings
let g:netrw_localcopydircmd = 'cp -r'
let g:netrw_winsize = 30
let g:netrw_banner = 0

" Don't match filenames when searching through fulltext
command! -bang -nargs=* Rg call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1, {'options': '--delimiter : --nth 4..'}, <bang>0)

" turn hybrid line numbers on
set number relativenumber
set nu rnu

" Custom command for new file in the same directory
command! -nargs=+ NewFile :e %:h/<args>

" Remove trailing whitespaces on save
autocmd BufWritePre * :%s/\s\+$//e

"Syntax highlighting
syntax on

" Disable compatibility with Vi
    set nocompatible
" Auto indentation (don't really know what this does, to be honest)
    set autoindent
" Incremental search
    set incsearch
" Case handling while searching (only search case-sensitive
" if case-sensitivity is used)
    set ignorecase
    set smartcase

" (Not only) Python tab stuff (shorter tab, some changes
" regarding the behaviour of indentation per filetype)
set tabstop=8
set expandtab
set shiftwidth=4
set softtabstop=4
filetype indent on
set modeline
set secure

" File indentation rules
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType typescript setlocal ts=8 sw=8 noexpandtab

" Make brackets rainbowy
let g:rainbow_active = 1

" Provides tab completion for all file related tasks
set path+=**

" Display all matching files during the auto completion process
set wildmenu

" Show line numbers
set number

" Leader key show command
set showcmd

" Undo history!
set undofile                " Save undo's after file closes
set undodir=$HOME/.vim/undodir " where to save undo histories
set undolevels=1000         " How many undos
set undoreload=10000        " number of lines to save for undo

" COLORS RIGHT NOW, WITH DEFAULT SCHEME
set background=dark    " Setting dark mode
" hi Pmenu ctermbg=DarkBlue guibg=DarkBlue
" hi PmenuSel ctermbg=DarkGreen guibg=DarkGreen
" hi Visual guibg=#666666

" ALTERNATIVE
colorscheme gruvbox

" set Vim-specific sequences for RGB colors
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

" Set ansible-vault password (just a reference)
    " let $ANSIBLE_VAULT_PASSWORD_FILE="~/.ansible/vault_pass.txt"

" ALL OF MY KEYBINDINGS GO HERE:
" ----------------------
" Leader = <space>
        let mapleader = "\<Space>"

    " Open netrw in the dir of the current file
        nnoremap <leader>dd :Lexplore %:p:h<CR>
    " Open netrw in the current workdir
        nnoremap <Leader>da :Lexplore<CR>
    " Make new split below and switch over to it
        nnoremap <leader>w <C-w><C-s><C-w>j
    " Make new split to the right and switch over to it
        nnoremap <leader>v <C-w><C-v><C-w>l
    " Navigate vim buffers easier
        nnoremap <M-J> <C-W><C-J>
        nnoremap <M-K> <C-W><C-K>
        nnoremap <M-L> <C-W><C-L>
        nnoremap <M-H> <C-W><C-H>
    " Search for files with fzf
        nnoremap <C-p> :Files<CR>
    " Search for files recursively with fzf
        nnoremap <C-g> :Rg<CR>
    " Ansible-vault-inline to ,v
        nmap <leader>ave :AnsibleVault <CR>
        nmap <leader>avd :AnsibleUnvault <CR>
    " Git - Merge problems resolution
        nmap <leader>gj :diffget //3<CR>
        nmap <leader>gf :diffget //2<CR>
    " Go to definition
        nmap <silent> gd <Plug>(coc-definition)
    " Find references
        nmap <silent> gr <Plug>(coc-references)
    " Use K to show documentation in preview window.
        nnoremap <silent> K :call <SID>show_documentation()<CR>
    " Use `[g` and `]g` to navigate diagnostics
        nmap <silent> [g <Plug>(coc-diagnostic-prev)
        nmap <silent> ]g <Plug>(coc-diagnostic-next)
    " Mappings for switching between tmux and vim panes seamlessly
        let g:tmux_navigator_no_mappings = 1
        nnoremap <silent> <M-h> :TmuxNavigateLeft<cr>
        nnoremap <silent> <M-j> :TmuxNavigateDown<cr>
        nnoremap <silent> <M-k> :TmuxNavigateUp<cr>
        nnoremap <silent> <M-l> :TmuxNavigateRight<cr>
        nnoremap <silent> <M-\> :TmuxNavigatePrevious<cr>
    " Switch to current workdir of the file and print the result
        nnoremap <leader>cd :cd %:p:h<CR>:pwd<CR>
    " Netrw
        function! NetrwMapping()
        endfunction

        augroup netrw_mapping
          autocmd!
          autocmd filetype netrw call NetrwMapping()
        augroup END

        function! NetrwMapping()
          nmap <buffer> H u
          nmap <buffer> h -^
          nmap <buffer> l <CR>

          nmap <buffer> . gh
          nmap <buffer> P <C-w>z

          nmap <buffer> L <CR>:Lexplore<CR>
          nmap <buffer> <Leader>dd :Lexplore<CR>
        endfunction

" ##################
" coc.vim configuration

" Automatically install these extensions
let g:coc_global_extensions = ['coc-sh', 'coc-yaml', 'coc-json', 'coc-html', 'coc-css', 'coc-toml', 'coc-pyright', 'coc-docker']

" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes

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
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
if has('patch8.1.1068')
  " Use `complete_info` if your (Neo)Vim version supports it.
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  imap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current line.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Introduce function text object
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}
