# frozen_string_literal: true

class Game
  MAX_GUESSES = 12

  def initialize(setter, guesser)
    @setter = setter
    @guesser = guesser
    @answer = []
  end

  def start
    # Set the answer if the setter is human, or generate a random answer if the setter is computer
    if @setter == :human
      puts 'Please enter the answer (4 digits without space): '
      @answer = gets.chomp.chars.map(&:to_i)
    else
      @answer = Array.new(4) { rand(1..9) }
      puts 'The answer has been set by the computer'
    end
    puts '-' * 80

    # Loop until the guesser guesses the answer or runs out of guesses
    MAX_GUESSES.times do |guess_number|
      guesses_left = MAX_GUESSES - guess_number
      puts "You have #{guesses_left} guess#{guesses_left == 1 ? '' : 'es'} left"

      # Get the guess if the guesser is human, or generate a random guess if the guesser is computer
      if @guesser == :human
        print 'Enter your guess (4 digits without space): '
        guess = gets.chomp.chars.map(&:to_i)
      else
        guess = Array.new(4) { rand(1..9) }
        puts "The computer has made a guess: #{guess.join('')}"
      end

      # Check if the guess is valid
      if guess.length != 4 || guess.any? { |digit| digit < 1 || digit > 9 }
        puts 'Invalid guess, please try again'
        next
      end

      # Check if the guess is correct
      if guess == @answer
        puts '-' * 80
        if @guesser == :human
          puts 'Congratulations, you guessed the answer!'
        else
          puts 'The computer guessed the answer!'
        end
        break
      end
      # Compute the clues for the guess
      clues = []
      guess.each_with_index do |digit, index|
        clues << if digit == @answer[index]
                   "\u{1F7E2}" # green circle
                 elsif @answer.include?(digit)
                   "\u{1F7E1}" # yellow circle
                 else
                   "\u26AA" # white circle
                 end
      end

      puts "Clues: #{clues.join('')}"

      if guesses_left == 1 && @guesser == :human
        puts '-' * 80
        puts "Game over!\nYou can't guess your number, you lose!"
      elsif guesses_left == 1 && @guesser == :computer
        puts '-' * 80
        puts "Game over!\nThe computer can't guess your number, you win!"
      end
    end

    # Display the answer if the guesser runs out of guesses
    puts "The answer is #{@answer.join('')}" if MAX_GUESSES == 12
  end
end

puts 'Welcome to Mastermind game!'
puts "Do you want to be the setter or the guesser? (enter '1' for setter, '2' for guesser)"
role = gets.chomp.downcase
case role
when '1'
  # Play the game with the computer as the guesser and the human as the setter
  game = Game.new(:human, :computer)
  game.start
when '2'
  # Play the game with the computer as the setter and the human as the guesser
  game = Game.new(:computer, :human)
  game.start
else
  puts 'Invalid input, please try again'
end
