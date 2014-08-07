module Arena
  class Rounds
    attr_reader :p1move, :p2move, :result
       
    def initialize(p1move, p2move, result)
      @status = status
      @p1move = p1move
      @p2move = p2move
      @result = result
    end
  end
end