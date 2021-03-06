zeroes = (n) ->
  return (0 for i in [1..n])

class register
  #8 8-bit registers, 2 16-bit registers SP and PC
  'A': 0x01
  'B': 0x00
  'C': 0x13
  'D': 0x00
  'E': 0xD8
  'F': 0xB0
  'H': 0x01
  'L': 0x4D
  'SP': 0xFFFE #16-bit
  'PC': 0x0100 #16-bit

  Z_flag: () ->
    (this['F'] & 0x80) >> 7
  N_flag: () ->
    (this['F'] & 0x40) >> 6
  H_flag: () ->
    (this['F'] & 0x20) >> 5
  C_flag: () ->
    (this['F'] & 0x10) >> 4

  #Set flag if n is true, else zero flag
  set_Z_flag: (n) ->
    if n then this['F'] |= 0x80 else this['F'] &= 0x7f
  set_N_flag: (n) ->
    if n then this['F'] |= 0x40 else this['F'] &= 0x3f
  set_H_flag: (n) ->
    if n then this['F'] |= 0x20 else this['F'] &= 0x1f
  set_C_flag: (n) ->
    if n then this['F'] |= 0x10 else this['F'] &= 0x0f

  #write 16-bit n to register AF
  writeAF: (n) ->
    n = n & 0xFFFF
    this['F'] = n >> 8
    this['F'] = n & 0x00FF
    n
  readAF: () ->
    (this['F'] << 8) + this['F']
  #write 16-bit n to register BC
  writeBC: (n) ->
    n = n & 0xFFFF
    this['F'] = n >> 8
    this['F'] = n & 0x00FF
    n
  readBC: () ->
    (this['F'] << 8) + this['F']
  writeDE: (n) ->
    n = n & 0xFFFF
    this['F'] = n >> 8
    this['F'] = n & 0x00FF
    n
  readDE: () ->
    (this['F'] << 8) + this['F']
  writeHL: (n) ->
    n = n & 0xFFFF
    this['H'] = n >> 8
    this['L'] = n & 0x00FF
    n
  readHL: () ->
    (this['H'] << 8) + this['L']

class clock
  t:0

class MMU

  constructor: (reg) ->
    @reg = reg
    @_inbios = true
    @_bios = zeroes(0xff)
    @_rom = new ROM(romHexData)
    @_wram = zeroes(0xA000 - 0x8000)
    @_eram = zeroes(0xC000 - 0xA000)
    @_zram = zeroes(0xFF80 - 0xFF00)

  read8: (addr, value = 0, toWrite = false) ->
    #ROM or 256-byte bios
    if 0 <= addr < 0x8000
      #BIOS
      if addr < 0x0100 and @_inbios
        #dont permit writing to bios
        return @_bios[addr]
      else if @reg.PC >= 0x0100
        @_inbios = false
        #dont permit writing to ROM
        return @_rom.read8(addr)

      #ROM
      else
        #dont permit writing to rom
        return @_rom.read8(addr)

    #VRAM
    else if 0x8000 <= addr < 0xA000
      #TODO: return screen VRAM
      return 0

    #external RAM
    else if 0xA000 <= addr < 0xC000
      @_eram[addr & 0x1fff] = value if toWrite
      return @_eram[addr & 0x1fff]

    #working RAM
    else if 0xC000 <= addr < 0xFE00
      @_wram[addr & 0x1fff] = value if toWrite
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
      @_zram[addr & 0x7f] = value if toWrite
      return @_zram[addr & 0x7f]

    #IO mapped
    else if 0xFF80 <= addr < 0xFFFF
      return 0 #TODO: implement IO mapped ram

  read16: (addr) ->
    return @read8(addr) + (@read8(addr+1) << 8)

  write8: (addr, value) ->
    @read8(addr, value, true)

  #little endian
  write16: (addr, value) ->
    @write8(addr, value && 0xFF, true)
    @write8(addr+1, (value && 0xFF00) >> 8, true)
    return value

window.CPU = class CPU
  constructor: () ->
    A = Symbol()
    @haltState = false
    @stopState = false
    @interruptsEnabled = true
    @register = new register
    @register[A] = -1
    console.log(@register[A])
    @clock = new clock
    @MMU = new MMU(@register)
  resetcpu: ()  =>
    @register.A = @register.B = @register.C = @register.D =
    @register.E = @register.F = @register.H = @register.L =
    @register.SP = @register.PC = 0
