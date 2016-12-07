{.passL: "-lobjc".}
const objcsrc = staticRead("objcsrc.m")
{.emit: objcsrc.}

type
  Id {.importc: "id", header: "<objc/Object.h>", final.} = distinct int

proc newGreeter: Id {.importobjc: "Greeter new", nodecl.}
proc greet(self: Id, x, y: int) {.importobjc: "greet", nodecl.}
proc free(self: Id) {.importobjc: "free", nodecl.}

var g = newGreeter()
g.greet(12, 34)
g.free()