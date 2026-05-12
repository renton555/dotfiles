" ==========================================================
" 1. CORE NEOVIM SETTINGS (From your init.lua)
" ==========================================================
" Sync system clipboard (unnamedplus equivalent)
set clipboard=unnamed

" Have j and k navigate visual lines rather than logical ones 
nmap j gj
nmap k gk

" Clear search highlights with <Esc> (Exact match to your lua)
nmap <Esc> :nohl<CR>
" ==========================================================
" 2. WINDOW & PANE MANAGEMENT (The <C-h/j/k/l> mappings)
" ==========================================================
" You use CTRL+hjkl to move between splits in Neovim. 
" Here is the exact equivalent for Obsidian's panes.
exmap focusLeft obcommand editor:focus-left
nmap <C-h> :focusLeft<CR>

exmap focusRight obcommand editor:focus-right
nmap <C-l> :focusRight<CR>

exmap focusUp obcommand editor:focus-top
nmap <C-k> :focusUp<CR>

exmap focusDown obcommand editor:focus-bottom
nmap <C-j> :focusDown<CR>

" ==========================================================
" 3. LEADER KEY & PLUGIN EMULATION
" ==========================================================
" Spacekeys leader
"exmap spacekeysleader obcommand spacekeys:leader
"nmap <Space> :spacekeysleader<CR>
"vmap <Space> :spacekeysleader<CR>

" Set Leader to Space
"unmap <Space>

" -- TELESCOPE EMULATION --
" <leader>sf (Search Files) -> Obsidian Quick Switcher
"exmap searchFiles obcommand switcher:open
"nmap <Space>sf :searchFiles<CR>

" <leader>sg (Search Grep) -> Obsidian Global Search
"exmap searchGrep obcommand global-search:open
"nmap <Space>sg :searchGrep<CR>

" <leader><leader> (Search Buffers) -> Obsidian Recent Files (or Switcher)
"exmap recentFiles obcommand core:open-recent
"nmap <Space><Space> :recentFiles<CR>

" -- OIL.NVIM EMULATION --
" '-' to open parent directory -> Reveal current file in Obsidian File Explorer
"exmap revealFile obcommand file-explorer:reveal-active-file
"nmap - :revealFile<CR>

" -- HARPOON EMULATION --
" <C-e> to toggle quick menu -> Obsidian Bookmarks
"exmap bookmarks obcommand bookmarks:open
"nmap <C-e> :bookmarks<CR>

" ==========================================================
" 4. OBSIDIAN-SPECIFIC AUTOMATION (From our previous setup)
" ==========================================================
" Toggle Tasks (<Space>t)
"exmap toggleTask obcommand obsidian-tasks-plugin:toggle-done
"nmap <Space>t :toggleTask<CR>

" Trigger QuickAdd (<Space>q)
"exmap quickadd obcommand quickadd:runQuickAdd
"nmap <Space>q :quickadd<CR>

" Trigger Metadata Menu (<Space>m)
"exmap mdm obcommand metadata-menu:fileclass-controls
"nmap <Space>m :mdm<CR>

" ==========================================================
" 5. MINI.SURROUND EMULATION
" ==========================================================
" The Vimrc Support plugin allows us to emulate mini.surround
" This makes 'S' in visual mode wrap text in Obsidian links or formatting
exmap surround_wiki surround [[ ]]
exmap surround_bold surround ** **
exmap surround_italic surround * *
exmap surround_code surround ` `

" Select text, hit 'S', then '[' to make it an Obsidian link
"vmap <Space>w :surround_wiki<CR>
"vmap <Space>b :surround_bold<CR>
"vmap <Space>i :surround_italic<CR>
"vmap <Space>c :surround_code<CR>

" ==========================================================
" 6.  Custom Area
" ==========================================================

nmap H ^
nmap L $

" Go back and forward with Ctrl+O and Ctrl+I
" (make sure to remove default Obsidian shortcuts for these to work)
exmap back obcommand app:go-back
nmap <C-o> :back<CR>
exmap forward obcommand app:go-forward
nmap <C-i> :forward<CR>