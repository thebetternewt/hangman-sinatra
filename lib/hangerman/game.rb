class Game
  attr_accessor :word, :letters_guessed

  def initialize
    @player = Player.new
    @word = Dictionary.get_word
    @turns = 6
    @letters_guessed = []
  end

  def display_board
    puts "Turns left: #{ @turns }"
    puts
    puts "#{ word_with_blanks }"
    puts
    puts "Letters guessed: #{ @letters_guessed.join(' ') }"
  end

  private

  def word_with_blanks
    word_with_blanks = []
    @word.split('').each do |letter|
      if !@letters_guessed.include?(letter.upcase)
        word_with_blanks << '_'
      else
        word_with_blanks << letter
      end
    end
    word_with_blanks.join(' ')
  end

end
