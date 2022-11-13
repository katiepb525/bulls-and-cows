# frozen_string_literal: true

# store all methods relating to player
class Player
  attr_reader :guess

  # have guess be gets by default
  def initialize
    @guess = gets.chomp # will be string
  end

  # check if guess input is valid
  def player_input_ok?
    # check if guess ONLY contains numbers 1-6 AND has exactly four chars
    @guess.count('^1-6').zero? && @guess.count('1-6') == 4
  end

  # convert guess to number IF player input is ok, otherwise return nil
  def guess_to_num
    return unless player_input_ok?

    @guess.to_i
  end
end

# store all methods relating to computer
class Computer
end

# display input of player, output of computer, current round etc.
class Display
end

# define rules for a game, define steps for a game, win/lose conditions etc.
class NewGame
end
