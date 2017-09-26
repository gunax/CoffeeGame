describe 'MMU', ->
  cpu = null

  beforeEach ->
    cpu = new CPU

  it 'can read bios', ->
    cpu.MMU._bios[1] = 15
    expect(cpu.MMU.read8(0)).toBe 0
    expect(cpu.MMU.read8(1)).toBe 15

  it 'can not write bios', ->
    cpu.MMU.write8(0xb2, 5)
    expect(cpu.MMU.read8(0xb2)).toBe 0

  it 'can read ROM', ->
    expect(cpu.MMU._rom.read16(0)).toBe 0xc3
    expect(cpu.MMU._rom.read16(2)).toBe 0x0c

  it 'can not write rom', ->
    cpu.MMU.write8(0x4fff, 5)
    expect(cpu.MMU.read8(0x100)).toBe 12

  it 'can read VRAM', ->
    #TODO

  it 'can read eram', ->
    expect(cpu.MMU.read8(0xA005)).toBe 0
    cpu.MMU._eram[5] = 19
    expect(cpu.MMU.read8(0xA005)).toBe 19

  it 'can write eram', ->
    cpu.MMU.write8(0xAD05, 5)
    expect(cpu.MMU.read8(0xAD05)).toBe 5

  it 'can read wram', ->
    expect(cpu.MMU.read8(0xC005)).toBe 0
    cpu.MMU._wram[5] = 19
    expect(cpu.MMU.read8(0xC005)).toBe 19

  it 'can write wram', ->
    cpu.MMU.write8(0xD001, 5)
    expect(cpu.MMU.read8(0xD001)).toBe 5

  it 'can read graphics RAM', ->
    #TODO

  it 'can read zram', ->
    expect(cpu.MMU.read8(0xFF15)).toBe 0
    cpu.MMU._zram[0x15] = 19
    expect(cpu.MMU.read8(0xFF15)).toBe 19

  it 'can write zram', ->
    cpu.MMU.write8(0xFF15, 5)
    expect(cpu.MMU.read8(0xFF15)).toBe 5
    expect(cpu.MMU._zram[0x15]).toBe 5
