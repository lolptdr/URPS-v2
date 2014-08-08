require 'pry-byebug'
require 'pg'
require 'time'

module Arena
	class DBI
		def initialize
			@db = PG.connect(host: 'localhost', dbname: 'urps')
			build_tables
		end

		def build_tables
			@db.exec(%q[
				CREATE TABLE IF NOT EXISTS users(
					id serial NOT NULL PRIMARY KEY,
					username varchar(30),
					password_digest varchar(50),
					created_at timestamp NOT NULL DEFAULT current_timestamp
				)])

			@db.exec(%q[
				CREATE TABLE IF NOT EXISTS matches(
					id serial NOT NULL PRIMARY KEY,
					player1 integer REFERENCES users(id),
					player1_win_count integer,
					round integer,
					status text NULL DEFAULT ('Your move'),
					player2 integer REFERENCES users(id),
					player2_win_count integer,
					created_at timestamp NOT NULL DEFAULT current_timestamp
				)])

			@db.exec(%q[
				CREATE TABLE IF NOT EXISTS rounds(
					id serial NOT NULL PRIMARY KEY,
					match_id integer REFERENCES matches(id),
					status text,
					player1 integer REFERENCES users(id),
					player2 integer REFERENCES users(id),
					player1move text,
					player2move text,
					result text,
					created_at timestamp NOT NULL DEFAULT current_timestamp
				)])

			@db.exec(%q[
				CREATE TABLE IF NOT EXISTS stats(
					id serial NOT NULL PRIMARY KEY,
					user_id integer REFERENCES users(id),
					total_matches integer,
					match_wins integer,
					match_losses integer,
					round_wins integer,
					round_losses integer,
					round_ties integer,
					favorite_move text,
					highest_winning_move_vs_opponent text,
					highest_losing_move_vs_opponent text,
					percent_rock double precision,
					percent_paper double precision,
					percent_scissors double precision,
					created_at timestamp NOT NULL DEFAULT current_timestamp
				)])
		end
	##############################
	# Methods for Login and User #
	##############################
		def persist_user(user)
      @db.exec_params(%q[ 
      	INSERT INTO users (username, password_digest)
      	VALUES ($1,$2);
      	], [user.username, user.password_digest])

      # result.first["id"]
    end

		def get_user_by_username(username)
		  result = @db.exec(%q[
		    SELECT * FROM users WHERE username = $1;
		  ], [username])

		  user_data = result.first
		  if user_data
		    build_user(user_data)
		  else
		    nil
		  end
		end

		def get_id_by_username(username)
			result = @db.exec(%[
				SELECT * FROM users WHERE username = $1;
				], [username])

			result = result.first['id']
		end

		def get_username_by_id(id)
			result = @db.exec(%[
				SELECT * FROM users WHERE id = $1;
				], [id])

			results = result.first['username']
		end

		def username_exists?(username)
		  result = @db.exec(%q[
		    SELECT * FROM users WHERE username = $1;
			], [username])

		  if result.count > 1
		    true
		  else
		    false
		  end
		end

		def build_user(data)
		  Arena::User.new(data['username'], data['password_digest'], data['id'].to_i)
		end

	#####################
	# Methods for Match #
	#####################
		def persist_match(match)
			@db.exec_params(%q[
				INSERT INTO matches (player1, player2, status, opponent)
				VALUES ($1, $2, $3);
				], [match.user_id, match.status, match.opponent])
		end

		def link_match_to_user(id)
			result = @db.exec_params(%q[
				SELECT * FROM matches INNER JOIN users ON matches.match_id = users.id;
				])
		end
		def create_match(player1, player2=nil)
      result = @db.exec_params(%q[
      	INSERT INTO matches (player1, player1_win_count, player2_win_count)
      	VALUES ($1,$2,$3) RETURNING id;], [player1,0,0])

      result.first['id']
    end

    def find_open_match_to_id
    	result = @db.exec(%q[
				SELECT * FROM matches WHERE player2 IS NULL
				AND status != 'done';])
    	result2 = result.map { |row| row["id"] }
    end

    def find_open_match
    	result = @db.exec(%q[
    		SELECT * FROM matches WHERE player2 IS NULL
    		AND status != 'done';])
    	result2 = result.map do |row| 
    		{ :id => row["id"], :player1 => row["player1"], :player_1_win_count => row["player1_win_count"],
    			:round => row["round"], :status => row["status"], :player2 => row["player2"],
    			:player2_win_count => row["player2_win_count"], :created_at => row["created_at"] }
    	end

    	output = result2.each

    	# output = result2.map { |x| Arena.dbi.get_username_by_id(x[1]) }
    end

   	def find_match_host_name_in_open_matches(player1)
   		results = @db.exec(%q[
				SELECT * FROM matches WHERE player1 = $1;
   			], [player1])

   	end

		def get_match_by_user_id(user_id)
			result = @db.exec(%q[
				SELECT * FROM matches WHERE user_id = $1;
			], [user_id])

			match_data = result.first
			if match_data
				build_match(match_data)
			else
				nil
			end
		end

		def match_exists?(id)
		  result = @db.exec(%q[
		    SELECT * FROM users WHERE username = $1;
			], [username])

		  if result.count > 1
		    true
		  else
		    false
		  end
		end

		def build_match(data)
			Arena::Match.new(data['player1'], data['player1_win_count'], data['player2'], data['player2_win_count'])
		end


    def check_match_status(match_id)
      @db.exec("SELECT * from matches WHERE id = #{match_id}")
    end

    def delete_match(id)
    	@db.exec_params(%q[
    		DELETE FROM matches
    		where ID = $1;
    		], [id])
    end

		#####################
		# Methods for Round #
		#####################
		def persist_round(round)
			@db.exec_params(%q[
				INSERT INTO rounds (status, player1move, player2move, result)
				VALUES ($1, $2, $3, $4);
				], [round.status, round.player1move, round.player2move, round.result])
		end

		def get_latest_round_by_match_id(match_id)
			result = @db.exec(%q[
				SELECT * FROM rounds WHERE match_id = '#{match_id}';
			])

			round_data = result.last
			if round_data
					build_match(round_data)
			else
				nil
			end
		end

		def build_round(data)
			Arena::Round.new(data['status'], data['player1move'], data['player2move'], result)
		end

	end
	def self.dbi
	  @__db_instance ||= DBI.new
	end
end


