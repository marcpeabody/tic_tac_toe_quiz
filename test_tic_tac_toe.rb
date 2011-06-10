require File.join(File.dirname(__FILE__), 'tic_tac_toe' )
require 'test/unit'
class TestTicTacToe < Test::Unit::TestCase
  def test_game_over
    set_moves ['X','O','X',
           'X',nil,nil,
           'X',nil,nil]
    assert @ttt.result == 'X'
  end

  def test_not_over
    set_moves ['X','O','X',
           nil,nil,nil,
           'X',nil,nil]
    assert @ttt.result == nil
  end

  def test_i_win
    set_moves ['X','O','X',
           nil,'X',nil,
           'X',nil,nil]
    assert @ttt.result == 'X'
    assert @ttt.won?
  end

  def test_opponent_wins
    set_moves ['X','O','X',
           nil,'O',nil,
           'X','O',nil]
    assert @ttt.result == 'O'
    assert @ttt.lost?
  end

  def test_available_moves_empty_board
    set_moves Array.new(9)
    assert @ttt.available_moves == (0..8).to_a
  end

  def test_available_moves_half_game
    set_moves [nil,nil,nil, 'X','O','X', nil, 'O', nil]
    assert @ttt.available_moves == [0,1,2,6,8]
  end

  def test_available_moves_end_game
    set_moves %w{X O X O X O X O X}
    assert @ttt.available_moves == []
  end

  def test_tie_true
    set_moves %w{X O X O X O O X O}
    @ttt.determine_result
    assert @ttt.available_moves == [], 'no moves should be left'
    assert !@ttt.won?, 'should not have won'
    assert !@ttt.lost?, 'should not have lost'
    assert @ttt.tie?, 'should be tie'
  end

  def test_make_first_move
    ttt = TicTacToe.new
    ttt.make_move
    assert ttt.board.compact == ['X']
  end

  def set_moves(moves)
    @ttt = TicTacToe.new
    moves.each_with_index{|player,slot| @ttt.add_move(player, slot) if player }
  end
end
