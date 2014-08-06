module Arena
  class Game
    attr_reader , :id, :created_at
    
    def initialize(matches_id, status, opponent, p1move, p2move, result, id=nil, created_at=nil)
      @matches_id = matches_id
      @status = status
      @opponent = opponent
      @p1move = p1move
      @p2move = p2move
      @id = id
      @created_at = created_at
    end
  end
end