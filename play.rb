require File.join(File.dirname(__FILE__), 'tic_tac_toe' )

class Play
  def initialize
    interactive = ARGV.first ? ARGV.pop : false
    new_game(interactive)
  end

  def new_game(interactive)
    @game = TicTacToe.new
    while !@game.result
      if interactive
        print_board
        puts "Make a move (0-8)"
        @game.accept_move(gets.chomp.to_i)
      else
        @game.accept_move(@game.best_move)
      end
      @game.make_move if !@game.result
    end
    print_board

    if @game.tie?
      puts "It's a tie."
    elsif winner = @game.winner
      puts "#{winner}'s won the match."
    end
  end

  def print_board
    b = @game.board.collect{|x| x||' '}
puts "
#{b[0]}|#{b[1]}|#{b[2]}
-----
#{b[3]}|#{b[4]}|#{b[5]}
-----
#{b[6]}|#{b[7]}|#{b[8]}
"
  end
end

Play.new
