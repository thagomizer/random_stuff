require 'minitest/autorun'
require 'game'

class TestGame < MiniTest::Unit::TestCase
  def setup
    @game = Game.new
  end

  def test_load_seed
    @game.load_seed("test/test_seed.txt")

    expected_cells = %w[l l l l]
    assert_equal expected_cells, @game.cells
    assert_equal 2, @game.width
  end

  def test_load_seed
    @game.load_seed("test/test_seed_with_blanks.txt")

    expected_cells = ["l", nil, nil, "l"]
    assert_equal expected_cells, @game.cells
    assert_equal 2, @game.width
  end

  def test_evolve
    @game.width = 1
    @game.cells = ["l"]
    @game.evolve

    assert_equal [nil], @game.cells
  end

  def test_neighbors_2_by_2
    @game.width = 2
    @game.cells = Array.new(4).fill("l")

    assert_equal [2, 1, 3], @game.neighbors(0)
    assert_equal [3, 0, 2], @game.neighbors(1)
    assert_equal [0, 3, 1], @game.neighbors(2)
    assert_equal [1, 2, 0], @game.neighbors(3)

    assert_equal 3, @game.live_neighbor_count(0)
    assert_equal 3, @game.live_neighbor_count(1)
    assert_equal 3, @game.live_neighbor_count(2)
    assert_equal 3, @game.live_neighbor_count(3)
  end

  def test_neighbors_2_by_3
    @game.width = 3
    @game.cells = Array.new(6).fill("l")

    assert_equal [3, 1, 4], @game.neighbors(0)
    assert_equal [4, 2, 5, 0, 3], @game.neighbors(1)
    assert_equal [5, 1, 4], @game.neighbors(2)
    assert_equal [0, 4, 1], @game.neighbors(3)
    assert_equal [1, 5, 2, 3, 0], @game.neighbors(4)
    assert_equal [2, 4, 1], @game.neighbors(5)

    assert_equal 3, @game.live_neighbor_count(0)
    assert_equal 5, @game.live_neighbor_count(1)
    assert_equal 3, @game.live_neighbor_count(2)
    assert_equal 3, @game.live_neighbor_count(3)
    assert_equal 5, @game.live_neighbor_count(4)
    assert_equal 3, @game.live_neighbor_count(5)
  end

  def test_neighbors_2_by_3_top_row_allive
    @game.width = 3
    @game.cells = ["l", "l", "l", nil, nil, nil]

    assert_equal [3, 1, 4], @game.neighbors(0)
    assert_equal [4, 2, 5, 0, 3], @game.neighbors(1)
    assert_equal [5, 1, 4], @game.neighbors(2)
    assert_equal [0, 4, 1], @game.neighbors(3)
    assert_equal [1, 5, 2, 3, 0], @game.neighbors(4)
    assert_equal [2, 4, 1], @game.neighbors(5)

    assert_equal 1, @game.live_neighbor_count(0)
    assert_equal 2, @game.live_neighbor_count(1)
    assert_equal 1, @game.live_neighbor_count(2)
    assert_equal 2, @game.live_neighbor_count(3)
    assert_equal 3, @game.live_neighbor_count(4)
    assert_equal 2, @game.live_neighbor_count(5)
  end

  def test_live_cell_with_fewer_than_two_neighbors_dies
    @game.width = 2
    @game.cells = ["l", nil, nil, nil]

    @game.evolve

    assert_equal Array.new(4), @game.cells
  end

  def test_live_cell_with_two_live_neighbors_lives_on
    @game.width = 3
    @game.cells = ["l", "l", "l", nil, nil, nil]

    @game.evolve

    assert_equal [nil, "l", nil, nil, "l", nil], @game.cells
  end

  def test_live_cell_with_three_live_neighbors_lives_on
    @game.width = 2
    @game.cells = Array.new(4).fill("l")

    @game.evolve

    assert_equal Array.new(4).fill("l"), @game.cells
  end

  def test_live_cell_with_more_than_three_live_neighbors_dies
    @game.width = 3
    @game.cells = Array.new(6).fill("l")

    @game.evolve

    assert_equal ["l", nil, "l", "l", nil, "l"], @game.cells
  end

  def test_dead_cell_with_exactly_three_live_neighbors_becomes_live
    @game.width = 3
    @game.cells = ["l", "l", "l", nil, "l", nil]

    @game.evolve

    assert_equal Array.new(6).fill("l"), @game.cells
  end

  def test_to_s
    @game.width = 2
    @game.cells = ["l", nil, "l", nil]

    str = @game.to_s

    assert_equal "0.\n0.\n", str
  end

  def test_run_blinker
    @game.load_seed("test/test_blinker.txt")

    vert = Array.new(25)
    vert[7] = "l"
    vert[12] = "l"
    vert[17] = "l"

    horz = Array.new(25)
    horz[11] = "l"
    horz[12] = "l"
    horz[13] = "l"

    assert_equal horz, @game.cells

    @game.run(1)

    assert_equal vert, @game.cells

    @game.run(1)

    assert_equal horz, @game.cells

    @game.run(10)

    assert_equal horz, @game.cells
  end
end
