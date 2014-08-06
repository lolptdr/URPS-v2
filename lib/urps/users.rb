module Arena
  class User
    attr_reader :p1, :p2, :id, :created_at

    def initialize(p1, p2, id=nil, created_at=nil)
      @p1 = p1
      @p2 = p2
    end

    # def play(move1, move2)
    #   move1 = move1.downcase
    #   move2 = move2.downcase
    #   raise :error if move1 != "rock" || move1 != "paper" || move1 != "scissors"
    #   raise :error if move2 != "rock" || move2 != "paper" || move2 != "scissors"
    #   if move1 == 'rock' && move2 == 'paper'
    #     @p2 += 1
    #   elsif move1 == 'rock' && move2 == 'scissors'
    #     @p1 += 1
    #   elsif move1 == 'paper' && move2 == 'rock'
    #     @p1 += 1
    #   elsif move1 == 'paper' && move2 == 'scissors'
    #     @p2 += 1
    #   elsif move1 == 'scissors' && move2 == 'rock'
    #     @p2 += 1
    #   elsif move1 == 'scissors' && move2 == 'paper'
    #     @p1 += 1
    #   else
    #     puts "Tie"
    #   end
    #   @total += 1

    #   if @p1 == 2
    #     puts "#{@p1} is the winner!"
    #   elsif @p2 == 2
    #     puts "#{@p2} is teh winner!"
    #   end
    # end
  end
end

