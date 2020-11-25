" =============================================================================
" Plugin Manager
" =============================================================================
let g:dein#auto_recache = 1
if &compatible
  set nocompatible
endif

" Install Directory
let s:dein_dir = expand('~/.cache/dein')
" 本体
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
" dein.vim がない場合githubから落とす
if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
  endif
  execute 'set runtimepath^=' . fnamemodify(s:dein_repo_dir, ':p')
endif

" 設定開始
if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  " プラグインリストを収めた TOML ファイル
  " 予め TOML ファイル（後述）を用意しておく
  let g:rc_dir    = expand('~/.config/nvim/rc')
  let s:toml      = g:rc_dir . '/dein.toml'
  let s:lazy_toml = g:rc_dir . '/dein_lazy.toml'

  " TOML を読み込み、キャッシュしておく
  call dein#load_toml(s:toml,      {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 1})
  call dein#add('nvim-treesitter/nvim-treesitter', { 'merged': 0 })

  call dein#end()
  call dein#save_state()
endif

" もし、未インストールものものがあったらインストール
if dein#check_install()
  call dein#install()
endif

let g:dein#install_max_processes = 16

" =============================================================================
" General
" =============================================================================

set smartcase
set splitbelow                                  "スプリット時に順番を変更
let g:WebDevIconsUnicodeDecorateFolderNodes = 1 "フォルダアイコンの表示
set guifont=Cica:h24                                "フォントの設定
set guifontwide=Cica:h24                            "フォントの設定
set fenc=utf-8                                  "UTF-8に設定
set encoding=UTF-8
set nobackup                                    "バックアップファイルを作らない
set noswapfile                                  "スワップファイルを作らない
set autoread                                    "編集中のファイルが変更されたら自動で読み直す
set hidden                                      "バッファが編集中でもその他のファイルを開けるように
set showcmd                                     "入力中のコマンドをステータスに表示する
set clipboard=unnamed,unnamedplus               "クリップボードの設定
set number                                      "行番号を表示
set cursorline                                  "現在の行を強調表示
set virtualedit=onemore                         "行末の1文字先までカーソルを移動できるように
set smartindent                                 "インデントはスマートインデント
set visualbell                                  "ビープ音を可視化
set showmatch                                   "括弧入力時の対応する括弧を表示
set laststatus=2                                "ステータスラインを常に表示
set wildmode=list:longest                       "コマンドラインの補完
syntax enable                                   "シンタックスハイライトの有効化
set list listchars=tab:\▸\-                     "不可視文字を可視化(タブが「▸-」と表示される)
set expandtab                                   "Tab文字を半角スペースにする
set tabstop=2                                   "行頭以外のTab文字の表示幅（スペースいくつ分）
set shiftwidth=2                                "行頭でのTab文字の表示幅
set nospell                                     "スペルチェックを無効
set matchpairs+=<:>                             "pairの追加
set title                                       "set gui title
set mouse=nv                                    " mouse support

" カーソルの変更
if has('vim_starting')
  let &t_SI .= "\e[6 q"
  let &t_EI .= "\e[2 q"
  let &t_SR .= "\e[4 q"
endif

"タブ、空白、改行の可視化
set list
set listchars=tab:>»,trail:-,eol:↲,extends:>,precedes:<,nbsp:%

"全角スペースをハイライト表示
function! ZenkakuSpace()
    highlight ZenkakuSpace cterm=reverse ctermfg=DarkMagenta gui=reverse guifg=DarkMagenta
endfunction

if has('syntax')
    augroup ZenkakuSpace
        autocmd!
        autocmd ColorScheme       * call ZenkakuSpace()
        autocmd VimEnter,WinEnter * match ZenkakuSpace /　/
    augroup END
    call ZenkakuSpace()
endif

" Gitコメントのハイライトを修正
au FileType gitcommit syntax match gitcommitComment /^[>"].*/

" =============================================================================
" 挙動の修正
" =============================================================================

" 貼り付け時にペーストバッファが上書きされないようにする
function! RestoreRegister()
  let @" = s:restore_reg
  return ''
endfunction
function! s:Repl()
  let s:restore_reg = @"
  return "p@=RestoreRegister()\<cr>"
endfunction
vmap <silent> <expr> p <sid>Repl()

" カーソル選択位置の色を取得するユーティリティ関数
" :SyntaxInfo で実行する
function! s:get_syn_id(transparent)
  let synid = synID(line("."), col("."), 1)
  if a:transparent
    return synIDtrans(synid)
  else
    return synid
  endif
endfunction
function! s:get_syn_attr(synid)
  let name = synIDattr(a:synid, "name")
  let ctermfg = synIDattr(a:synid, "fg", "cterm")
  let ctermbg = synIDattr(a:synid, "bg", "cterm")
  let guifg = synIDattr(a:synid, "fg", "gui")
  let guibg = synIDattr(a:synid, "bg", "gui")
  return {
        \ "name": name,
        \ "ctermfg": ctermfg,
        \ "ctermbg": ctermbg,
        \ "guifg": guifg,
        \ "guibg": guibg
        \ }
endfunction
function! s:get_syn_info()
  let baseSyn = s:get_syn_attr(s:get_syn_id(0))
  echo "name: " . baseSyn.name .
        \ " ctermfg: " . baseSyn.ctermfg .
        \ " ctermbg: " . baseSyn.ctermbg .
        \ " guifg: " . baseSyn.guifg .
        \ " guibg: " . baseSyn.guibg
  let linkedSyn = s:get_syn_attr(s:get_syn_id(1))
  echo "link to"
  echo "name: " . linkedSyn.name .
        \ " ctermfg: " . linkedSyn.ctermfg .
        \ " ctermbg: " . linkedSyn.ctermbg .
        \ " guifg: " . linkedSyn.guifg .
        \ " guibg: " . linkedSyn.guibg
endfunction
command! SyntaxInfo call s:get_syn_info()

" =============================================================================
" Neovide
" =============================================================================
set guifont=Cica:h12                                          " set font

let g:neovide_cursor_animation_length=0.1
let g:neovide_refresh_rate=60
let g:neovide_cursor_trail_size=0.1
let g:neovide_cursor_antialiasing=v:false

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_idx_mode = 1
let g:airline#extensions#tabline#buffer_idx_format = {
    \ '0': '0 ',
    \ '1': '1 ',
    \ '2': '2 ',
    \ '3': '3 ',
    \ '4': '4 ',
    \ '5': '5 ',
    \ '6': '6 ',
    \ '7': '7 ',
    \ '8': '8 ',
    \ '9': '9 '
    \}


" =============================================================================
" Neoterm
" =============================================================================
let g:neoterm_default_mod='botright'
let g:neoterm_size=12
let g:neoterm_autoscroll=1

" =============================================================================
" mapping
" =============================================================================

" import mapping
" 自分でマッピングを定義したらこんな感じでファイルを分けてやると良いです。
" 今は0.init.vim以外はコメントアウトしてます
source ~/.config/nvim/mapping/0.init.vim
" source ~/.config/nvim/mapping/camelcasemotion.vim
source ~/.config/nvim/mapping/coc.vim
" source ~/.config/nvim/mapping/expand-region.vim
" source ~/.config/nvim/mapping/memolist.vim
source ~/.config/nvim/mapping/nerdtree.vim
" source ~/.config/nvim/mapping/operator-camelize.vim
" source ~/.config/nvim/mapping/ripgrep.vim
source ~/.config/nvim/mapping/neoterm.vim
