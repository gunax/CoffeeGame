class gameboy
  constructor: () ->
    @cpu = new CPU
    @screen = new screen
  step: () =>
    op = @cpu.MMU.read8(@cpu.register.PC)
    opcodes[op](@cpu)
    console.log(@cpu.register.PC)

gb = new gameboy

onLoad = () ->
  button = document.getElementById 'stepButton'
  button.addEventListener 'click', gb.step

document.addEventListener 'DOMContentLoaded', onLoad
