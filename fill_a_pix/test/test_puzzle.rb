require 'minitest/autorun'
require 'puzzle'
require 'cell'

class TestPuzzle < MiniTest::Unit::TestCase
  def setup
    @p = Puzzle.new
    @p.width = 5
    @p.height = 4
  end

  def test_index_on_west_edge
    assert @p.index_on_west_edge?(0)
    assert @p.index_on_west_edge?(5)
    assert @p.index_on_west_edge?(10)
    assert @p.index_on_west_edge?(15)
  end

  def test_index_on_east_edge
    assert @p.index_on_east_edge?(4)
    assert @p.index_on_east_edge?(9)
    assert @p.index_on_east_edge?(14)
    assert @p.index_on_east_edge?(19)
  end

  def test_index_on_north_edge
    assert @p.index_on_north_edge?(0)
    assert @p.index_on_north_edge?(1)
    assert @p.index_on_north_edge?(2)
    assert @p.index_on_north_edge?(3)
    assert @p.index_on_north_edge?(4)
  end

  def test_index_on_south_edge
    assert @p.index_on_south_edge?(15)
    assert @p.index_on_south_edge?(16)
    assert @p.index_on_south_edge?(17)
    assert @p.index_on_south_edge?(18)
    assert @p.index_on_south_edge?(19)
  end

  def test_neighbors_for_index
    assert_equal [1, 5, 6], @p.neighbors_for_index(0).sort
    assert_equal [0, 2, 5, 6, 7], @p.neighbors_for_index(1).sort
    assert_equal [3, 8, 9], @p.neighbors_for_index(4).sort
    assert_equal [0, 1, 6, 10, 11], @p.neighbors_for_index(5).sort
  end

  def test_can_import_puzzle_from_file
    p = Puzzle.new
    p.load_puzzle('test/three_by_three.txt')

    assert_equal 9, p.grid.length

    assert p.grid.all? { |g| g.instance_of?(Cell) }

    assert_equal [3, 5, 3, 5, 8, 5, 3, 5, 3], p.grid.map { |c| c.neighbors.count}
    assert_equal [nil, nil, nil, nil, 9, nil, nil, nil, nil], p.grid.map(&:clue)
  end

  def test_solve
    p = Puzzle.new
    p.load_puzzle('test/three_by_three.txt')

    p.solve

    expected = ["B"] * 9

    assert_equal expected, p.grid.map(&:value)

    assert_equal "@@@\n@@@\n@@@\n", p.to_s
  end
end
