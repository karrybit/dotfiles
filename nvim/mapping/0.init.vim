" Common mappings
"
" Leaderの設定
let mapleader = "\<Space>"

" ファイルの書き込み
nnoremap <Leader>w :w<CR>
" ファイルを閉じる
nnoremap <Leader>q :q<CR>

" ノーマルモードに戻す
inoremap jj <Esc>

" 検索ハイライト解除
nnoremap <silent><Esc><Esc> :noh<CR>

" 貼り付けたテキストの末尾へ自動的に移動する
vnoremap <silent> y y`]
vnoremap <silent> p p`]
