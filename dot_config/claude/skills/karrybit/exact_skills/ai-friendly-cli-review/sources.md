# ai-friendly-cli-review の判定の基準の出典

`SKILL.md` の判定の基準を見直すときに読む。基準ごとに拠った出典と節を示し、指針の出典がなくこの skill が置く基準と、指針どうしが食い違う点の決め方を示す。表にない決まり（調べるときの決まり、判定の語と重さ）は、この skill が自分で決めたもの。

## 出典

確認日はどれも 2026-11-18。

| 略称 | 出典 | 確かめた版 |
| --- | --- | --- |
| clig | Command Line Interface Guidelines https://clig.dev | リポジトリ cli-guidelines/cli-guidelines の `content/_index.md`（commit 2bd6023eae2a） |
| POSIX | The Open Group Base Specifications Issue 8（IEEE Std 1003.1-2024）https://pubs.opengroup.org/onlinepubs/9799919799/ | XBD 12.2、XCU 1.4、XCU 2.8.2、XCU の `grep` |
| sysexits | FreeBSD の `include/sysexits.h` https://github.com/freebsd/freebsd-src/blob/main/include/sysexits.h | main の版 |
| GNU | GNU Coding Standards「4.7 Standards for Command Line Interfaces」https://www.gnu.org/prep/standards/html_node/Command_002dLine-Interfaces.html | gnulib の `doc/standards.texi`（lastupdate November 4, 2026）で本文を読んだ |
| gh | GitHub CLI のマニュアル `gh help exit-codes`、`gh help formatting`、`gh auth login --help` | gh 2.104.0 |
| Heroku | Heroku Dev Center「CLI Style Guide」https://devcenter.heroku.com/articles/cli-style-guide | Last updated January 31, 2025 |

## 基準ごとの出典

| 基準 | 出典 |
| --- | --- |
| 1: 主な出力を JSON で出すオプションがあり、名前は `--json` か、サブコマンドの間で揃える | clig 節 Output（「Display output as formatted JSON if `--json` is passed.」）。clig 節 Arguments and flags（「Use standard names for flags, if there is a standard.」の一覧の `--json`）。clig 節 Subcommands（「Be consistent across subcommands.」）。Heroku 節「Human-readable output vs machine-readable output」（「commands should offer a --json and/or a --terse flag」） |
| 1: stdout にデータ、stderr に進捗・警告・エラー | clig 節 The Basics（「Send output to `stdout`.」「Send messaging to `stderr`.」）。POSIX XCU 1.4 の STDERR（「The standard error shall be used only for diagnostic messages.」）。Heroku 節「Stdout/Stderr」 |
| 1: stdout が端末でないとき色の制御文字を出さない | clig 節 Output（「Disable color if your program is not in a terminal or the user requested it.」） |
| 1: 出力の欄を足すだけにする互換の方針が書いてある | clig 節 Future-proofing（「Keep changes additive where you can.」「Encourage your users to use `--plain` or `--json` in scripts to keep output stable」）。Heroku 節「Human-readable output vs machine-readable output」（「Generally this means additional information is OK, but modifying existing output is problematic.」） |
| 2: 成功のときだけ 0、失敗で 0 以外 | clig 節 The Basics（「Return zero exit code on success, non-zero on failure.」）。POSIX XCU 1.4 の EXIT STATUS |
| 2: 次の手が変わる失敗を終了コードで見分けられる | clig 節 The Basics（「Map the non-zero exit codes to the most important failure modes.」）。sysexits（`EX_USAGE`、`EX_NOINPUT`、`EX_NOPERM`、`EX_TEMPFAIL` の「temp failure; user is invited to retry」）。gh `exit-codes`（4 が認証） |
| 2: 割り当てが help か文書にある | gh `exit-codes`（「it is a good practice to check documentation for the command if you are relying on exit codes」） |
| 2: 126・127 と 128 より大きい値を使わない | POSIX XCU 2.8.2（「If the command is not found, the exit status shall be 127.」、見つかったが実行できないときの 126、シグナルで終わったときの 128 より大きい値） |
| 2: 「見つからない」の 1 を文書にする | POSIX XCU の `grep` の EXIT STATUS（0 が選んだ行あり、1 が「No lines were selected.」、1 より大きい値がエラー） |
| 3: 初期設定を含めて入力をフラグか引数か stdin で渡せ、対話の入力を要らない | clig 節 Arguments and flags（「Never _require_ a prompt.」「Always provide a way of passing input with flags or arguments.」）。Heroku 節 Prompting（「Ensure that args or flags can always be provided to bypass the prompt.」）。gh `auth login --help`（「use `--with-token` to pass in a personal access token (classic) on standard input」） |
| 3: stdin が端末でないとき止まらず、要るフラグを言って失敗する | clig 節 Interactivity（「Only use prompts or interactive elements if `stdin` is an interactive terminal (a TTY).」「you should throw an error telling the user what flag to pass」） |
| 3: 確認を飛ばすフラグか `--no-input` | clig 節 Arguments and flags（「Confirm before doing anything dangerous.」の `-f`・`--force` と `--confirm="name-of-thing"`）。clig 節 Interactivity（「If `--no-input` is passed, don’t prompt or do anything interactive.」） |
| 3: stdout が端末でないときページャを開かない | clig 節 Output（「Use a pager only if `stdin` or `stdout` is an interactive terminal.」） |
| 3: 秘密を stdin かファイルで渡せる。フラグの値だけ・環境変数だけを分けて数える | clig 節 Arguments and flags（「Do not read secrets directly from flags.」「Consider accepting sensitive data only via files, e.g. with a `--password-file` flag, or via `stdin`.」）。clig 節 Environment variables（「Do not read secrets from environment variables.」）。gh `auth login --help`（`--with-token` の「Read token from standard input」と、環境変数のトークンの「This method is most suitable for "headless" use of gh such as in automation.」） |
| 4: 名詞と動詞の 2 段、順を揃え、同じ操作に同じ動詞 | clig 節 Subcommands（「it is a common pattern to use two levels of subcommand for this, where one is a noun and one is a verb. For example, `docker container create`.」「Be consistent with the verbs you use across different types of objects.」「Either `noun verb` or `verb noun` ordering works, but `noun verb` seems to be more common.」）。Heroku 節「Naming the command」（「Generally topics are plural nouns and commands are verbs.」） |
| 4: 同じ意味のフラグに同じ名前、広く使われる名前に揃える | clig 節 Subcommands（「Be consistent across subcommands.」）。clig 節 Arguments and flags（「Use standard names for flags, if there is a standard.」とその一覧） |
| 4: 似た名前、任意の前方一致、省いたサブコマンドの解釈がない | clig 節 Subcommands（「Don’t have ambiguous or similarly-named commands.」）。clig 節 Future-proofing（「Don’t have a catch-all subcommand.」「Don’t allow arbitrary abbreviations of subcommands.」） |
| 4: フラグに長い形、`--` でオプションの終わり | clig 節 Arguments and flags（「Have full-length versions of all flags.」）。POSIX XBD 12.2 Guideline 10 |
| 5: `--help` が使い方・フラグ・例を stdout に出して 0 で終わる | GNU（「All programs should support two standard options: `--version` and `--help`.」、`--help` は「should output brief documentation for how to invoke the program, on standard output, then exit successfully」）。clig 節 Help（「Show full help when `-h` and `--help` are passed.」「Lead with examples.」） |
| 5: JSON の出力で選べる欄の名前を CLI から一覧で得られる | gh `formatting`（「To view the possible JSON field names for a command omit the string argument to the `--json` flag」） |
| 6: 何が誤りかと、次に打つコマンドかフラグを言う | clig 節 Errors（「Catch errors and rewrite them for humans.」）。clig 節 Interactivity（「If the command requires input, fail and tell the user how to pass the information as a flag.」）。clig 節 Output（「Suggest commands the user should run.」） |
| 6: 打ち間違いに候補を示し、推した候補を確かめずに実行しない | clig 節 Help（「If the user did something wrong and you can guess what they meant, suggest it.」「Assuming what they meant can be dangerous, especially if the resulting action modifies state.」） |
| 6: 状態を変えたとき何が変わったかを伝え、頼んだ結果と違うときはそう言う | clig 節 Output（「If you change state, tell the user.」と「particularly if the result doesn’t directly map to what the user requested」） |
| 7: `--dry-run`（`-n`）で何が起きるかを出す | clig 節 Arguments and flags（`-n`, `--dry-run` の「Do not run the command, but describe the changes that would occur if the command were run.」と、危険の程度 Moderate の「Consider giving the user a way to “dry run” the operation」） |
| 7: 途中で失敗した呼び出しを同じコマンドでやり直すと続きから進む | clig 節 Robustness（「Make it recoverable.」の「you should be able to hit `<up>` and `<enter>` and it should pick up from where it left off」と、「Make it crash-only. This is the next step up from idempotence.」） |
| 8: 1 行に 1 件の平らなテキストか JSON | clig 節 Output（`--plain` の「outputs one record per line」）。Heroku 節「grep-parseable」と「json-parseable」 |
| 8: `-` で stdin を受け付ける | clig 節 Arguments and flags（「If input or output is a file, support `-` to read from `stdin` or write to `stdout`.」）。POSIX XBD 12.2 Guideline 13 |
| 8: `-q`・`--quiet` | clig 節 Output（「you can provide a `-q` option to suppress all non-essential output」） |
| 9: 既定のタイムアウトがあり変えられる | clig 節 Robustness（「Make things time out. Allow network timeouts to be configured, and have a reasonable default so it doesn’t hang forever.」） |
| 9: 中断ですぐに終わる | clig 節 Signals and control characters（「If a user hits Ctrl-C (the INT signal), exit as soon as possible.」） |
| 10: 端末で読める文書が、入れた版と同じ内容を返す | clig 節 Documentation（「Provide terminal-based documentation.」の「it stays in sync with the specific installed version of the tool」と「Consider providing man pages.」） |
| 10: help に web の文書へのリンクがある | clig 節 Help（「In help text, link to the web version of the documentation.」）。clig 節 Documentation（「Provide web-based documentation.」） |

## 指針の出典がなく、この skill が置く基準

`SKILL.md` で「この skill が置く基準」と書いた 3 つ。どれも、エージェントの試行と取り違えを減らすために置く。

| 基準 | 置く理由 |
| --- | --- |
| 5: 引数とフラグの型・必須か・既定の値を、機械が読める形で返す入口（`describe` の JSON、JSON Schema など）がある | help のテキストを読んで推し量るより、型と必須を確かに知れれば、引数の誤りでやり直す回数が減る |
| 6: 機械が読める形の出力を頼んだとき、エラーも JSON で返し、次に打つコマンド・選べる値の候補・足りない引数を欄で持つ | エラーの文面から次の手を推し量らずに済み、候補の値をそのまま選んでやり直せる |
| 10: エージェント向けの手順（最初に打つコマンドの順など）を CLI と一緒に配り、手元の版のコマンドとフラグに合っている | 最初の手を探す試行が減り、手元の版にないコマンドを打つ取り違えが減る |

## 指針どうしが食い違う点の決め方

- 終了コードの値: clig は値を決めず重要な失敗への割り当てを求め、POSIX は呼ぶ側に 0 か 0 以外で調べることを求める。sysexits は 64〜78 を定めながら FreeBSD の base のソフトウェアには非推奨とし、gh は 1・2・4 を使う。この skill は値を問わず、次の手が変わる失敗を見分けられるかと、割り当てが文書にあるかで判定する。
- コマンドの順: clig はどちらの順でもよく揃っていることを求め、Heroku は名詞を先にする。この skill は、全体で揃っていればどちらの順も満たす側に数える。
- 秘密を環境変数で渡すこと: clig は避けるよう求め、gh は自動化のために環境変数のトークンを勧める。この skill は、環境変数だけなら一部、stdin かファイルがあれば満たす側に数える。
