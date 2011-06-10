class TicTacToe
  attr_accessor :board, :result
  WIN_CONDITIONS = [[0,1,2],
                    [3,4,5],
                    [6,7,8],
                    [0,3,6],
                    [1,4,7],
                    [2,5,8],
                    [0,4,8],
                    [2,4,6]]
  def initialize
    @board = Array.new(9)
    @moves = {'X'=>[], 'O'=>[]}
  end

  def make_move
    raise "Game already over" if @result
    move = best_move
    add_move 'X', move
    move
  end

  def best_move(for_self=true)
    my_moves    = @moves[for_self ? 'X' : 'O']
    their_moves = @moves[for_self ? 'O' : 'X']
    GameMemory.new.best_move(my_moves, their_moves, available_moves)
  end

  def available_moves
    (0..8).to_a.select{|i| @board[i] == nil }
  end

  def accept_move(move)
    move = move.to_i
    raise 'Illegal Move' unless available_moves.include? move
    add_move 'O', move
  end

  def winner
    @result unless @result == :tie
  end

  def loser
    @result == 'O' ? 'X' : 'O' unless @result == :tie
  end

  def add_move(player, slot)
    @board[slot] = player
    @moves[player] << slot
    determine_result
  end

  def won?
    @result == 'X'
  end

  def lost?
    @result == 'O'
  end

  def tie?
    @result == :tie
  end

  def determine_result
    WIN_CONDITIONS.any? do |set|
      vals = set.collect{|slot| @board[slot] }.uniq
      if vals.size == 1 && vals.first != nil
        puts "WINNER????? #{vals}"
        @result = vals.first if vals.first
        GameMemory.new.remember(@moves[winner],@moves[loser])
      end
    end
    @result = :tie if !@result && available_moves.size == 0
  end
end

class GameMemory
  def best_move(my_moves, their_moves, available_moves)
    #no history, so go random
    return available_moves.sample if games.empty?

    #only option left
    return available_moves.first if available_moves.size == 1
puts "OPENING"
    #opening move
    return best_opening if available_moves.size == 9

puts "WINNER"
    #ftw
    winning_move = guaranteed_win(winning_sets, my_moves, available_moves)
    return winning_move if winning_move

puts "BLOCKER"
    #ftb
    block_win    = guaranteed_win(winning_sets, their_moves, available_moves)
    return block_win if block_win

puts "STRATEGY"
    #two from win
    strat        = strategy_move(winning_sets, their_moves, available_moves)
    return strat if strat

puts "BEST"
    best_off    = most_common(winning_sets, my_moves, available_moves).first
    return best_off if best_off
    # best_def = most_common(winning_sets, their_moves)
    # not_winning_moves = all_shared()

puts "RANDOM"
    #random *shrug*
    available_moves.sample
  end

  def all_shared(sets, subset)
    sets.select{|set| (set | subset) == set }.flatten.uniq
  end

  def best_opening
    winning_sets.flatten.group_by{|e| e}.values.sort_by(&:size).reverse.first.first
  end

  def strategy_move(sets, subset, available)
    sets_with_winning_moves = sets.select{|set| (set - subset).size == 2 }
    winnish_moves = sets_with_winning_moves.collect{|set| set - subset }.flatten.uniq
    (winnish_moves & available).first
  end

  def most_common(sets, subset, available)
    sets_containing_subset = sets.select{|set| (set | subset) == set }
    filter_out_availables  = sets_containing_subset.collect{|set| set & available }
    all_good_moves_grouped = filter_out_availables.flatten.group_by{|e| e}
    best_moves_in_order    = all_good_moves_grouped.values.sort_by(&:size).reverse.collect{|g| g.first}
  end

  def guaranteed_win(sets, subset, available)
    puts "ALL #{sets} ... #{subset} ... #{available}"
    sets_with_winning_moves = sets.select{|set| (set - subset).size == 1 }
    puts "WINNINGS #{sets_with_winning_moves}"
    winning_moves = sets_with_winning_moves.collect{|set| set - subset }.flatten.uniq
    puts "WINNING MOVE #{winning_moves}"
    (winning_moves & available).first
  end

  def winning_sets
    @winning_sets ||= games.collect{|g| g.split(',')[0].split('').collect{|s| s.to_i} }
  end

  def losing_sets
    @losing_sets  ||= games.collect{|g| g.split(',')[1].split('').collect{|s| s.to_i} }
  end

  def file
    File.open('games.txt','a+')
  end

  def games
    @games ||= file.read.split("\n")[0..-1] || []
    puts "GAMES #{@games}"
    @games
  end

  def remember(winning,losing)
    file << "#{winning.join},#{losing.join}\n"
  end
end
