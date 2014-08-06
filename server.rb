require 'sinatra'
require 'rack-flash'
require_relative 'lib/sesh.rb'


set :bind, '0.0.0.0' 
set :sessions, true
use Rack::Flash

get '/' do
  if session['sesh_example']
    @user = Sesh.dbi.get_user_by_username(session['sesh_example'])
  end
  
  erb :index
end

get '/index' do
  if session['sesh_example']
    @user = Sesh.dbi.get_user_by_username(session['sesh_example'])
  end
  
  erb :index
end

get '/signin' do
  erb :signin
end

post '/signin' do
  # This handles the issue of blank inputs on Signin page
  if params['username'].empty? or params['password'].empty?
    flash[:alert] = "Blank inputs!"
    redirect to '/signin'
  end

  user = Sesh.dbi.get_user_by_username(params['username'])
  if user && user.has_password?(params['password'])
    session['sesh_example'] = user.username
    redirect to '/'
  else
    flash[:alert] = "THAT'S NOT THE RIGHT PASSWORD!!!!"
    redirect to 'signup'
  end
end

get '/signup' do
  erb :signup
end

post '/signup' do
  # This handles issue of blank inputs for sign-up
  if params['username'].empty? or params['password'].empty? or params['password-confirm'].empty?
    flash[:alert] = "Blank inputs!"
    redirect to '/signup'
  end

  # This handles the issue of two identical users
  if Sesh.dbi.username_exists?(params['username'])
    flash[:alert] = "Username already exists! Use a different username."
  elsif params['password'] == params['password-confirm']
    user = Sesh::User.new(params['username'])
    user.update_password(params['password'])
    Sesh.dbi.persist_user(user)
    session['sesh_example'] = user.username
    redirect to '/'
    # erb :signin ----> remove, not necessary
  else
    flash[:alert] = "Your passwords don't match. Please check your passwords."
    redirect to '/signup'
  end
end

get '/signout' do
  session.clear
  redirect to '/'
end
