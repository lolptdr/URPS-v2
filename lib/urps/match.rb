module Arena
  class Match
    attr_reader :id, :created_at
    
    def initialize(game, status="waiting", opponent="pending", id=nil, created_at=nil)
      @game = game
      @status = status
      @opponent = opponent
      @id = id
      @created_at = created_at
    end
  end
end