opcodes = [
  #No OP
  NOP = (cpu) ->
    cpu.MMU.register.PC += 1
    cpu.clock.m += 1
    cpu.clock.t += 4

  #load BC with constant nn
  LDBCnn = () ->
    cpu.register.C = cpu.MMU.read8(cpu.register.PC)
    cpu.register.B = cpu.MMU.read8(cpu.register.PC+1)
    cpu.register.PC += 3
    cpu.clock.m += 3
    cpu.clock.t += 12

  #load address BC with A
  LDBCmA = () ->
    BC = cpu.register.readBC()
    cpu.MMU.write8(BC, A)
    cpu.register.PC += 1
    cpu.clock.m += 1
    cpu.clock.t += 8

  #Increment BC
  INC_BC = () ->
    cpu.register.writeBC(cpu.register.readBC()+1)
    cpu.register.PC += 1
    cpu.clock.m += 1
    cpu.clock.t += 8

  #Increment B
  INC_B = () ->
    cpu.register.B++
    if (cpu.register.B == 256)
      cpu.register.B = 0
    cpu.register.PC += 1
    cpu.clock.m += 1
    cpu.clock.t += 4

  #Decrement B
  DEC_B = () ->
    cpu.register.B--
    if (cpu.register.B == -1)
      cpu.register.B = 255
    cpu.register.PC += 1
    cpu.clock.m += 1
    cpu.clock.t += 4

  #Load 8-bit n into B
  LDBn = () ->
    n = cpu.MMU.read8(cpu.register.PC+1)
    cpu.register.B = n
    cpu.register.PC += 2
    cpu.clock.m += 2
    cpu.clock.t += 8


]
