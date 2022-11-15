# frozen_string_literal: true

require 'pry-byebug'

# store all methods relating to player
class Player
  attr_accessor :guess

  def initialize
    @master_or_guesser = ''
    @guess = ' '
  end

  # check if guess input is valid
  def player_input_ok?
    # check if guess ONLY contains numbers 1-6 AND has exactly four chars
    @guess.count('^1-6').zero? && @guess.count('1-6') == 4
  end

  # convert guess to array IF player input is ok, otherwise return nil
  def guess_to_array
    return unless player_input_ok?

    @guess.split('')
  end
end

# store all methods relating to computer
class Computer
  attr_reader :master_code

  def initialize
    @master_or_guesser = ''
    @master_code = generate_rand_code
  end

  # generate a random 4 digit code using only the nums 1-6
  def generate_rand_code
    @master_code = 4.times.map { rand(1..6) } # create array of random numbers
    @master_code.map!(&:to_s) # convert array to string (to compare with guess)
  end

  def find_bulls_cows(player)
    # store player's guess in array form
    player_guess = player.guess_to_array
    # create var to store clue, clue being player guess at default
    clue = player_guess

    @master_code.each_with_index do |e, idx|
      # if player guess includes number AND matches place in master
      if player_guess[idx] == e
        # replace clue num with "bull" (B)
        clue[idx] = 'B'
      # if player guess includes number in master code (but not correct place)
      elsif player_guess.include?(e)
        # replace clue num with "cow" (A)
        cow_index = player_guess.find_index(e)
        clue[cow_index] = 'A'
      end
    end

    clue
  end
end

# display input of player, output of computer, current round etc.
class Display
  def initialize
    @prev_guesses = []
    @prev_clues = []
    @current_round = 0
  end
end

# define rules for a game, define steps for a game, win/lose conditions etc.
class NewGame
  def initialize
    @player = Player.new
    @computer = Computer.new
    @display = Display.new
    # max number of turns in a game
    @MAX_TURNS = 12
  end

  def start_game
    puts 'game start!'
    current_round = 1

    until current_round == @MAX_TURNS
      puts "you are on round #{current_round} / #{@MAX_TURNS}"
      play_round
      if player_won? == true
        puts 'you win!!'
        return
      end
      current_round += 1
    end
    puts "you lose.. :[\nthe answer was #{@computer.master_code}!"
  end

  def play_round
    puts 'enter a guess:'
    @player.guess = (gets.chomp)
    p @computer.find_bulls_cows(@player)
  end

  def player_won?
    @computer.find_bulls_cows(@player) == %w[B B B B]
  end
end

game = NewGame.new
game.start_game
