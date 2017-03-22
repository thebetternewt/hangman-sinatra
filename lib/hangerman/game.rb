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
      input = ''
      loop do
        input = @player.guess_letter
        break if evaluate_user_input(input)
      end

      # Quit game if [2] is chosen.
      break if input == '2'

      unless input == '1'
        @letters_guessed << input
        @turns -= 1 if !correct_guess?(input)
      end
      display_board
      break if over?
    end
  end

  private

  def display_board
    Engine.clear_screen
    puts "=" * 60 + "\nHANGERMAN:\n" + "=" * 60
    puts "Enter the following at anytime... "
    puts "[1] Save game"
    puts "[2] Quit game & return to main menu"
    puts
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

  def word_guessed?
    @word.split('').each do |letter|
      return false if !@letters_guessed.include?(letter)
    end
    true
  end

  def over?
    if word_guessed?
      puts "You win!"
      exit(0)
    elsif @turns == 0
      puts "Game Over! You're out of turns. The word was '#{ @word }'."
      exit(0)
    else
      return false
    end
  end

  def evaluate_user_input(input)
    if input =~ /^[A-Za-z]$|^2$/
      if @letters_guessed.include?(input)
        puts "Invalid input! You already guessed '#{input}'."
        return false
      else
        return true
      end
    elsif input == '1'
      save
    else
      puts "Invalid input!"
      return false
    end
  end

  def save
    # Prompt player to choose saved game name.
    puts "Name your saved game:"
    name = $stdin.gets.chomp

    # Create saved_games folder if it doesn't exits.
    Dir.mkdir('bin/saved_games') if !Dir.exists?('bin/saved_games')

    # Save the game.
    File.open("bin/saved_games/#{name}", 'w') { |f| f.write(Marshal.dump(self)) }

    puts "Game '#{name}' saved!"
    sleep(1)
  end

end
