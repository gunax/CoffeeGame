class gameboy
  constructor: () ->
    @cpu = new CPU
    @screen = new screen

  step: () =>
    op = @cpu.MMU.read8(@cpu.register.PC)
    opcodes[op](@cpu)
    @refreshDebug()

  refreshDebug: () ->
    document.getElementById('A_reg').innerHTML = @cpu.register.A.toString(16)
    document.getElementById('B_reg').innerHTML = @cpu.register.B.toString(16)
    document.getElementById('C_reg').innerHTML = @cpu.register.C.toString(16)
    document.getElementById('D_reg').innerHTML = @cpu.register.D.toString(16)
    document.getElementById('E_reg').innerHTML = @cpu.register.E.toString(16)
    document.getElementById('F_reg').innerHTML = @cpu.register.F.toString(16)
    document.getElementById('H_reg').innerHTML = @cpu.register.H.toString(16)
    document.getElementById('L_reg').innerHTML = @cpu.register.L.toString(16)
    document.getElementById('SP_reg').innerHTML = @cpu.register.SP.toString(16)
    document.getElementById('PC_reg').innerHTML = @cpu.register.PC.toString(16)
    #flags
    document.getElementById('Z_flag').innerHTML = @cpu.register.flag.Z
    document.getElementById('H_flag').innerHTML = @cpu.register.flag.H
    document.getElementById('C_flag').innerHTML = @cpu.register.flag.C
    document.getElementById('N_flag').innerHTML = @cpu.register.flag.N


gb = new gameboy

onLoad = () ->
  button = document.getElementById 'stepButton'
  button.addEventListener 'click', gb.step
  gb.refreshDebug()

document.addEventListener 'DOMContentLoaded', onLoad
