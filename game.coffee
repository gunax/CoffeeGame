fs = require 'fs'

game = fs.readFileSync('rom/Tetris.gb', 'hex')

console.log(game)
