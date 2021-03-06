// Generated by CoffeeScript 1.12.7
(function() {
  describe('MMU', function() {
    var cpu;
    cpu = null;
    beforeEach(function() {
      return cpu = new CPU;
    });
    it('can read bios', function() {
      cpu.MMU._bios[1] = 15;
      expect(cpu.MMU.read8(0)).toBe(0);
      return expect(cpu.MMU.read8(1)).toBe(15);
    });
    it('can not write bios', function() {
      cpu.MMU.write8(0xb2, 5);
      return expect(cpu.MMU.read8(0xb2)).toBe(0);
    });
    it('can read ROM', function() {
      expect(cpu.MMU._rom.read16(0)).toBe(0xc3);
      return expect(cpu.MMU._rom.read16(2)).toBe(0x0c);
    });
    it('can not write rom', function() {
      cpu.MMU.write8(0x4fff, 5);
      return expect(cpu.MMU.read8(0x100)).toBe(12);
    });
    it('can read VRAM', function() {});
    it('can read eram', function() {
      expect(cpu.MMU.read8(0xA005)).toBe(0);
      cpu.MMU._eram[5] = 19;
      return expect(cpu.MMU.read8(0xA005)).toBe(19);
    });
    it('can write eram', function() {
      cpu.MMU.write8(0xAD05, 5);
      return expect(cpu.MMU.read8(0xAD05)).toBe(5);
    });
    it('can read wram', function() {
      expect(cpu.MMU.read8(0xC005)).toBe(0);
      cpu.MMU._wram[5] = 19;
      return expect(cpu.MMU.read8(0xC005)).toBe(19);
    });
    it('can write wram', function() {
      cpu.MMU.write8(0xD001, 5);
      return expect(cpu.MMU.read8(0xD001)).toBe(5);
    });
    it('can read graphics RAM', function() {});
    it('can read zram', function() {
      expect(cpu.MMU.read8(0xFF15)).toBe(0);
      cpu.MMU._zram[0x15] = 19;
      return expect(cpu.MMU.read8(0xFF15)).toBe(19);
    });
    return it('can write zram', function() {
      cpu.MMU.write8(0xFF15, 5);
      expect(cpu.MMU.read8(0xFF15)).toBe(5);
      return expect(cpu.MMU._zram[0x15]).toBe(5);
    });
  });

}).call(this);
