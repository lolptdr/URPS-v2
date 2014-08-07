require 'sinatra'
require 'rack-flash'
require_relative 'lib/sesh.rb'


set :bind, '0.0.0.0' 
set :sessions, true
use Rack::Flash

get '/' do
  # Splash page
  erb :index
end

get '/signup' do
  # signup page
  erb :signup
end

post '/signup' do
  # "Create Account" button
  redirect to '/control_panel'
end

get '/signin' do
  # signin page
  erb :signin
end

post '/signin' do
  # "Login" button
  redirect to '/control_panel'
end

get '/control_panel' do
  # Control Panel page
  erb :control_panel
end

get '/arena' do
  # Arena page
  erb :arena
end
