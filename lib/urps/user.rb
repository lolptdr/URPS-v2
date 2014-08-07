require 'digest/sha1'

module Arena
 class User
   attr_reader :username, :password_digest, :user_id

   def initialize(username, password_digest, user_id=nil)
     @username = username
     @password_digest = password_digest
     # @user_id = sesh.dbi.create_user(@username,@password_digest)
   end

   def update_password(password)
     @password_digest = Digest::SHA1.hexdigest(password)
   end

   def has_password?(password)
     Digest::SHA1.hexdigest(password) == @password_digest
   end
   
 end
end