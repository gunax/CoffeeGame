#CPU has 2 clock types
clock =
  m: 0
  t: 0

#8 8-bit registers, 2 16-bit registers SP and PC
register =
  A: 0
  B: 0
  C: 0
  D: 0
  E: 0
  F: 0
  H: 0
  L: 0
  SP: 0 #16-bit
  PC: 0 #16-bit

MMU =
  read8: (addr) ->
    #TODO: implement
  read16: (addr) ->
    #TODO: implement
  write8: (addr, value) ->
    #TODO: implement
  write16: (addr, value) ->
    #TODO: implement

reset = () ->
  register.A = register.B = register.C = register.D =
  register.E = register.F = register.H = register.L =
  register.SP = register.PC = 0

console.log(screen.MAXCYCLES)
reset()
console.log(register.A)