require 'digest/sha1'

module Arena
 class User
   attr_reader :username, :password_digest, :user_id

   def initialize(username, password_digest, user_id=nil)
     @username = username
     @password_digest = password_digest
     @user_id = user_id
   end

   def update_password(password)
     @password_digest = Digest::SHA1.hexdigest(password)
   end

   def has_password?(password)
     Digest::SHA1.hexdigest(password) == @password_digest
   end
   
 end
end


# @db.exec(%q[SELECT * FROM matches WHERE player2 IS NULL;])
# returns an array of match objects to your routes
# [MATCH, MATCH, MATCH, MATCH]

# def find_open_match
#       return result = @db.exec("SELECT * FROM matches WHERE player2 IS NULL;")
#     end

# get '/arena' do
#   @matches = dbi.find_open_match
# end

# post '/join_match/:id' do
#   match = dbi.find_match_by_id(params[:id])
#   match.player2 = current_user.id
#   dbi.update_match(match)
# end


# arena.erb

# <% @matches.each do |x| %>
#   Player name: <%= x.player1 %>
#   <a href="/join_match/<%= x.id %>">Match whatever</a>
# <% end %>







