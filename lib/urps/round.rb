module Arena
  class Round
    attr_accessor :player1move, :player2move, :status, :result

    def initialize(player1move, player2move, match_id)
      @player1move = player1move
      @player2move = player2move
      @status = status
      @result = nil
      @match_id = match_id
    end

    # def play(player1move, player2move)
    # end
  end
end