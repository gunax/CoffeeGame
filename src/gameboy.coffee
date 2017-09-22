class gameboy
  constructor: () ->
    @cpu = new CPU
    @rom = new ROM romHexData
    @screen = new screen
  step: () =>
    op = @rom.read(@cpu.register.PC)
    @cpu.register.PC++
    console.log(op)

gb = new gameboy

onLoad = () ->
  button = document.getElementById 'stepButton'
  button.addEventListener 'click', gb.step

document.addEventListener 'DOMContentLoaded', onLoad
