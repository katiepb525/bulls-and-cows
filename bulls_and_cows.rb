# frozen_string_literal: true

require 'pry-byebug'

# include all methods required to be the master (maybe change module name because these are only automated methods)
module Master
  attr_accessor :master_code

  def initialize
    @master_code = []
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

# include all methods required to be the guesser (maybe change because these methods require player input, create seperate module for an automated guesser )
module Guesser
  attr_accessor :guess

  def initialize
    @guess = ''
  end

  # check if guess input is valid
  def player_input_ok?(input)
    # check if guess ONLY contains numbers 1-6 AND has exactly four chars
    input.count('^1-6').zero? && input.count('1-6') == 4
  end

  # convert guess to array IF player input is ok, otherwise return nil
  def guess_to_array
    return unless player_input_ok?(@guess)

    @guess.split('')
  end

  # automated: computer will solve game according to donald kuth's algorithm
  def generate_guess
    # step 1: generate set S of all possible codes
    s = (1111..6666).to_a
  end
end

# store all methods relating to player
class Player
  extend Master
  extend Guesser
end

# store all methods relating to computer
class Computer < Player
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

  # method where the player picks the master code and the computer must guess
  def start_master_game
    until player_input_ok?(@player.master_code)
      puts "enter your secret code. 4 digits, and numbers 1-6 only please.\n e.g. 1234"
      @player.master_code = (gets.chomp)
    end
  end

  # method where the computer generates the master code and the player must guess
  def start_guesser_game
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

  def master_or_guesser?
    until answer == 'M' || answer == 'G'
      puts "press 'M' if you'd like to be the master.\npress 'G' if you'd like to be the guesser."
      answer = gets.chomp
    end

    if answer == 'M'
      start_master_game
    elsif answer == 'G'
      start_guesser_game
    end
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
game.master_or_guesser?
