require 'pp'

class Game
  attr_accessor :cells, :width
  def initialize
    self.cells = []
  end

  def load_seed(path)
    File.open(path, 'r') do |f|
      self.width = f.gets.to_i

      while row = f.gets
        self.cells += row.chomp.split('').map { |x| x == 'l' ? x : nil}
      end
    end
  end

  def evolve
    new_cells = []

    self.cells.each_with_index do |cell_value, index|
      live_neighbor_count = live_neighbor_count(index)

      # 1) Any live cell with fewer than two live neighbours dies, as if
      # caused by under-population.
      if live_neighbor_count < 2
        new_cells << nil

      # 2) Any live cell with two or three live neighbours lives on to the
      # next generation.
      elsif cell_value == "l" and live_neighbor_count.between?(2, 3)
        new_cells << "l"

      # 3) Any live cell with more than three live neighbours dies, as if
      # by overcrowding.
      elsif cell_value == "l" and live_neighbor_count > 3
        new_cells << nil

      # 4) Any dead cell with exactly three live neighbours becomes a live
      # cell, as if by reproduction.
      elsif cell_value.nil? and live_neighbor_count == 3
        new_cells << "l"

      else
        new_cells << self.cells[index]
      end
    end

    self.cells = new_cells
  end

  def neighbors(index)
    neighbor_indicies = []
    neighbor_indicies << index - self.width # north
    neighbor_indicies << index + self.width # south
    east = index + 1 unless index % self.width == self.width - 1
    west = index - 1 unless index % self.width == 0
    if east
      neighbor_indicies << east
      neighbor_indicies << east - self.width # north-east
      neighbor_indicies << east + self.width # south-east
    end
    if west
      neighbor_indicies << west
      neighbor_indicies << west - self.width # north-west
      neighbor_indicies << west + self.width # south-west
    end


    neighbor_indicies.uniq!
    neighbor_indicies.reject! { |i| i < 0 or i >= self.cells.length }
    neighbor_indicies
  end

  def live_neighbor_count(index)
    neighbors(index).select { |index| self.cells[index] == "l" }.length
  end

  def run(num_generations)
    num_generations.times do
      evolve
    end
  end

  def to_s
    string = ""

    self.cells.each_slice(self.width) do |cell_row|
      cell_row.each do |cell|
        string << "0" if cell == "l"
        string << "." if !cell
      end
      string << "\n"
    end

    string
  end
end
