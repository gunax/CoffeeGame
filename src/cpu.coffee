class register
  #8 8-bit registers, 2 16-bit registers SP and PC
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

class clock
  m: 0
  t: 0

class MMU
  constructor: (reg) ->
    @reg = reg
  @_inbios: true
  @_bios: []
  @_rom: []
  @_wram: []
  @_eram: []
  @_zram: []

  read8: (addr, value = 0, toWrite = false) ->
    #ROM or 256-byte bios
    if 0 <= addr < 0x8000
      if addr < 0x0100 and @_inbios
        return @_bios[addr]
      else if @reg.PC == 0x0100
        @_inbios = false
        return @_rom[addr]

    #VRAM
    else if 0x8000 <= addr < 0xA000
      #TODO: return screen VRAM
      return 0

    #external RAM
    else if 0xA000 <= addr < 0xC000
      return @_wram[addr & 0x1fff]

    #working RAM
    else if 0xC000 <= addr < 0xFE00
      return @_wram[addr & 0x1fff]

    #Graphics memory
    else if 0xFE00 <= addr < 0xFF00
      if addr < 0xFEA0
        #TODO: return screen mem
        return 0
      else
        return 0

    #zero page
    else if 0xFF00 <= addr < 0xFF80
      return @_zram[addr & 0x7f]

    #IO mapped
    else if 0xFF80 <= addr < 0xFFFF
      return 0 #TODO: implement IO mapped ram

    else
      console.log("tried to access out of bounds memory")
      return 0

  read16: (addr) ->
    return @read8(addr) + (@read8(addr) << 8)

  write8: (addr, value) ->
    #TODO = implement
  write16: (addr, value) ->
    #TODO = implement

window.CPU = class CPU
  constructor: () ->
    @register = new register
    @clock = new clock
    @MMU = new MMU(@register)
  resetcpu: ()  =>
    @register.A = @register.B = @register.C = @register.D =
    @register.E = @register.F = @register.H = @register.L =
    @register.SP = @register.PC = 0
