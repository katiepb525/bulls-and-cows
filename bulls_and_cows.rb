# frozen_string_literal: true

# store all methods relating to player
class Player
  # have guess be gets by default
  def initialize
    @guess = gets.chomp # will be string
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
