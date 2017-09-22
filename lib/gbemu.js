// Generated by CoffeeScript 1.12.7
(function() {
  var MAXCYCLES, MMU, clock, cycle_counter, register, render, reset;

  MAXCYCLES = 69905;

  cycle_counter = 0;

  this.step = function() {
    return console.log('stepped');
  };

  render = function() {
    if (cycle_counter >= MAXCYCLES) {
      return cycle_counter -= MAXCYCLES;
    }
  };

  clock = {
    m: 0,
    t: 0
  };

  register = {
    A: 0,
    B: 0,
    C: 0,
    D: 0,
    E: 0,
    F: 0,
    H: 0,
    L: 0,
    SP: 0,
    PC: 0
  };

  MMU = {
    read8: function(addr) {},
    read16: function(addr) {},
    write8: function(addr, value) {},
    write16: function(addr, value) {}
  };

  reset = function() {
    return register.A = register.B = register.C = register.D = register.E = register.F = register.H = register.L = register.SP = register.PC = 0;
  };

  console.log(screen.MAXCYCLES);

  reset();

  console.log(register.A);

}).call(this);