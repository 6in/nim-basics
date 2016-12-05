# 指定フォルダ配下の拡張子とその数を取得する

import os
import tables
import algorithm
import future

# 指定フォルダを再帰で探索し、(拡張子：個数)を返却する
proc get_ext_list_impl(startPath:string): Table[string,int] =
  result = initTable[string,int]()

  # 再帰で探索
  for f in startPath.walkDirRec :
    if f.existsFile :
      let (_,_,ext) = f.splitFile
      if ext == "" : continue
      # 既に格納されているか確認
      if result.contains(ext) == false :
        result[ext] = 0
      # カウントアップ
      result[ext] += 1

# メイン関数
proc main(args:seq[string]):int =
  # メイン処理
  result = 1
  # 対象パスを特定(対象フォルダを１つだけ指定)
  # 対象パスがない場合は、カレントディレクトリを検索対象とする
  let path =
    if args.len == 1: args[0]
    else: "."

  # ディレクトリチェック
  if path.existsDir == false :
    echo "directory(",path,") is not exists"
    # プログラム終了
    return

   # フォルダを探索し、拡張子と頻度を取得
  let ret = get_ext_list_impl(path)

  # 内包表記で、キー一覧を取得
  let keys = lc[ k | (k <- ret.keys), string ]

  # キーをソートして、カウンタを表示する
  for k in keys.sortedByIt(it):
    echo k,"\t",ret[k]

  # main関数の戻り値
  result = 0

when isMainModule:
  # 引数を取得
  let args = commandLineParams()
  # メイン関数を実行
  quit(main(args))
