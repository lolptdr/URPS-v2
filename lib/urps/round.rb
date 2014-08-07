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





      @db.exec(%q[
        CREATE TABLE IF NOT EXISTS rounds(
          id serial NOT NULL PRIMARY KEY,
          matches_id integer REFERENCES matches(id),
          status text,
          player1 integer REFERENCES matches(player1),
          player2 integer REFERENCES matches(player2),
          player1move text,
          player2move text,
          result text,
          created_at timestamp NOT NULL DEFAULT current_timestamp
        )])