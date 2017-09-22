MAXCYCLES = 69905

class screen
  constructor: ()->
    @cycle_counter = 0

  @step = () ->
    console.log('stepped')

  #render screen every time cycle_counter >= MAXCYCLES
  render = () ->
    if cycle_counter >= MAXCYCLES
      cycle_counter -= MAXCYCLES
      #TODO: render screen
