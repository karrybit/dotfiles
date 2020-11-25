" Size
let NERDTreeWinSize=40
" 隠しファイルを表示する
let NERDTreeShowHidden = 1

" ファイル指定で開かれた場合はNERDTreeは表示しない
if !argc()
    autocmd vimenter * NERDTree|normal gg3j
endif
