class Engine
  attr_accessor :game

  def initialize
    @game = Game.new
  end

  def run
    loop do
      Engine.clear_screen
      puts "=" * 60 + "\nWELCOME TO HANGERMAN!\n" + "=" * 60
      puts

      choice = ''
      loop do
        puts "Choose an option below:"
        puts "[1] New Game"
        puts "[2] Load Game"
        choice = $stdin.gets.chomp
        break if choice =~ /^1$|^2$/
        print "Invalid input!\s"
      end

      @game = Engine.load_game if choice == '2'

      @game.play
    end
  end

  # def save_game(game)
  #   # Prompt player to choose saved game name.
  #   puts "Name your saved game:"
  #   name = $stdin.gets.chomp
  #
  #   # Create saved_games folder if it doesn't exits.
  #   Dir.mkdir('bin/saved_games') if !Dir.exists?('bin/saved_games')
  #
  #   # Save the game.
  #   File.open("bin/saved_games/#{name}", 'w') { |f| f.write(Marshal.dump(game)) }
  #
  #   puts "Game '#{name}' saved!"
  #   sleep(1)
  # end

  def self.load_game
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

  def self.clear_screen
    system "clear" or system "cls"
  end

end
