# 通常のコマンドラインアプリサンプル その２

import parseopt2

# メインモジュールとして起動しているかチェック
if isMainModule :
    # イテレータで取得    
    for kind, key, val in getopt() :
        # (余談)kindは、enum型なので、case文ではすべてのenum値
        # を網羅していないとコンパイルエラーとなります
        case kind
        of cmdArgument:
            echo "引数 >" $key
        of cmdLongOption, cmdShortOption:
            echo "オプション > ",key,"=" ,val
        of cmdEnd:
            echo "終了"
