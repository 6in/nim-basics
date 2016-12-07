# ファイル内の文字列置換ツール

import os
import parseopt2
import tables
import queues
import strutils

# 置換処理を行う
proc rep_files(file:string,params:Table[string,string]) : int =
  result = 0
  # ファイルの存在チェック
  if file.existsFile :
    # ファイルを１行ずつ読み込む
    for line in file.lines :
      var work = line
      # パラメータで置換する
      for k,v in params :
        work = work.replace(k,v)
      echo work
  else: 
    result = 1

# メインモジュールとして起動しているかチェック
if isMainModule :
  var files = initQueue[string]()
  var params = initTable[string,string]()
  # イテレータで取得    
  for kind, key, val in getopt() :
    # (余談)kindは、enum型なので、case文ではすべてのenum値
    # を網羅していないとコンパイルエラーとなります
    case kind
    of cmdArgument:
      # ファイル名として保存
      if files.len == 0 :
        files.add(key)
      else :
        echo "指定できるファイルは１つだけです"
        quit(1)
    of cmdLongOption, cmdShortOption:
      # 置換パラメータを保存(大文字版も追加)
      params[ [ "${" , key , "}"].join("") ] = val
      params[ [ "${" , key.toUpperAscii , "}"].join("") ] = val.toUpperAscii
    of cmdEnd:
      discard
  
  # 置換処理を呼び出す
  quit(rep_files(files[0],params))
