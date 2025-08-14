# Neovim
# Neovim Keymaps – README

## Leader klávesy
- `vim.g.mapleader = " "` – **Leader** je mezerník.
- `vim.g.maplocalleader = " "` – **LocalLeader** taky mezerník.

## Přesuny vybraného bloku (Visual mode)
- `J` → `:m '>+1<CR>gv=gv`  
  Posune označený blok **o řádek dolů**, znovu jej vybere a **přerovná odsazení**.
- `K` → `:m '<-2<CR>gv=gv`  
  Posune označený blok **o řádek nahoru**, znovu vybere a **přerovná odsazení**.

## Dělení oken
- `<leader>sv` → `:vsplit`  
  **Vertikální split**.
- `<leader>sh` → `:split`  
  **Horizontální split**.

## Vkládání ve Visual módu bez ztráty yanknutého textu
- (Visual) `p` → `pgvy`  
  Vloží obsah registru a **obnoví původní yank** (nezničí clipboard tím, co bylo přepsáno).

## Půlstránkové skoky s centrováním (Normal mode)
- `<C-d>` → `<C-d>zz`  
  Skok o půl stránky **dolů** + kurzor na **střed obrazovky**.
- `<C-u>` → `<C-u>zz`  
  Skok o půl stránky **nahoru** + **střed**.

## Navigace v Quickfix listu (Normal mode)
- `<S-d>` → `:cnext | zz`  
  **Další** položka v quickfixu + centrum.
- `<S-u>` → `:cprev | zz`  
  **Předchozí** položka v quickfixu + centrum.  
  > Pozn.: Přemapovává výchozí `D`/`U`.

## Clipboard zkratky (s `opts = { noremap = true, silent = true }`)
- (Visual) `<leader>y` → `"+y`  
  **Zkopíruje výběr do systémové schránky** (registr `+`).
- (Normal) `<leader>yp` → `:let @+ = expand('%:p')`  
  **Zkopíruje absolutní cestu** aktuálního souboru do schránky.
- (Normal) `<leader>ya` → `:%y+`  
  **Zkopíruje celý soubor** (buffer) do schránky.

## Přepínač zvýraznění hledání (hlsearch)
- (Normal) `<leader>hl`  
  Přepíná `hlsearch` ON/OFF a **vypíše stav**: `Highlight search: ON/OFF`.

---
