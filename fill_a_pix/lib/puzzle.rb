# -*- coding: utf-8 -*-
require 'cell'

class Puzzle
  attr_accessor :grid, :width, :height

  DEBUG = true

  def load_puzzle(filename)
    grid = []

    File.open(filename, 'r') do |f|
      self.width, self.height = f.gets.split(',').map { |x| x.to_i }

      total = self.width * self.height

      while row = f.gets
        row.chomp.split(/\s+/).each do |square|
          c = Cell.new
          if square =~ /^\d$/ then
            c.clue = square.to_i
          end
          grid << c
          total -= 1
          break if total == 0
        end
      end
    end
    self.grid = grid
    add_neighbors
  end

  def add_neighbors
    self.grid.each_with_index do |cell, index|
      cell.neighbors = neighbors_for_index(index).map { |i| self.grid[i] }
    end
  end

  def neighbors_for_index(index)
    methods = [:north_of_index,
               :south_of_index,
               :west_of_index,
               :east_of_index,
               :ne_of_index,
               :nw_of_index,
               :se_of_index,
               :sw_of_index]
    neighbors = []
    methods.each do |method|
      n = self.send(method, index)
      neighbors << n if n
    end
    neighbors
  end

  def solve
    i = 1
    until self.grid.all? { |c| c.done? }
      prev = self.to_s

      self.grid.each_with_index do |cell, index|
        changed = cell.fill_in
      end
      i += 1
      if self.to_s == prev
        puts "Not making forward progress"
        return
      elsif DEBUG
        puts "Iteration #{i}"
        puts self.to_s
      end
    end
    puts self.to_s
  end

  def to_s
    string = ""
    self.grid.each_slice(width) do |row|
      string << row.map { |cell| cell.ascii_art}.join
      string << "\n"
    end
    string
  end

  def index_on_west_edge?(index)
    index % self.width == 0
  end

  def index_on_east_edge?(index)
    index % self.width == self.width - 1
  end

  def index_on_north_edge?(index)

    index < self.width
  end

  def index_on_south_edge?(index)
    index >= (self.width * self.height) - self.width
  end

  def west_of_index(index)
    return if index_on_west_edge?(index)
    index - 1
  end

  def east_of_index(index)
    return if index_on_east_edge?(index)
    index + 1
  end

  def north_of_index(index)
    return if index_on_north_edge?(index)
    index - self.width
  end

  def south_of_index(index)
    return if index_on_south_edge?(index)
    index + self.width
  end

  def nw_of_index(index)
    return if index_on_north_edge?(index)
    return if index_on_west_edge?(index)
    index - self.width - 1
  end

  def ne_of_index(index)
    return if index_on_north_edge?(index)
    return if index_on_east_edge?(index)
    index - self.width + 1
  end

  def sw_of_index(index)
    return if index_on_south_edge?(index)
    return if index_on_west_edge?(index)
    index + self.width - 1
  end

  def se_of_index(index)
    return if index_on_south_edge?(index)
    return if index_on_east_edge?(index)
    index + self.width + 1
  end
end
