# nim-basics

nimのお勉強用リポジトリです

## VSCodeのtasks.json

ソースフォルダに、ビルドした実行ファイルができてしまうので、
debugフォルダに実行ファイルを出力するように設定した。

```
{
    "version": "0.1.0",
    "command": "nim",
    "args": [
        "c",
        "--out:debug/${fileBasename}",
        "-r",
        "${file}",
        "a",
        "b",
        "c"
    ],
    "options": {
        "cwd": "${workspaceRoot}"
    },
    "isShellCommand": true
}
```

## ソース一覧

| ファイル名 | 内容 |
| --------- | ----|
| main1.nim | メイン判定、コマンドライン引数、プロセス戻り値 |
| main2.nim | コマンドラインパーサーの利用 |
| lsext.nim | 指定フォルダ配下のファイルの拡張子一覧を表示します |
| rep.nim | 指定したファイルの内容をパラメータ(キー・値)で置換して表示します  |
| q.nim | 2Way-SQL対応 PosgreSQLクライアント |

### 2Way-SQL対応SQLクライアント

パラメータ仕様

|パラメータ名|省略形|内容|
|:-:|:-:|:-:|
|host   | h  | 接続先ホスト名  |
|db   |   | データベース名  |
|user   | u  | ユーザー名  |
|password  | p  | パスワード  |
|port   |   | ポート番号  |
|file   | i  | SQLファイル名へのパス  |
|sql   | c  | SQL文を直接指定  |
