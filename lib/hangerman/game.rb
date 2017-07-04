class Game
  attr_accessor :word, :letters_guessed, :turns

  def initialize
    @word = Dictionary.get_word
    @turns = 6
    @letters_guessed = []
  end

  # Displays word with underscores & guessed letters.
  def word_with_blanks
    word_with_blanks = []
    @word.split('').each do |letter|
      if !@letters_guessed.include?(letter)
        word_with_blanks << '_'
      else
        word_with_blanks << letter
      end
    end
    word_with_blanks.join(' ')
  end

  # Returns array of error_messages.
  def self.evaluate_user_input(input, letters_guessed)
    if input =~ /^[A-Z]$/i
      if letters_guessed.include?(input)
        ["Invalid input! You already guessed '#{input}'."]
      else
        []
      end
    else
      puts 'Invalid input.'
      ['Invalid input! Please input a letter A-Z.']
    end
  end

  def correct_guess?(letter)
    @word.include?(letter)
  end

  def over?
    if word_guessed?
      'You win!'
    elsif @turns.zero?
      "Game Over! You're out of turns. The word was '#{@word}'."
    else
      false
    end
  end

  def save(name)
    # Create saved_games folder if it doesn't exits.
    Dir.mkdir('bin/saved_games') unless Dir.exist?('bin/saved_games')

    # Save the game.
    File.open("bin/saved_games/#{name}", 'w') do |f|
      f.write(Marshal.dump(self))
    end
  end

  private

  def word_guessed?
    @word.split('').each do |letter|
      return false unless @letters_guessed.include?(letter)
    end
    true
  end
end
