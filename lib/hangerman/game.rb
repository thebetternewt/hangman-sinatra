class Game
  attr_accessor :word, :letters_guessed

  def initialize
    @player = Player.new
    @word = Dictionary.get_word
    @turns = 6
    @letters_guessed = []
  end

  def play
    display_board

    loop do
      letter = ''
      loop do
        letter = @player.guess_letter
        break if valid_guess?(letter)
      end

      @letters_guessed << letter
      @turns -= 1 if !correct_guess?(letter)
      display_board
      break if over?
    end
  end

  private

  def display_board
    clear
    puts "Turns left: #{ @turns }"
    puts
    puts "#{ word_with_blanks }"
    puts
    puts "Letters guessed: #{ @letters_guessed.join(' ') }"
    puts
  end

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

  def correct_guess?(letter)
    @word.include?(letter)
  end

  def valid_guess?(letter)
    if @letters_guessed.include?(letter)
      puts "Invalid input! You already guessed '#{letter}'."
      return false
    end
    return true
  end

  def word_guessed?
    @word.split('').each do |letter|
      return false if !@letters_guessed.include?(letter)
    end
    true
  end

  def over?
    if word_guessed?
      puts "You win!"
      return true
    elsif @turns == 0
      puts "Game Over! You're out of turns. The word was '#{ @word }'."
      return true
    else
      return false
    end
  end

  def clear
    system "clear" or system "cls"
  end

end
