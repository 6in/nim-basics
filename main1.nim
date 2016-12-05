# 通常のコマンドラインアプリサンプル その１

import system
import os

# メインモジュールとして起動しているかチェック
if isMainModule :
    # 終了コードは、system.programResult に設定する
    if paramCount() == 0 :
        system.programResult = 1
    else :
        # パラメータの取得
        echo "パラメータの数 =" $os.paramCount()
        echo "コマンドラインパラメータ = " $os.commandLineParams()
        echo "１個目のパラメータ = " $os.commandLineParams()[0]
        system.programResult = 0