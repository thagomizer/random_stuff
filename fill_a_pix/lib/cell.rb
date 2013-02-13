# -*- coding: undecided -*-
class Cell
  attr_accessor :value, :neighbors, :clue

  def initialize
    self.neighbors = []
  end

  def painted?
    self.value == 'B'
  end

  def known?
    self.value
  end

  def unknown?
    !self.value
  end

  def done?
    self.num_unknown_neighbors_and_self == 0
  end

  def clue= value
    if value.between?(0, 9)
      @clue = value
    else
      raise ArgumentError.new("Clue must be between 0 and 9")
    end
  end

  def self_and_neighbors
    self.neighbors + [self]
  end

  def paint_unknown_neighbors_and_self value
    self.self_and_neighbors.each do |n|
      next if n.known?
      n.value = value
    end
  end

  def num_painted_neighbors_and_self
    neighbor_count = 0

    self.self_and_neighbors.each do |n|
      neighbor_count += 1 if n.painted?
    end

    neighbor_count
  end

  def num_unknown_neighbors_and_self
    neighbor_count = 0

    self.self_and_neighbors.each do |n|
      neighbor_count += 1 if n.unknown?
    end

    neighbor_count
  end

  def fill_in
    return unless self.clue

    new_clue_value = self.clue - self.num_painted_neighbors_and_self

    case new_clue_value
    when 0
      paint_unknown_neighbors_and_self('W')
    when num_unknown_neighbors_and_self
      paint_unknown_neighbors_and_self('B')
    else
      return false
    end
    return true
  end

  def to_s
    result = "Neighbor Count #{self.neighbors.count}"
    result << " Value #{self.value} " if self.value
    result << " Clue #{self.clue} " if self.clue
    result
  end

  def ascii_art
    case self.value
    when "B"
      "█"
    when "W"
      " "
    else
      "."
    end
  end
end
