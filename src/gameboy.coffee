class gameboy
  constructor: () ->
    @cpu = new CPU
    @rom = new ROM
    @screen = new screen
