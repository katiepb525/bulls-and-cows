# frozen_string_literal: true

require 'pry-byebug'

# include all methods required to be the master (maybe change module name because these are only automated methods)
module Master
  attr_accessor :master_code

  def initialize
    @master_code = 'a'
  end

  # generate a random 4 digit code using only the nums 1-6
  def generate_rand_code
    @master_code = 4.times.map { rand(1..6) } # create array of random numbers
    @master_code.map!(&:to_s) # convert array to string (to compare with guess)
  end

  def find_bulls_cows(raw_guess, master_code)
    # convert to array form
    guess = guess_to_array(raw_guess.to_s)
    # create var to store clue, clue being player guess at default
    clue = guess
    master_code.each_with_index do |e, idx|
      # if player guess includes number AND matches place in master
      if guess[idx] == e
        # replace clue num with "bull" (B)
        clue[idx] = 'B'
      # if player guess includes number in master code (but not correct place)
      elsif guess.include?(e)
        # replace clue num with "cow" (A)
        cow_index = guess.find_index(e)
        clue[cow_index] = 'A'
      end
    end

    clue
  end
end

# include all methods required to be the guesser
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
  def guess_to_array(guess)
    return unless player_input_ok?(guess)

    guess.split('')
  end
end

# store all methods relating to player
class Player
  include Master
  include Guesser

  def initialize
    @guess = ''
    @master_code = 'a'
  end
end

# store all methods relating to computer
class Computer < Player
  attr_accessor :possible_codes

  def initialize
    super
    # step 1: generate set S of all possible codes
    @possible_codes = (1111..6666).to_a
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
  include Master
  include Guesser
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
      @player.master_code = gets.chomp
    end

    # convert master code into array
    @player.master_code = @player.master_code.split('')

    puts 'game start!'
    current_round = 1

    until current_round == @MAX_TURNS
      puts "round #{current_round} / #{@MAX_TURNS}"
      # step 2: start with initial guess 1122
      if current_round == 1
        @computer.guess = 1122
      else
        com_play_round(@computer.possible_codes)
      end
      # announce guess
      puts "testing guess: #{@computer.guess}"
      if player_won?(@computer.guess, @player.master_code) == true
        p 'computer won!!'
        return
      end
      current_round += 1
    end
  end

  # method where the computer generates the master code and the player must guess
  def start_guesser_game
    puts 'game start!'
    current_round = 1

    # generate the master code
    @computer.generate_rand_code

    until current_round == @MAX_TURNS
      puts "you are on round #{current_round} / #{@MAX_TURNS}"
      play_round
      if player_won?(@player.guess, @computer.master_code) == true
        puts 'you win!!'
        return
      end
      current_round += 1
    end
    puts "you lose.. :[\nthe answer was #{@computer.master_code}!"
  end

  def master_or_guesser?
    answer = ''
    until %w[M G].include?(answer)
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
    p @computer.find_bulls_cows(@player.guess, @computer.master_code)
  end

  # return a hash with the number of bulls and cows in a clue
  def count_bulls_cows(score)
    num_bulls_cows = { bulls: 0, cows: 0 }

    score.each do |e|
      if e == 'B'
        num_bulls_cows[:bulls] += 1
      elsif e == 'A'
        num_bulls_cows[:cows] += 1
      end
    end

    num_bulls_cows
  end

  # automated: computer will solve game according to donald kuth's algorithm
  def com_play_round(possible_codes)
    # step 3: play guess to get response
    score = find_bulls_cows(@computer.guess, @player.master_code)

    p score

    # step 3.5: count cows present and bulls present
    num_bulls_cows = count_bulls_cows(score)

    # step 4: if computer didnt win...
    return unless player_won?(@computer.guess, @player.master_code) == false

    # index of computer's guess
    guess_index = possible_codes.index(@computer.guess)

    # remove all elements of array that do not have same amount of cows/bulls present
    possible_codes.each do |e|
      possible_codes.slice!(guess_index) if find_bulls_cows(e, @player.master_code) != score
    end

    # step 5: test a random element from list S
    find_bulls_cows(possible_codes.sample, @player.master_code)
  end

  # check if player won
  def player_won?(player_guess, master_code)
    @computer.find_bulls_cows(player_guess, master_code) == %w[B B B B]
  end
end

game = NewGame.new
game.master_or_guesser?
