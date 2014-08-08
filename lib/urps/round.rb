module Arena
  class Rounds
    attr_accessor :player1move, :player2move, :status, :result

    def initialize(player1move, match_id)
      @player1move = player1move
      @player2move = nil
      @status = status
      @result = nil
      @match_id = match_id
    end

    def play(player2move)
    end
  end
end