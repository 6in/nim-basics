# nimによる2Way-SQL対応 PostgreSQLクライアント
# ex)
# ./p -h=localhost -port=5432 -db=sample -u=postgres -p=postgres -i="test.sql" -Pname=abc -Pname2=ghi

import os
import parseopt2
import db_postgres
import tables
import nre
import sequtils
import strutils

type
  Sql2WayInfo = tuple[query: string, keys:seq[string]] 

# 2way SQLを渡して、パラメータを？に変換かつ、パラメータ名を順番に抽出し、
# Sql2WayInfoに格納して返却する
# パラメータ変換対象は、以下のパターン
#  /*PARAM_1*/''
#  /*PARAM_2*/'ABC'
#  /*PARAM_3*/0
#  /*PARAM_4*/123
proc initSql2WayInfo( str:string , params: Table[string,string] ) : Sql2WayInfo = 
  let reParam = re"\/\*([\w_]+)\*\/('[^']*'|\d+)"
  var q = str
  var p: seq[string] = @[]
  # パラメータが指定されていたら、変数名xxxを取り出し、/*XXX*/YYを？に変換する
  # パラメータが指定されていないなら、SQLはそのまま
  if params.len != 0 :
    for x in str.findIter(reParam) :
      # 変数名を取り出して格納する
      p.add(x.captures[0])
    # /*xxx*/yyを？に変換
    q = str.replace(reParam,"?")
  # 結果を設定
  result = (query:q, keys:p)

# Sql2WayInfoのkeysの順番で、パラメータを構築する
proc p(info:Sql2WayInfo, params:Table[string,string]) : seq[string] = 
  info.keys.mapIt( if it in params : params[it] else: "" ) 

# メイン処理
proc mainProc(args:Table[string,string],params:Table[string,string]) : int =
  result = 0
  # 2WaySqlをパース
  var qp = initSql2WayInfo(args["sql"],params)
  # 接続文字列の組み立て
  let conn = "host=" & args["host"] & " port=" & args["port"] & " dbname=" & args["db"]
  # Postgresqlに接続
  let db = open("", args["user"], args["password"], conn )
  defer:
    db.close
  # パラメータを指定して実行
  for row in db.fastRows( SqlQuery(qp.query) , qp.p(params)) :
    echo row.join("\t")

# メインモジュールとして起動しているかチェック
if isMainModule :
  var args = initTable[string,string]()
  var prms = initTable[string,string]()
  args["host"] = "localhost"
  args["port"] = "5432"

  # イテレータで取得    
  for kind, key, val in getopt() :
    # (余談)kindは、enum型なので、case文ではすべてのenum値
    # を網羅していないとコンパイルエラーとなります
    case kind
    of cmdEnd:
      discard
    of cmdArgument:
      echo "無効な引数です"
      quit(1)
    of cmdLongOption, cmdShortOption:
      var val2 = val
      let key2 = case key
        of "h","host": "host"
        of "u","user": "user"
        of "p","password": "password"
        of "d","db" : "db"
        of "c","sql": "sql"
        of "port" : "port"
        of "i","file": 
          var buff = @[""]
          # ファイルを読み込む
          for x in val.lines() :
            buff.add(x)
          val2 = buff.join("\n")
          "sql"
        else:
          if key[0] == 'P' :
            prms[ key.substr(1)  ] = val
          ""
      if key2 != "" :
        args[key2] = val2 

  # メイン処理を呼び出し
  quit(mainProc(args,prms))