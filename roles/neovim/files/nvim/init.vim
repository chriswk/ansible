syntax on

set clipboard=unnamed,unnamedplus " copy to clipboard
set relativenumber                " show relative numbers

"------------------------------
" Indentation
"------------------------------
set autoindent
set copyindent                    " copy indent from the previous line
set expandtab                     " tabs are space
set shiftwidth=4                  " number of spaces to use for autoindent
set softtabstop=4                 " number of spaces in tab when editing
set tabstop=4                     " number of visual spaces per TAB

"------------------------------
" Use Ctrl + Backspace - delete word before the cursor
"------------------------------
noremap! <C-BS> <C-w>
noremap! <C-h> <C-w>
imap <C-BS> <C-w>

"------------------------------
" Use Ctrl + Del       - delete word after the cursor
"------------------------------
imap <C-Del> <C-o>dw

"------------------------------
" Highlight extra whitespaces
"------------------------------
:highlight ExtraWhitespace ctermbg=red guibg=red
:match ExtraWhitespace /\s\+$/

"------------------------------
" Jump to the last cursor position
"------------------------------
autocmd BufReadPost *
  \ if line("'\"") > 0 && line ("'\"") <= line("$") |
  \   exe "normal g'\"" |
  \ endif

"------------------------------
" Plugins
"------------------------------
call plug#begin()

Plug 'tpope/vim-fugitive'            " Git wrapper
Plug 'tpope/vim-rhubarb'             " GitHub handler
Plug 'shumphrey/fugitive-gitlab.vim' " GitLab handler
" Use release branch (Recommend)
Plug 'neoclide/coc.nvim', {'branch': 'release'} " Conqueror of code
Plug 'neoclide/coc-tsserver.nvim' " Conqueror of code
Plug 'neoclide/coc-git.nvim' " Conqueror of code
Plug 'neoclide/coc-json.nvim' " Conqueror of code
Plug 'neoclide/coc-rls.nvim' " Conqueror of code
Plug 'neoclide/coc-python.nvim' " Conqueror of code
Plug 'neoclide/coc-prettier.nvim' " Conqueror of code
Plug 'neoclide/coc-java.nvim' " Conqueror of code
Plug 'neoclide/coc-css.nvim' " Conqueror of code
Plug 'neoclide/coc-yaml.nvim' " Conqueror of code
Plug 'neoclide/coc-pairs.nvim' " Conqueror of code

Plug 'rodjek/vim-puppet'             " Puppet support

call plug#end()

"------------------------------
" Plugins configuration
"------------------------------
let g:fugitive_gitlab_domains = [ 'https://gitlab.cern.ch' ]

"------------------------------
" CoC config
#------------------------------
"Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
" <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

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

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of LS, ex: coc-tsserver
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

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

" Mappings using CoCList:
" Show all diagnostics.
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>
