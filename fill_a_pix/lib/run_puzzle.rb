require 'puzzle'
require 'pp'

puzzle_path = ARGV[0]

puzzle = Puzzle.new
puzzle.load_puzzle(puzzle_path)
puzzle.solve
# puts puzzle
