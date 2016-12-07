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

let rawSql = """
select 
  name,'hello' as name2
from 
  test 
where 1=1
and name = /*name*/'abc'
or  name in ( /*name2*/'def' , /*name3*/'ghi' ) 
"""

var params = initTable[string,string]()
params["name"] = "abc"
params["name2"] = "def"
echo params.len

var qp = initSql2WayInfo(rawSql,params)

block :
  let db = open("", "postgres", "postgres", "host=localhost port=5432 dbname=sample")
  defer:
    db.close
  for row in db.fastRows( SqlQuery(qp.query) , qp.p(params)) :
    echo row.join("\t")
quit(0)