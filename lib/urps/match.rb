module  Arena
 class Match
   attr_accessor :player1, :player2, :player1_win_count, :player2_win_count, :match_id

   def initialize(player1, player2=nil, match_id)
    @player1 = player1
    @player2 = player2
    @player1_win_count = 0
    @player2_win_count = 0
    @total_games = 0
    @match_id = match_id
   end
 end
end