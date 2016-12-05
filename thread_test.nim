{.experimental.}
import os
# Compute PI in an inefficient way
import strutils, math, threadpool

proc term(k: float): float = 4 * math.pow(-1, k) / (2*k + 1)

proc pi(n: int): float =
  var ch = newSeq[float](n+1)
  parallel:
    for k in 0..ch.high:
      ch[k] = spawn term(float(k))
  for k in 0..ch.high:
    result += ch[k]


proc pi2(n: int): float =
  var ch = newSeq[float](n+1)
  for k in 0..ch.high:
    ch[k] = term(float(k))
  for k in 0..ch.high:
    result += ch[k]

if os.paramCount() == 0:
  # スレッド版のほうが時間かかる(笑)
  echo formatFloat(pi(500000))
else :
  echo formatFloat(pi2(500000))
