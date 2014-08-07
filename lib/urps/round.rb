module Arena
  class Rounds
    attr_accessor :player1move, :player2move, :status, :result

    def initialize(player1move, player2move, status, result)
      @player1move = player1move
      @player2move = player2move
      @status = status
      @result = result
    end
  end
end