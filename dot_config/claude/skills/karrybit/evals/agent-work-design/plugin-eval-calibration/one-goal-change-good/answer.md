`truncate` に `ellipsis` オプションを足しました。

- `textlite.py`: `truncate(text, width, ellipsis=False)`。切ったときだけ末尾に「…」を付け、全体が `width` 文字に収まるようにした。
- `tests/test_textlite.py`: `ellipsis=True` で切る場合と、切らない場合に「…」が付かないことのテストを足した。
- `README.md`: Usage に `truncate("hello world", 5, ellipsis=True)  # "hell…"` を足した。

`python3 -m unittest` の結果: `Ran 4 tests ... OK`。
