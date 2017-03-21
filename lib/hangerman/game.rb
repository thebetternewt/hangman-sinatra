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
        break if valid_guess?(input) && save_or_load_game(input)
      end

      unless input =~ /^SAVE$|^LOAD$/
        @letters_guessed << input
        @turns -= 1 if !correct_guess?(input)
      end
      display_board
      break if over?
    end
  end

  def self.save(game)
    # Prompt player to choose saved game name.
    puts "Name your saved game:"
    name = $stdin.gets.chomp

    # Create saved_games folder if it doesn't exits.
    Dir.mkdir('bin/saved_games') if !Dir.exists?('bin/saved_games')

    # Save the game.
    File.open("bin/saved_games/#{name}", 'w') { |f| f.write(Marshal.dump(game)) }

    puts "Game '#{name}' saved!"
    sleep(1)
  end

  def self.load
    puts "Pick saved game to load:"

    # List saved games, ignoring '.' & '..' files.
    saved_games = Dir.entries('bin/saved_games').select { |f| !/^\.+$/.match(f) }
    saved_games.each_with_index do |filename, index|
     puts "[#{ index + 1 }] #{filename}"
   end

   # Prompt player to choose game to load.
   puts "\nChoose game to load:"
   puts ">> "
   game_choice = $stdin.gets.chomp.to_i
   saved_game_filename = "bin/saved_games/#{saved_games[game_choice - 1]}"

   # Load game.
   saved_game = File.read(saved_game_filename)
   puts ("'#{saved_games[game_choice - 1]}' loaded!")
   sleep(1)
   Marshal.load(saved_game)
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

  def valid_guess?(input)
    if input =~ /^[A-Za-z]$|^SAVE$|^LOAD$/i
      if @letters_guessed.include?(input)
        puts "Invalid input! You already guessed '#{input}'."
        return false
      else
        return true
      end
    end
    puts "Invalid input!"
    return false
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

  def save_or_load_game(input)
    if input == 'SAVE'
      Game.save(self)
    elsif input == 'LOAD'
      game = Game.load
      game.play
    end
    true
  end

end
