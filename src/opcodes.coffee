class helperOps

  #16-bit n1, n2
  half_carry_check16: (n1, n2) ->
    (n1&0xfff) + (n2&0xfff) >= 0x1000

  #8-bit n1, n2
  half_carry_check8: (n1, n2) ->
    (n1&0xf) + (n2&0xf) >= 0x10

  #return n as signed (2s complement)
  toSigned: (n) ->
    if n > 127
      n = -((~n+1)&0xff)
    else
      n

  #=======================
  #8-bit loads
  #=======================

  #Load 8-bit n into r
  LDrn: (cpu, r) ->
    cpu.register[r] = cpu.MMU.read8(cpu.register['PC']+1)
    cpu.register['PC'] += 2
    cpu.clock.t += 8

  #Load register r from from register x
  LDrr: (cpu, r, x) ->
    cpu.register[r] = cpu.register[x]
    cpu.register['PC'] += 1
    cpu.clock.t += 4

  #Load register r from (HL)
  LDrHL: (cpu, r) ->
    register[r] = cpu.MMU.read8(cpu.register.readHL())
    cpu.register['PC'] += 1
    cpu.clock.t += 8

  #Load (BC) from register r
  LDBCr: (cpu, r) ->
    cpu.MMU.write8(cpu.register.readBC(), register[r])
    cpu.register['PC'] += 1
    cpu.clock.t += 8

  #Load (DE) from register r
  LDDEr: (cpu, r) ->
    cpu.MMU.write8(cpu.register.readDE(), register[r])
    cpu.register['PC'] += 1
    cpu.clock.t += 8

  #Load (HL) from register r
  LDHLr: (cpu, r) ->
    cpu.MMU.write8(cpu.register.readHL(), register[r])
    cpu.register['PC'] += 1
    cpu.clock.t += 8

  #Load (HL) with 8-bit operand n
  LDHLn: (cpu) ->
    n = cpu.MMU.read8(cpu.register['PC']+1)
    cpu.MMU.writeHL(n)
    cpu.register['PC'] += 2
    cpu.clock.t += 12

  #Load (NN) with register r
  LDNNr: (cpu, r) ->
    NN = cpu.MMU.write8(cpu.MMU.read16(cpu.register['PC']+1))
    cpu.MMU.write8(NN, cpu.register[r])
    cpu.register['PC'] += 3
    cpu.clock.t += 16

  #Load value at $FF00 + C into A
  LDAC: (cpu) ->
    val = cpu.MMU.read8(0xFF00 + cpu.register['C'])
    cpu.register['A'] = val
    cpu.MMU.register['PC'] += 1
    cpu.clock.t += 8

  #Load value A into ($FF00+C)
  LDCA: (cpu) ->
    val = cpu.register['A']
    cpu.MMU.write8(0xFF00 + cpu.register['C'], val)
    cpu.MMU.register['PC'] += 1
    cpu.clock.t += 8

  #Load A with (HL), decrement HL
  LDAHLmD: (cpu) ->
    val = cpu.MMU.read8(cpu.register.readHL())
    a = val
    cpu.register.writeHL(cpu.register.readHL() -1)
    cpu.register['PC'] += 1
    cpu.clock.t += 8

  #Load (HL) with A, decrement HL
  LDHLmAD: (cpu) ->
    a = cpu.register['A']
    cpu.MMU.write8(cpu.register.readHL(), a)
    cpu.register.writeHL(cpu.register.readHL() -1)
    cpu.register['PC'] += 1
    cpu.clock.t += 8

  #Load A with (HL), increment HL
  LDAHLmI: (cpu) ->
    val = cpu.MMU.read8(cpu.register.readHL())
    a = val
    cpu.register.writeHL(cpu.register.readHL() +1)
    cpu.register['PC'] += 1
    cpu.clock.t += 8

  #Load (HL) with A, increment HL
  LDHLmAI: (cpu) ->
    a = cpu.register['A']
    cpu.MMU.write8(cpu.register.readHL(), a)
    cpu.register.writeHL(cpu.register.readHL() +1)
    cpu.register['PC'] += 1
    cpu.clock.t += 8

  #Load A into (0xFF00 + n)
  LDHnA: (cpu) ->
    n = cpu.MMU.read8(cpu.register['PC']+1)
    cpu.MMU.write8(0xFF00 + n, cpu.register['A'])
    cpu.register['PC'] += 2
    cpu.clock.t += 12

  #Load (0xFF00 + n) into A
  LDHAn: (cpu) ->
    n = cpu.MMU.read8(cpu.register['PC']+1)
    cpu.register['A'] = 0xFF00 + n
    cpu.register['PC'] += 2
    cpu.clock.t += 12

  #====================
  #16-bit loads
  #====================
  LDrrnn: (cpu, rr) ->
    nn = cpu.MMU.read16(cpu.register['PC']+1)
    switch rr
      when 'BC'
        cpu.register.writeBC(nn)
      when 'DE'
        cpu.register.writeDL(nn)
      when 'HL'
        cpu.register.writeHL(nn)
      when 'SP'
        cpu.register.write(nn)
    cpu.register['PC'] += 3
    cpu.clock.t += 12

  #Copy HL to SP
  LDSPHL: (cpu) ->
    cpu.register['SP'] = cpu.register['HL']
    cpu.register['PC'] += 1
    cpu.clock.t += 8

  #Load SP+n into HL
  LDHLSPn: (cpu) ->
    n = cpu.MMU.read8(cpu.register['PC']+1)
    n = toSigned(n)
    new_HL = n + cpu.register['SP']
    cpu.register.set_Z_flag(0)
    cpu.register.set_N_flag(0)
    cpu.register.set_C_flag(new_HL & 0x100)
    cpu.register.set_H_flag(half_carry_check16(n, cpu.register['SP']))
    cpu.register.writeHL(new_HL)
    cpu.register['PC'] += 2
    cpu.clock.t += 12

  #Copy SP value into mem loc nn
  LDnnSP: (cpu) ->
    nn = cpu.MMU.read16(cpu.register['PC']+1)
    cpu.MMU.write8(nn, cpu.register['SP'])
    cpu.register['PC'] += 3
    cpu.clock.t += 20

  #Push 16-byte value onto stack. Dec SP twice
  PUSH: (cpu, rr) ->
    val = 0
    sp = cpu.register.readSP()
    switch rr
      when 'AF' then val = cpu.register.readAF()
      when 'BC' then val = cpu.register.readBC()
      when 'DE' then val = cpu.register.readDE()
      when 'HL' then val = cpu.register.readHL()
    hi = (val & 0xFF00) >> 8
    low = (val & 0xFF)
    cpu.MMU.write8(sp-1, hi)
    cpu.MMU.write8(sp-2, low)
    cpu.register['SP'] -= 2
    cpu.register['PC'] += 3
    cpu.clock.t += 16

  #Pop 16-byte value from stack. inc SP twice
  POP: (cpu, rr) ->
    sp = cpu.register.readSP()
    hi = cpu.MMU.read8(sp+1)
    low = cpu.MMU.read8(sp)
    val = (hi << 8) | low
    switch rr
      when 'AF' then cpu.register.writeAF(val)
      when 'BC' then cpu.register.writeBC(val)
      when 'DE' then cpu.register.writrDE(val)
      when 'HL' then cpu.register.writeHL(val)
    cpu.register['SP'] += 2
    cpu.register['PC'] += 3
    cpu.clock.t += 12

  #=========================
  #8-bit ALU
  #=========================

  #Add r to A
  ADD: (cpu, r) ->
    n = cpu.register[r]
    val = cpu.register['A'] + n
    cpu.register.set_H_flag(half_carry_check8(n, cpu.register['A']))
    cpu.register.set_C_flag(val > 0xFF)
    val &= 0xFF
    cpu.register['A'] = val
    cpu.register.set_Z_flag(!val)
    cpu.register.set_N_flag(0)
    cpu.register['PC'] += 1
    cpu.clock.t += 4

  #Add (HL) to A
  ADDrHLm: (cpu) ->
    n = cpu.MMU.read8(cpu.register.readHL())
    val = cpu.register['A'] + n
    cpu.register.set_H_flag(half_carry_check8(n, cpu.register['A']))
    cpu.register.set_C_flag(val > 0xFF)
    val &= 0xFF
    cpu.register['A'] = val
    cpu.register.set_Z_flag(!val)
    cpu.register.set_N_flag(0)
    cpu.register['PC'] += 1
    cpu.clock.t += 8

  #Add n to A
  ADDn: (cpu) ->
    n = cpu.MMU.read8(cpu.register['PC']+1)
    val = cpu.register['A'] + n
    cpu.register.set_H_flag(half_carry_check8(n, cpu.register['A']))
    cpu.register.set_C_flag(val > 0xFF)
    val &= 0xFF
    cpu.register['A'] = val
    cpu.register.set_Z_flag(!val)
    cpu.register.set_N_flag(0)
    cpu.register['PC'] += 2
    cpu.clock.t += 8


  #=========================
  #Inc and Decs
  #=========================

  #Increment register r
  INCr: (cpu, r) ->
    val = ++cpu.register[r]
    if val == 0x100
      val = 0
      cpu.register[r] = val
    cpu.register.set_Z_flag(val)
    cpu.register.set_N_flag(0)
    cpu.register.set_H_flag(!(val & 0xf))
    cpu.register['PC'] += 1
    cpu.clock.t += 4

  #Increment 16-bit register rr
  INCrr: (cpu, rr) ->
    val = 0
    switch rr
      when 'BC'
        val = cpu.register.readBC()+1
        val = 0 if val > 0xffff
        cpu.register.writeBC(val)
      when 'DE'
        val = cpu.register.readDE()+1
        val = 0 if val > 0xffff
        cpu.register.writeDE(val)
      when 'HL'
        val = cpu.register.readHL()+1
        val = 0 if val > 0xffff
        cpu.register.writeHL(val)
      when 'SP'
        val = cpu.register.readBC()+1
        val = 0 if val > 0xffff
        cpu.register.writeBC(val)
    cpu.register['PC'] += 1
    cpu.clock.t += 8

  #Decrement 16-bit register rr
  DECrr: (cpu, rr) ->
    val = 0
    switch rr
      when 'BC'
        val = cpu.register.readBC()-1
        val = 0xffff if val < 0
        cpu.register.writeBC(val)
      when 'DE'
        val = cpu.register.readDE()-1
        val = 0xffff if val < 0
        cpu.register.writeDE(val)
      when 'HL'
        val = cpu.register.readHL()-1
        val = 0xffff if val < 0
        cpu.register.writeHL(val)
      when 'SP'
        val = cpu.register.readBC()-1
        val = 0xffff if val < 0
        cpu.register.writeBC(val)
    cpu.register['PC'] += 1
    cpu.clock.t += 8

  #Increment (HL)
  INCHLm: (cpu) ->
    loc = cpu.readHL()
    val = cpu.MMU.read8(loc)+1
    val = 0 if val > 0xff
    cpu.MMU.write8(loc, val)
    cpu.register.set_Z_flag(val)
    cpu.register.set_N_flag(0)
    cpu.register.set_H_flag(!(val & 0xf))
    cpu.register['PC'] += 1
    cpu.clock.t += 12

  #Decrement register r
  DECr: (cpu, r) ->
    val = cpu.register[r]-1
    if val < 0
      val = 0xff
    cpu.register[r] = val
    cpu.register.set_Z_flag(val)
    cpu.register.set_N_flag(1)
    cpu.register.set_H_flag(val != 0xf)
    cpu.register['PC'] += 1
    cpu.clock.t += 4

  #Decrement (HL)
  DECHLm: (cpu) ->
    loc = cpu.readHL()
    val = cpu.MMU.read8(loc)-1
    val = 0xff if val < 0
    cpu.MMU.write8(loc, val)
    cpu.register.set_Z_flag(val)
    cpu.register.set_N_flag(1)
    cpu.register.set_H_flag(val != 0xf)
    cpu.register['PC'] += 1
    cpu.clock.t += 12

  #Add to HL from register rr
  ADDHLr: (cpu, rr) ->
    val = cpu.register.readHL()
    other = 0
    switch rr
      when 'BC' then other = cpu.register.readBC()
      when 'DE' then other = cpu.register.readDE()
      when 'HL' then other = cpu.register.readHL()
      when 'SP' then other = cpu.register.readSP()
    cpu.register.set_N_flag(0)
    cpu.register.set_H_flag( half_carry_check16(val, other) )
    val += other
    cpu.register.set_C_flag(val > 0xffff)
    cpu.register.writeHL(val & 0xffff)
    cpu.register['PC'] += 1
    cpu.clock.t += 8

  #Add 8 bit signed immediate n to SP
  ADDSPn: (cpu) ->
    n = cpu.MMU.read8(cpu.register['PC']+1)
    n = toSigned(n)
    val = cpu.register['SP'] + n
    cpu.register.set_H_flag(half_carry_check16(n, cpu.register['SP']))
    if val > 0xffff || val < 0
      cpu.register.set_C_flag(1)
      val &= 0xffff
    cpu.register['PC'] += 1
    cpu.clock.t += 8

  #Decimal Adjust A
  DAA: (cpu) ->
    a = cpu.register['A']
    nib1 = a & 0xf
    nib2 = (a & 0xf0) >> 4
    if nib1 > 9 || cpu.register.H_flag()
      a += 0x6
    if nib2 > 9 || cpu.register.C_flag()
      a += 0x60
    if a > 0xff
      a &= 0xff
      cpu.register.set_C_flag(1)
    else
      cpu.register.set_C_flag(0)
    cpu.register.set_Z_flag(a)
    cpu.register.set_H_flag(0)
    cpu.register['PC'] += 1
    cpu.clock.t += 4

  #Bit flip A register
  CPL: (cpu) ->
    cpu.register['A'] ^= 0xff
    cpu.register.set_N_flag(1)
    cpu.register.set_H_flag(1)
    cpu.register['PC'] += 1
    cpu.clock.t += 4

  #Flip C flag
  CCF: (cpu) ->
    cpu.set_C_flag(!cpu.C_flag())
    cpu.set_H_flag(0)
    cpu.set_N_flag(0)
    cpu.register['PC'] += 1
    cpu.clock.t += 4

  #Set carry flag
  SFC: (cpu) ->
    cpu.set_C_flag(1)
    cpu.set_H_flag(0)
    cpu.set_N_flag(0)
    cpu.register['PC'] += 1
    cpu.clock.t += 4

  #CB
  #Rotate r left, copy bit 7 to C and bit 0
  RLCr: (cpu, r) ->
    a = cpu.register[r]
    c = a >> 7 #0 or 1
    a = ((a << 1) | c) & 0xff
    cpu.register[r] = a
    cpu.register.set_Z_flag(0)
    cpu.register.set_N_flag(0)
    cpu.register.set_H_flag(0)
    cpu.register.set_C_flag(c)
    cpu.register['PC'] += 1
    cpu.clock.t += 4

  #CB
  #Rotate r left, copy bit 7 to C and bit 0
  RLCHLm: (cpu) ->
    loc = cpu.register.readHL()
    a = cpu.MMU.read8(loc)
    c = a >> 7 #0 or 1
    a = ((a << 1) | c) & 0xff
    cpu.MMU.write8(loc, a)
    cpu.register.set_Z_flag(0)
    cpu.register.set_N_flag(0)
    cpu.register.set_H_flag(0)
    cpu.register.set_C_flag(c)
    cpu.register['PC'] += 1
    cpu.clock.t += 16

  #CB
  #Rotate r left, copy C to bit 0
  RLr: (cpu, r) ->
    a = cpu.register[r]
    c = a >> 7 #0 or 1
    a = ((a << 1) | cpu.register.C_flag()) & 0xff
    cpu.register[r] = a
    cpu.register.set_Z_flag(0)
    cpu.register.set_N_flag(0)
    cpu.register.set_H_flag(0)
    cpu.register.set_C_flag(c)
    cpu.register['PC'] += 1
    cpu.clock.t += 4

  #CB
  #Rotate r left, copy C to bit 0
  RLHLm: (cpu) ->
    loc = cpu.register.readHL()
    a = cpu.MMU.read8(loc)
    c = a >> 7 #0 or 1
    a = ((a << 1) | cpu.register.C_flag()) & 0xff
    cpu.MMU.write8(loc, a)
    cpu.register.set_Z_flag(0)
    cpu.register.set_N_flag(0)
    cpu.register.set_H_flag(0)
    cpu.register.set_C_flag(c)
    cpu.register['PC'] += 2
    cpu.clock.t += 16

  #CB
  #Rotate A right, copy bit 0 to C and bit 7
  RRCA: (cpu, r) ->
    a = cpu.register[r]
    c = a & 1 #bit 0
    a = (a >> 1) | (c << 7)
    cpu.register[r] = a
    cpu.register.set_Z_flag(0)
    cpu.register.set_N_flag(0)
    cpu.register.set_H_flag(0)
    cpu.register.set_C_flag(c)
    cpu.register['PC'] += 1
    cpu.clock.t += 4

  #CB
  #Rotate A right, copy C to bit 7, overflow to C
  RRA: (cpu, r) ->
    a = cpu.register[r]
    c = a & 1 #bit 0
    a = (a >> 1) | (cpu.register.C_flag() << 7)
    cpu.register[r] = a
    cpu.register.set_Z_flag(0)
    cpu.register.set_N_flag(0)
    cpu.register.set_H_flag(0)
    cpu.register.set_C_flag(c)
    cpu.register['PC'] += 1
    cpu.clock.t += 4

  #CB
  #Shift left into carry, LSB to 0
  SLAr: (cpu, r) ->
    a = cpu.register[r]
    c = a >> 7 #0 or 1
    a = (a << 1) & 0xff
    cpu.register[r] = a
    cpu.register.set_Z_flag(0)
    cpu.register.set_N_flag(0)
    cpu.register.set_H_flag(0)
    cpu.register.set_C_flag(c)
    cpu.register['PC'] += 2
    cpu.clock.t += 8

  #CB
  #Shift left into carry, LSB to 0
  SLAHLm: (cpu) ->
    loc = cpu.register.readHL()
    a = cpu.MMU.read8(loc)
    c = a >> 7 #0 or 1
    a = (a << 1) & 0xff
    cpu.MMU.write8(loc, a)
    cpu.register.set_Z_flag(0)
    cpu.register.set_N_flag(0)
    cpu.register.set_H_flag(0)
    cpu.register.set_C_flag(c)
    cpu.register['PC'] += 2
    cpu.clock.t += 16

  #CB
  #Shift r right into carry, MSB no change
  SRAr: (cpu, r) ->
    a = cpu.register[r]
    c = a >> 7 #0 or 1
    lsb = a & 1
    a = (a >> 1) | (c << 7)
    cpu.register[r] = a
    cpu.register.set_Z_flag(0)
    cpu.register.set_N_flag(0)
    cpu.register.set_H_flag(0)
    cpu.register.set_C_flag(lsb)
    cpu.register['PC'] += 2
    cpu.clock.t += 8

  #CB
  #Shift r right into carry, MSB no change
  SRAHLm: (cpu) ->
    loc = cpu.register.readHL()
    a = cpu.MMU.read8(loc)
    c = a >> 7 #0 or 1
    lsb = a & 1
    a = (a >> 1) | (c << 7)
    cpu.MMU.write8(loc, a)
    cpu.register.set_Z_flag(0)
    cpu.register.set_N_flag(0)
    cpu.register.set_H_flag(0)
    cpu.register.set_C_flag(lsb)
    cpu.register['PC'] += 2
    cpu.clock.t += 16

  #CB
  #Shift r right into carry, MSB=0
  SRLr: (cpu, r) ->
    a = cpu.register[r]
    lsb = a & 1
    a = (a >> 1)
    cpu.register[r] = a
    cpu.register.set_Z_flag(0)
    cpu.register.set_N_flag(0)
    cpu.register.set_H_flag(0)
    cpu.register.set_C_flag(lsb)
    cpu.register['PC'] += 2
    cpu.clock.t += 8

  #CB
  #Shift (HL) right into carry, MSB=0
  SRLHLm: (cpu) ->
    loc = cpu.register.readHL()
    a = cpu.MMU.read8(loc)
    lsb = a & 1
    a = (a >> 1)
    cpu.MMU.write8(loc, a)
    cpu.register.set_Z_flag(0)
    cpu.register.set_N_flag(0)
    cpu.register.set_H_flag(0)
    cpu.register.set_C_flag(lsb)
    cpu.register['PC'] += 2
    cpu.clock.t += 16

  #CB
  #set Z to not bit b of r
  BITbr: (cpu, b, r) ->
    a = register[r]
    bit = a & (1 << b)
    cpu.register.set_Z_flag(!bit)
    cpu.register.set_N_flag(0)
    cpu.register.set_H_flag(1)
    cpu.register['PC'] += 2
    cpu.clock.t += 8

  #CB
  #set Z to not bit b of r
  BITbHLm: (cpu, b) ->
    loc = cpu.register.readHL()
    a = cpu.MMU.read8(loc)
    bit = a & (1 << b)
    cpu.register.set_Z_flag(!bit)
    cpu.register.set_N_flag(0)
    cpu.register.set_H_flag(1)
    cpu.register['PC'] += 2
    cpu.clock.t += 16

  #CB
  #set bit b of r
  SETbr: (cpu, b, r) ->
    a = register[r]
    a |= (1 << b)
    register[r] = a
    cpu.register['PC'] += 2
    cpu.clock.t += 8

  #CB
  #set bit b of (HL)
  SETbHLm: (cpu, b) ->
    loc = cpu.register.readHL()
    a = cpu.MMU.read8(loc)
    a |= (1 << b)
    cpu.write8(loc, a)
    cpu.register['PC'] += 2
    cpu.clock.t += 16

  #CB
  #reset bit b of r
  RESbr: (cpu, b, r) ->
    a = register[r]
    a &= (0 << b)
    register[r] = a
    cpu.register['PC'] += 2
    cpu.clock.t += 8

  #CB
  #reset bit b of (HL)
  RESbHLm: (cpu, b) ->
    loc = cpu.register.readHL()
    a = cpu.MMU.read8(loc)
    a &= (0 << b)
    cpu.write8(loc, a)
    cpu.register['PC'] += 2
    cpu.clock.t += 16

  #Jump to two-byte immediate
  JPnn: (cpu) ->
    loc = cpu.MMU.read16(cpu.register['PC'] + 1)
    cpu.register['PC'] = loc
    cpu.clock.t += 12

  #Conditional jump to two-byte immediate
  JPNZnn: (cpu) ->
    if !cpu.Z_flag()
      loc = cpu.MMU.read16(cpu.register['PC'] + 1)
      cpu.register['PC'] = loc
    else
      cpu.register['PC'] += 3
    cpu.clock.t += 12

  #Conditional jump to two-byte immediate
  JPZnn: (cpu) ->
    if cpu.Z_flag()
      loc = cpu.MMU.read16(cpu.register['PC'] + 1)
      cpu.register['PC'] = loc
    else
      cpu.register['PC'] += 3
    cpu.clock.t += 12

  #Conditional jump to two-byte immediate
  JPNCnn: (cpu) ->
    if !cpu.C_flag()
      loc = cpu.MMU.read16(cpu.register['PC'] + 1)
      cpu.register['PC'] = loc
    else
      cpu.register['PC'] += 3
    cpu.clock.t += 12

  #Conditional jump to two-byte immediate
  JPCnn: (cpu) ->
    if cpu.C_flag()
      loc = cpu.MMU.read16(cpu.register['PC'] + 1)
      cpu.register['PC'] = loc
    else
      cpu.register['PC'] += 3
    cpu.clock.t += 12

  #Jump to (HL)
  JPHLm: (cpu) ->
    loc = cpu.register.readHL()
    cpu.register['PC'] = loc
    cpu.clock.t += 4

  #relative jump n
  JRn: (cpu) ->
    n = cpu.MMU.read8(cpu.register['PC'] + 1)
    n = toSigned(n)
    cpu.register['PC'] += n
    cpu.clock.t += 8

  #relative conditional jumps
  JRNZn: (cpu) ->
    if !cpu.Z_flag()
      n = cpu.MMU.read8(cpu.register['PC'] + 1)
      n = toSigned(n)
      cpu.register['PC'] += n
    else
      cpu.register['PC'] += 2
    cpu.clock.t += 8

  JRZn: (cpu) ->
    if cpu.Z_flag()
      n = cpu.MMU.read8(cpu.register['PC'] + 1)
      n = toSigned(n)
      cpu.register['PC'] += n
    else
      cpu.register['PC'] += 2
    cpu.clock.t += 8

  JRNCn: (cpu) ->
    if !cpu.C_flag()
      n = cpu.MMU.read8(cpu.register['PC'] + 1)
      n = toSigned(n)
      cpu.register['PC'] += n
    else
      cpu.register['PC'] += 2
    cpu.clock.t += 8

  JRCn: (cpu) ->
    if cpu.Z_flag()
      n = cpu.MMU.read8(cpu.register['PC'] + 1)
      n = toSigned(n)
      cpu.register['PC'] += n
    else
      cpu.register['PC'] += 2
    cpu.clock.t += 8



opcodes = [
  #00
  NOP = (cpu) ->
    cpu.register['PC'] += 1
    cpu.clock.t += 4
  LDBCnn = (cpu) ->
    helperOps.LDrrnn(cpu, 'BC')
  LDBCmA = (cpu) ->
    helperOps.LDBCr(cpu, 'A')
  INCBC = (cpu) ->
    helperOps.INCrr(cpu, 'BC')
  INCr_b = (cpu) ->
    helperOps.INCr(cpu, 'B')
  DECr_b = (cpu) ->
    helperOps.DECr(cpu, 'B')
  LDrn_b = (cpu) ->
    helperOps(cpu, 'B')
  RLCA = (cpu) ->
    helperOps.RLCr(cpu, 'A')
  LDmmSP = (cpu) ->
    helperOps.LDnnSP(cpu)
  ADDHLBC = (cpu) ->
    helperOps.ADDHLrr(cpu, 'BC')
  LDABCm = (cpu) -> ,
  DECBC = (cpu) ->
    helperOps.DECrr(cpu, 'BC')
  INCr_c = (cpu) ->
    helperOps.INCr(cpu, 'C')
  DECr_c = (cpu) ->
    helperOps.DECr(cpu, 'C')
  LDrn_c = (cpu) ->
    helperOps(cpu, 'C')
  RRCA = (cpu) ->
    helperOps.RRCr(cpu, 'A')

  #10
  DJNZn = (cpu) ->
    cpu.stopState = true
    cpu.register['PC'] += 2
    cpu.clock.t += 8
  LDDEnn = (cpu) ->
    helperOps.LDrrnn(cpu, 'DE')
  LDDEmA = (cpu) ->
    helperOps.LDDEr(cpu, 'A')
  INCDE = (cpu) ->
    helperOps.INCrr(cpu, 'DE')
  INCr_d = (cpu) ->
    helperOps.INCr(cpu, 'D')
  DECr_d = (cpu) ->
    helperOps.DECr(cpu, 'D')
  LDrn_d = (cpu) ->
    helperOps(cpu, 'D')
  RLA = (cpu) ->
    helperOps.RLr(cpu, 'A')
  JRn = (cpu) ->
    helperOps.JRn(cpu)
  ADDHLDE = (cpu) ->
    helperOps.ADDHLrr(cpu, 'DE')
  LDADEm = (cpu) -> ,
  DECDE = (cpu) ->
    helperOps.DECrr(cpu, 'DE')
  INCr_e = (cpu) ->
    helperOps.INCr(cpu, 'E')
  DECr_e = (cpu) ->
    helperOps.DECr(cpu, 'E')
  LDrn_e = (cpu) ->
    helperOps(cpu, 'E')
  RRA = (cpu) ->
    helperOps.RRr(cpu, 'A')

  #20
  JRNZn = (cpu) ->
    helperOps.JRNZn(cpu)
  LDHLnn = (cpu) ->
    helperOps.LDrrnn(cpu, 'HL')
  LDHLIA = (cpu) ->
    helperOps.LDHLmAI(cpu)
  INCHL = (cpu) ->
    helperOps.INCrr(cpu, 'HL')
  INCr_h = (cpu) ->
    helperOps.INCr(cpu, 'H')
  DECr_h = (cpu) ->
    helperOps.DECr(cpu, 'H')
  LDrn_h = (cpu) ->
    helperOps(cpu, 'H')
  DAA = (cpu) ->
    helperOps.DAA(cpu)
  JRZn = (cpu) ->
    helperOps.JRZn(cpu)
  ADDHLHL = (cpu) ->
    helperOps.ADDHLrr(cpu, 'HL')
  LDAHLI = (cpu) ->
    helperOps.LDAHLmI(cpu)
  DECHL = (cpu) ->
    helperOps.DECrr(cpu, 'HL')
  INCr_l = (cpu) -> ,
  DECr_l = (cpu) -> ,
  LDrn_l = (cpu) ->
    helperOps(cpu, 'E')
  CPL = (cpu) ->
    helperOps.CPL(cpu)

  # 30
  JRNCn = (cpu) ->
    helperOps.JRNCn(cpu)
  LDSPnn = (cpu) ->
    helperOps.LDrrnn(cpu, 'SP')
  LDHLDA = (cpu) ->
    helperOps.LDHLmAD(cpu)
  INCSP = (cpu) ->
    helperOps.INCrr(cpu, 'SP')
  INCHLm = (cpu) ->
    helperOps.INCHLm(cpu)
  DECHLm = (cpu) ->
    helperOps.DECHLm(cpu)
  LDHLn = (cpu) ->
    helperOps.LDHLn(cpu)
  SCF = (cpu) ->
    helperOps.SCF(cpu)
  JRCn = (cpu) ->
    helperOps.JRCn(cpu)
  ADDHLSP = (cpu) ->
    helperOps.ADDHLrr(cpu, 'SP')
  LDAHLD = (cpu) ->
    helperOps.LDAHLmD(cpu)
  DECSP = (cpu) ->
    helperOps.DECrr(cpu, 'SP')
  INCr_a = (cpu) ->
    helperOps.INCr(cpu, 'A')
  DECr_a = (cpu) ->
    helperOps.DECr(cpu, 'A')
  LDrn_a = (cpu) -> ,
  CCF = (cpu) ->
    helperOps.CCF(cpu)

  # 40
  LDrr_bb = (cpu) ->
    helperOps.LDrr(cpu, 'B', 'B')
  LDrr_bc = (cpu) ->
    helperOps.LDrr(cpu, 'B', 'C')
  LDrr_bd = (cpu) ->
    helperOps.LDrr(cpu, 'B', 'D')
  LDrr_be = (cpu) ->
    helperOps.LDrr(cpu, 'B', 'E')
  LDrr_bh = (cpu) ->
    helperOps.LDrr(cpu, 'B', 'H')
  LDrr_bl = (cpu) ->
    helperOps.LDrr(cpu, 'B', 'L')
  LDrHLm_b = (cpu) ->
    helperOps.LDrHL(cpu, 'B')
  LDrr_ba = (cpu) ->
    helperOps.LDrr(cpu, 'B', 'A')
  LDrr_cb = (cpu) ->
    helperOps.LDrr(cpu, 'C', 'B')
  LDrr_cc = (cpu) ->
    helperOps.LDrr(cpu, 'C', 'C')
  LDrr_cd = (cpu) ->
    helperOps.LDrr(cpu, 'C', 'D')
  LDrr_ce = (cpu) ->
    helperOps.LDrr(cpu, 'C', 'E')
  LDrr_ch = (cpu) ->
    helperOps.LDrr(cpu, 'C', 'H')
  LDrr_cl = (cpu) ->
    helperOps.LDrr(cpu, 'C', 'L')
  LDrHLm_c = (cpu) ->
    helperOps.LDrHL(cpu, 'C')
  LDrr_ca = (cpu) ->
    helperOps.LDrr(cpu, 'C', 'A')

  # 50
  LDrr_db = (cpu) ->
    helperOps.LDrr(cpu, 'D', 'B')
  LDrr_dc = (cpu) ->
    helperOps.LDrr(cpu, 'D', 'C')
  LDrr_dd = (cpu) ->
    helperOps.LDrr(cpu, 'D', 'D')
  LDrr_de = (cpu) ->
    helperOps.LDrr(cpu, 'D', 'E')
  LDrr_dh = (cpu) ->
    helperOps.LDrr(cpu, 'D', 'H')
  LDrr_dl = (cpu) ->
    helperOps.LDrr(cpu, 'D', 'L')
  LDrHLm_d = (cpu) ->
    helperOps.LDrHL(cpu, 'D')
  LDrr_da = (cpu) ->
    helperOps.LDrr(cpu, 'D', 'A')
  LDrr_eb = (cpu) ->
    helperOps.LDrr(cpu, 'E', 'B')
  LDrr_ec = (cpu) ->
    helperOps.LDrr(cpu, 'E', 'C')
  LDrr_ed = (cpu) ->
    helperOps.LDrr(cpu, 'E', 'D')
  LDrr_ee = (cpu) ->
    helperOps.LDrr(cpu, 'E', 'E')
  LDrr_eh = (cpu) ->
    helperOps.LDrr(cpu, 'E', 'H')
  LDrr_el = (cpu) ->
    helperOps.LDrr(cpu, 'E', 'L')
  LDrHLm_e = (cpu) ->
    helperOps.LDrHL(cpu, 'E')
  LDrr_ea = (cpu) ->
    helperOps.LDrr(cpu, 'E', 'A')

  # 60
  LDrr_hb = (cpu) ->
    helperOps.LDrr(cpu, 'H', 'B')
  LDrr_hc = (cpu) ->
    helperOps.LDrr(cpu, 'H', 'C')
  LDrr_hd = (cpu) ->
    helperOps.LDrr(cpu, 'H', 'D')
  LDrr_he = (cpu) ->
    helperOps.LDrr(cpu, 'H', 'E')
  LDrr_hh = (cpu) ->
    helperOps.LDrr(cpu, 'H', 'H')
  LDrr_hl = (cpu) ->
    helperOps.LDrr(cpu, 'H', 'L')
  LDrHLm_h = (cpu) ->
    helperOps.LDrHL(cpu, 'H')
  LDrr_ha = (cpu) ->
    helperOps.LDrr(cpu, 'H', 'A')
  LDrr_lb = (cpu) ->
    helperOps.LDrr(cpu, 'L', 'B')
  LDrr_lc = (cpu) ->
    helperOps.LDrr(cpu, 'L', 'C')
  LDrr_ld = (cpu) ->
    helperOps.LDrr(cpu, 'L', 'D')
  LDrr_le = (cpu) ->
    helperOps.LDrr(cpu, 'L', 'E')
  LDrr_lh = (cpu) ->
    helperOps.LDrr(cpu, 'L', 'H')
  LDrr_ll = (cpu) ->
    helperOps.LDrr(cpu, 'L', 'L')
  LDrHLm_l = (cpu) ->
    helperOps.LDrHL(cpu, 'L')
  LDrr_la = (cpu) ->
    helperOps.LDrr(cpu, 'L', 'A')

  # 70
  LDHLmr_b = (cpu) ->
    helperOps.LDHLr(cpu, 'B')
  LDHLmr_c = (cpu) ->
    helperOps.LDHLr(cpu, 'C')
  LDHLmr_d = (cpu) ->
    helperOps.LDHLr(cpu, 'D')
  LDHLmr_e = (cpu) ->
    helperOps.LDHLr(cpu, 'E')
  LDHLmr_h = (cpu) ->
    helperOps.LDHLr(cpu, 'H')
  LDHLmr_l = (cpu) ->
    helperOps.LDHLr(cpu, 'L')
  HALT = (cpu) -> ,
  LDHLmr_a = (cpu) ->
    helperOps.LDHLr(cpu, 'A')
  LDrr_ab = (cpu) ->
    helperOps.LDrr(cpu, 'A', 'B')
  LDrr_ac = (cpu) ->
    helperOps.LDrr(cpu, 'A', 'C')
  LDrr_ad = (cpu) ->
    helperOps.LDrr(cpu, 'A', 'D')
  LDrr_ae = (cpu) ->
    helperOps.LDrr(cpu, 'A', 'E')
  LDrr_ah = (cpu) ->
    helperOps.LDrr(cpu, 'A', 'H')
  LDrr_al = (cpu) ->
    helperOps.LDrr(cpu, 'A', 'L')
  LDrHLm_a = (cpu) ->
    helperOps.LDrHL(cpu, 'A')
  LDrr_aa = (cpu) ->
    helperOps.LDrr(cpu,'A', 'A')

  # 80
  ADDr_b = (cpu) ->
    helperOps.ADD(cpu, 'B')
  ADDr_c = (cpu) ->
    helperOps.ADD(cpu, 'C')
  ADDr_d = (cpu) ->
    helperOps.ADD(cpu, 'D')
  ADDr_e = (cpu) ->
    helperOps.ADD(cpu, 'E')
  ADDr_h = (cpu) ->
    helperOps.ADD(cpu, 'H')
  ADDr_l = (cpu) ->
    helperOps.ADD(cpu, 'L')
  ADDHL = (cpu) ->
    helperOps.ADDHLm(cpu)
  ADDr_a = (cpu) ->
    helperOps.ADD(cpu, 'A')
  ADCr_b = (cpu) -> ,
  ADCr_c = (cpu) -> ,
  ADCr_d = (cpu) -> ,
  ADCr_e = (cpu) -> ,
  ADCr_h = (cpu) -> ,
  ADCr_l = (cpu) -> ,
  ADCHL = (cpu) -> ,
  ADCr_a = (cpu) -> ,

  # 90
  SUBr_b = (cpu) -> ,
  SUBr_c = (cpu) -> ,
  SUBr_d = (cpu) -> ,
  SUBr_e = (cpu) -> ,
  SUBr_h = (cpu) -> ,
  SUBr_l = (cpu) -> ,
  SUBHL = (cpu) -> ,
  SUBr_a = (cpu) -> ,
  SBCr_b = (cpu) -> ,
  SBCr_c = (cpu) -> ,
  SBCr_d = (cpu) -> ,
  SBCr_e = (cpu) -> ,
  SBCr_h = (cpu) -> ,
  SBCr_l = (cpu) -> ,
  SBCHL = (cpu) -> ,
  SBCr_a = (cpu) -> ,

  # A0
  ANDr_b = (cpu) -> ,
  ANDr_c = (cpu) -> ,
  ANDr_d = (cpu) -> ,
  ANDr_e = (cpu) -> ,
  ANDr_h = (cpu) -> ,
  ANDr_l = (cpu) -> ,
  ANDHL = (cpu) -> ,
  ANDr_a = (cpu) -> ,
  XORr_b = (cpu) -> ,
  XORr_c = (cpu) -> ,
  XORr_d = (cpu) -> ,
  XORr_e = (cpu) -> ,
  XORr_h = (cpu) -> ,
  XORr_l = (cpu) -> ,
  XORHL = (cpu) -> ,
  XORr_a = (cpu) -> ,

  # B0
  ORr_b = (cpu) -> ,
  ORr_c = (cpu) -> ,
  ORr_d = (cpu) -> ,
  ORr_e = (cpu) -> ,
  ORr_h = (cpu) -> ,
  ORr_l = (cpu) -> ,
  ORHL = (cpu) -> ,
  ORr_a = (cpu) -> ,
  CPr_b = (cpu) -> ,
  CPr_c = (cpu) -> ,
  CPr_d = (cpu) -> ,
  CPr_e = (cpu) -> ,
  CPr_h = (cpu) -> ,
  CPr_l = (cpu) -> ,
  CPHL = (cpu) -> ,
  CPr_a = (cpu) -> ,

  # C0
  RETNZ = (cpu) -> ,
  POPBC = (cpu) ->
    helperOps.POP(cpu, 'BC')
  JPNZnn = (cpu) ->
    helperOps.JPNZnn(cpu)
  JPnn = (cpu) ->
    helperOps.JPnn(cpu)
  CALLNZnn = (cpu) -> ,
  PUSHBC = (cpu) ->
    helperOps.PUSH(cpu, 'BC')
  ADDn = (cpu) ->
    helperOps.ADDn(cpu)
  RST00 = (cpu) -> ,
  RETZ = (cpu) -> ,
  RET = (cpu) -> ,
  JPZnn = (cpu) ->
    helperOps.JPZnn(cpu)
  MAPcb = (cpu) -> ,
  CALLZnn = (cpu) -> ,
  CALLnn = (cpu) -> ,
  ADCn = (cpu) -> ,
  RST08 = (cpu) -> ,

  # D0
  RETNC = (cpu) -> ,
  POPDE = (cpu) ->
    helperOps.POP(cpu, 'DE')
  JPNCnn = (cpu) ->
    helperOps.JPNCnn(cpu)
  XX = (cpu) -> ,
  CALLNCnn = (cpu) -> ,
  PUSHDE = (cpu) ->
    helperOps.PUSH(cpu, 'DE')
  SUBn = (cpu) -> ,
  RST10 = (cpu) -> ,
  RETC = (cpu) -> ,
  RETI = (cpu) -> ,
  JPCnn = (cpu) ->
    helperOps.JPNCnn(cpu)
  XX = (cpu) -> ,
  CALLCnn = (cpu) -> ,
  XX = (cpu) -> ,
  SBCn = (cpu) -> ,
  RST18 = (cpu) -> ,

  # E0
  LDIOnA = (cpu) ->
    helperOps.LDHNa(cpu)
  POPHL = (cpu) ->
    helperOps.POP(cpu, 'HL')
  LDIOCA = (cpu) ->
    helperOps.LDCA(cpu)
  XX = (cpu) -> ,
  XX = (cpu) -> ,
  PUSHHL = (cpu) ->
    helperOps.PUSH(cpu, 'HL')
  ANDn = (cpu) -> ,
  RST20 = (cpu) -> ,
  ADDSPn = (cpu) ->
    helperOps.ADDSPn(cpu)
  JPHL = (cpu) ->
    helperOps.JPHLm(cpu)
  LDmmA = (cpu) -> ,
  XX = (cpu) -> ,
  XX = (cpu) -> ,
  XX = (cpu) -> ,
  ORn = (cpu) -> ,
  RST28 = (cpu) -> ,

  # F0
  LDAIOn = (cpu) ->
    helperOps.LDHAn(cpu)
  POPAF = (cpu) ->
    cpu.POP(cpu, 'AF')
  LDAIOC = (cpu) ->
    helperOps.LDAC(cpu)
  DI = (cpu) ->
    cpu.interruptsEnabled = false
    cpu.register['PC'] += 1
    cpu.clock.t += 4
  XX = (cpu) -> ,
  PUSHAF = (cpu) ->
    helperOps.PUSH(cpu, 'AF')
  XORn = (cpu) -> ,
  RST30 = (cpu) -> ,
  LDHLSPn = (cpu) ->
    helperOps.LDHLSPn(cpu)
  LDSPHL = (cpu) ->
    helperOps.LDSPHL(cpu)
  LDAmm = (cpu) -> ,
  EI = (cpu) ->
    cpu.interruptsEnabled = true
    cpu.register['PC'] += 1
    cpu.clock.t += 4
  XX = (cpu) -> ,
  XX = (cpu) -> ,
  CPn = (cpu) -> ,
  RST38= (cpu) ->
]
