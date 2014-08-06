module Arena
  class Match
    attr_reader :breed, :name, :age, :id, :created_at
    
    def initialize(game, status="waiting", opponent, id=nil, created_at=nil)
      @game = game
      @status = status
      @opponent = opponent
      @id = id
      @created_at = created_at
    end
  end
end