require 'sinatra'
require 'rack-flash'
require 'pry-byebug'
require_relative 'lib/urps.rb'
# require_relative 'lib/urps/signin.rb'

set :bind, '0.0.0.0' 
set :sessions, true
use Rack::Flash

before '/*' do
  @current_user = Arena.dbi.get_user_by_username(session['sesh_example'])
end

get '/' do
  if session['sesh_example']
    @user = Arena.dbi.get_user_by_username(session['sesh_example'])
  end
  
  erb :splash, layout: false
end

get '/signup' do
  erb :signup
end

post '/signup' do

  # This handles issue of blank inputs for sign-up
  if params['username'].empty? or params['password'].empty? or params['password-confirm'].empty?
    flash[:alert] = "Blank inputs! Check your username and password."
    redirect to '/signup'
  end

  # This handles the issue of two identical users
  if Arena.dbi.username_exists?(params['username'])
    flash[:alert] = "Username already exists! Use a different username."
    redirect to '/signup'
  elsif params['password'] == params['password-confirm']
    user = Arena::User.new(params['username'], params['password'])
    user.update_password(params['password'])
    Arena.dbi.persist_user(user)
    session['sesh_example'] = user.username
    redirect to '/control_panel'
  else
    flash[:alert] = "Your passwords don't match. Please check your passwords."
    redirect to '/signup'
  end

end

get '/signin' do
  erb :signin
end

post '/signin' do
  # This handles the issue of blank inputs on Signin page
  if params['username'].empty? or params['password'].empty?
    flash[:alert] = "Blank inputs! Check your username and password."
    redirect to '/signin'
  end

  user = Arena.dbi.get_user_by_username(params['username'])

  if user && user.has_password?(params['password'])
    session['sesh_example'] = user.username
    redirect to '/control_panel'
  else
    flash[:alert] = "Incorrect username and/or password!"
    redirect to '/signin'
  end
end

get '/control_panel' do
  @match_host = Arena.dbi.find_open_match
  @check_host = @match_host.map { |x| [x[:id], x[:player1]] }
  # x[0] = match_id, x[1] = username, x[2] = user_id
  @check_host.map! { |x| [x[0], Arena.dbi.get_username_by_id(x[1]), x[1]] }
  @all_matches_of_current_user = Arena.dbi.get_match_by_user_id(@current_user.user_id)

  erb :control_panel
end

post '/control_panel' do
  if @current_user == nil
    flash[:alert] = "You have logged out. Log in again."
    redirect to "/control_panel"
  else
    response = Arena.dbi.create_match(@current_user.user_id)
    redirect to '/control_panel'
  end
end

get '/arena/:match_id/:id' do
  # match = Arena.dbi.update_match_for_player2(@current_user.user_id, params["id"])
  @match = Arena.dbi.update_match_for_player2(params["match_id"], params["id"])
  # Need method function to check status of the game. Do this by looking
  # at the database for a particular matchID.
  # If P1 value is null and P2 value is null, then it is the "Start of the Game. Waiting for P1".
  # If P2 is null but P1 is not null, then it is "P2's turn"
  # If P1 and P2 are not null, then output the game result. (ex: P1 wins...rock  over scissor) 
  # Output results to view
  erb :arena, layout: false
end

post '/arena/:match_id/:id' do
  @get_match = Arena.dbi.get_match_by_id(params["match_id"])
  @persisted_round = Arena.dbi.persist_round(@get_match)

  @round = Arena.dbi.update_round_by_move(params["move"], @get_match)
  @match = Arena.dbi.update_match_for_player2(@round[0][:id], @round[0][:player1])

  @all_matches_of_current_user = Arena.dbi.get_match_by_user_id(@current_user.user_id)
binding.pry
  redirect to '/arena/:match_id/:id'
end


get '/control_panel/delete_match/:id' do
  Arena.dbi.delete_match(params[:id].to_i)
  redirect to '/control_panel'
end

get '/arena/delete_match/:id' do
  Arena.dbi.delete_match(params[:id].to_i)
  redirect to '/arena'
end

get '/signout' do
  session.clear
  redirect to '/'
end
