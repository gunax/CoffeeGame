class gameboy
  constructor: () ->
    @cpu = new CPU
    @screen = new screen

  step: () =>
    op = @cpu.MMU.read8(@cpu.register.PC)
    opcodes[op](@cpu)
    @refreshDebug()

  refreshDebug: () ->
    AF = numFormat(@cpu.register.readAF())
    BC = numFormat(@cpu.register.readBC())
    DE = numFormat(@cpu.register.readDE())
    HL = numFormat(@cpu.register.readHL())
    SP = numFormat(@cpu.register.SP)
    PC = numFormat(@cpu.register.PC)
    document.getElementById('AF_reg').innerHTML = AF
    document.getElementById('BC_reg').innerHTML = BC
    document.getElementById('DE_reg').innerHTML = DE
    document.getElementById('HL_reg').innerHTML = HL
    document.getElementById('SP_reg').innerHTML = SP
    document.getElementById('PC_reg').innerHTML = PC
    #flags
    document.getElementById('Z_flag').innerHTML = @cpu.register.Z_flag()
    document.getElementById('N_flag').innerHTML = @cpu.register.N_flag()
    document.getElementById('H_flag').innerHTML = @cpu.register.H_flag()
    document.getElementById('C_flag').innerHTML = @cpu.register.C_flag()


gb = new gameboy

numFormat = (num) ->
  pad = '0000'+num.toString(16)
  (pad.slice -4).toUpperCase()

onLoad = () ->
  button = document.getElementById 'stepButton'
  button.addEventListener 'click', gb.step
  gb.refreshDebug()

document.addEventListener 'DOMContentLoaded', onLoad
