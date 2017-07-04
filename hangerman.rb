require 'sinatra'
require './lib/hangerman/engine.rb'
require './lib/hangerman/game.rb'
require './lib/hangerman/dictionary.rb'

configure do
  enable :sessions
  set :session_secret, 'secret'
  set :error_messages, []
end

get '/' do
  erb :index
end

get '/new-game' do
  session['game'] = Game.new
  redirect '/play-game'
end

get '/load-game' do
  erb :load_game
end

get '/load-game/:saved_game' do
  session['game'] = Engine.load_game(params['saved_game'])
  redirect '/play-game'
end

get '/play-game' do
  if params['letter']
    params['letter'].upcase!
    settings.error_messages = Game.evaluate_user_input(
      params['letter'],
      session['game'].letters_guessed
    )
    if settings.error_messages.empty?
      session['game'].letters_guessed << params['letter'].upcase
      unless session['game'].correct_guess?(params['letter'].upcase)
        session['game'].turns -= 1
      end
    end
  end

  game_over = session['game'].over?

  erb :play_game, locals: { game: session['game'],
                            error_messages: settings.error_messages,
                            game_over: game_over }
end

get '/save-game' do
  if params['name']
    session['game'].save(params['name'])
    puts "''#{params['name']}' saved!"
    redirect '/play-game'
  end
  erb :save_game, locals: { game: session['game'] }
end

after do
  settings.error_messages = []
end
