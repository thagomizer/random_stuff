require 'minitest/autorun'
require 'cell'
require 'pp'

class TestCell < MiniTest::Unit::TestCase
  def setup
    @cell = Cell.new
  end

  def make_corner(cell)
    # corners have 3 neighbors
    neighbors = []
    3.times do
      neighbors << Cell.new
    end

    @cell.neighbors = neighbors
  end

  def make_edge(cell)
    # edges have 5 neighbors
    neighbors = []
    5.times do
      neighbors << Cell.new
    end

    @cell.neighbors = [Cell.new] * 5
  end

  def make_regular(cell)
    # regular cells have 8 neighbors
    neighbors = []
    8.times do
      neighbors << Cell.new
    end
    @cell.neighbors = [Cell.new] * 8
  end

  def test_cells_can_have_clues
    @cell.clue = 4
    assert_equal 4, @cell.clue
  end

  def test_clues_are_numbers_between_0_and_9
    (0..9).each do |x|
      @cell.clue = x
      assert_equal x, @cell.clue
    end

    assert_raises(ArgumentError) { @cell.clue = "9" }
  end

  def test_cells_have_values_white_black_or_nil
    assert_nil @cell.value
    @cell.value = "W"
    assert_equal "W", @cell.value
    @cell.value = "B"
    assert_equal "B", @cell.value
  end

  def test_cells_have_neighbors
    refute_nil @cell.neighbors
  end

  def test_fill_in_corner_with_clue_4
    @cell.clue = 4
    make_corner(@cell)

    assert_equal 0, @cell.num_painted_neighbors_and_self

    @cell.fill_in

    assert @cell.neighbors.all? { |x| x.value == 'B' }
    assert_equal 'B', @cell.value
  end

  def test_fill_in_edge_with_clue_6
    @cell.clue = 6
    make_edge(@cell)

    assert_equal 0, @cell.num_painted_neighbors_and_self

    @cell.fill_in

    assert @cell.neighbors.all? { |x| x.value == 'B' }
    assert_equal 'B', @cell.value
  end

  def test_fill_in_regular_cell_with_clue_9
    @cell.clue = 9
    make_regular(@cell)

    assert_equal 0, @cell.num_painted_neighbors_and_self

    @cell.fill_in

    assert @cell.neighbors.all? { |x| x.value == 'B' }
    assert_equal 'B', @cell.value
  end

  def test_fill_in_corner_with_clue_0
    @cell.clue = 0
    make_corner(@cell)

    @cell.fill_in

    assert @cell.neighbors.all? { |x| x.value == 'W' }
    assert_equal 'W', @cell.value
  end

  def test_fill_in_when_shaded_neighbors_equals_clue
    @cell.clue = 2
    make_corner(@cell)
    @cell.neighbors[0].value = 'B'
    @cell.value = 'B'

    assert_equal 2, @cell.num_painted_neighbors_and_self

    @cell.fill_in

    assert_equal 'W', @cell.neighbors[1].value
    assert_equal 'W', @cell.neighbors[2].value
  end

  def test_painted
    refute @cell.painted?

    @cell.value = 'B'
    assert @cell.painted?

    @cell.value = 'W'
    refute @cell.painted?
  end
end
