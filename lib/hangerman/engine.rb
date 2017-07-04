class Engine
  attr_accessor :game

  def initialize
    @game = Game.new
  end

  # def run
  #   @game.play
  # end

  def self.saved_games
    Dir.entries('bin/saved_games').reject { |f| /^\.+$/.match(f) }
  end

  def self.load_game(filename)
    saved_game_filename = "bin/saved_games/#{filename}"

    # Load game.
    saved_game = File.read(saved_game_filename)
    puts "'#{filename}' loaded!"
    Marshal.load(saved_game)
  end
end
