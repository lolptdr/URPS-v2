require 'sinatra'
require 'rack-flash'
require 'pry-byebug'
require_relative 'lib/urps.rb'


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
    # erb :signin ----> remove, not necessary
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
  # 3rd entry corresponds to user's id, 2nd entry corresponds to username
  # 1st entry corresponds to match_id
  @check_host.map! { |x| [x[0], Arena.dbi.get_username_by_id(x[1]), x[1]] }

  erb :control_panel
end

post '/control_panel' do
  # Need form-post submit button "Create Match"
  response = Arena.dbi.create_match(@current_user.user_id)
  redirect to '/arena'
end

get '/arena' do
  
  @matches = Arena.dbi.find_open_match
  if @matches == nil
    create_match(player1)
  end

  erb :arena, layout: false
end

get '/arena/:match_id/:id' do

  # match = Arena.dbi.update_match_for_player2(@current_user.user_id, params["id"])
  match = Arena.dbi.update_match_for_player2(params["match_id"], params["id"])
  
  # match = Arena.dbi.get_match_by_user_id(params["id"])
  # match.player2 = @current_user.user_id
  
  # using update_match_for_player2 method combining Arena.dbi.update_match(match)

  redirect '/arena/' + params['match_id'] + params['id'].to_s
end


post '/arena/:id' do

end

# get '/join_match/:id' do
#   match = Arena.dbi.find_match_by_id

#   erb :arena
# end

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
