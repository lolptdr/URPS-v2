module Arena
end

module Sesh
end

require_relative 'urps/dbi.rb'
require_relative 'urps/userrps.rb'
# Not necessary since combined into one 'dbi.rb' file:
# require_relative 'sesh/databases/dbi.rb'
require_relative 'sesh/entities/user.rb'