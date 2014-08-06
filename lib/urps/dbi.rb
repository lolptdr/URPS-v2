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
					username varchar(30)
					password_digest varchar(30)
					created_at timestamp NOT NULL DEFAULT current_timestamp
				])

			@db.exec(%q[
				CREATE TABLE IF NOT EXISTS matches(
					id serial NOT NULL PRIMARY KEY,
					user_id integer REFERENCES users(id),
					game serial NOT NULL,
					status varchar(30),
					opponent varchar(30),
					created_at timestamp NOT NULL DEFAULT current_timestamp
				)])

			@db.exec(%q[
				CREATE TABLE IF NOT EXISTS games(
					id serial NOT NULL PRIMARY KEY,
					matches_id integer REFERENCES matches(id),
					status varchar(30),
					opponent varchar(30),
					p1move text,
					p2move text,
					result varchar(30),
					created_at timestamp NOT NULL DEFAULT current_timestamp
				)])

			@db.exec(%q[
				CREATE TABLE IF NOT EXISTS records(
					id serial NOT NULL PRIMARY KEY,
					user_id integer REFERENCES users(id),
					total_matches integer,
					match_wins integer,
					match_losses integer,
					game_wins integer,
					game_losses integer,
					game_ties integer,
					favorite_move text,
					highest_winning_move_vs_opponent text,
					highest_losing_move_vs_opponent text,
					%rock double precision,
					%paper double precision,
					%scissors double precision,
					created_at timestamp NOT NULL DEFAULT current_timestamp
				)])
		end
	#####################	
	# Methods for Login #
	#####################
		def persist_user(user)
		  @db.exec_params(%q[
		    INSERT INTO users (username, password_digest)
		    VALUES ($1, $2);
		  ], [user.username, user.password_digest])
		end

		def get_user_by_username(username)
		  result = @db.exec(%q[
		    SELECT * FROM users WHERE username = '#{username}';
		  ])

		  user_data = result.first
		  if user_data
		    build_user(user_data)
		  else
		    nil
		  end
		end

		def username_exists?(username)
		  result = @db.exec(%q[
		    SELECT * FROM users WHERE username = '#{username}';
		  ])

		  if result.count > 1
		    true
		  else
		    false
		  end
		end

		def build_user(data)
		  Sesh::User.new(data['username'], data['password_digest'])
		end

	######################
	# Methods for Player #
	######################
		def save_player(player)
		end

	#####################
	# Methods for Match #
	#####################
		def persist_match(match)
			@db.exec_params(%q[
				INSERT INTO matches (user_id, status, opponent)
				VALUES ($1, $2, $3);
				], [match.user_id, match.status, match.opponent])
		end

		def get_match_by_user_id(user_id)
			result = @db.exec(%q[
				SELECT * FROM matches WHERE user_id = '#{user_id}';
			])

			match_data = result.first
			if match_data
				build_match(match_data)
			else
				nil
			end
		end

		def match_exists?(game)
			result = @db.exec(%q[
				SELECT * FROM users WHERE user_id = '#{user_id}';
			])

			if result.count > 1
				true
			else
				false
			end
		end

		def build_match(data)
			Arena::Match.new(data['user_id'], data['status'], data['opponent'])
		end


	####################
	# Methods for Game #
	####################
	def persist_game()
		@db.exec_params(%q[
			INSERT INTO games (match_id, status, opponent, p1move, p2move)
			VALUES ($1, $2, $3);
			], [match.user_id, match.status, match.opponent])
	end

	def get_game_by_match_id(match_id)
		result = @db.exec(%q[
			SELECT * FROM games WHERE match_id = '#{match_id}';
		])

		game_data = result.first
		if game_data
			build_match(game_data)
		else
			nil
		end
	end

	def game_exists?(game.id)
		result = @db.exec(%q[
			SELECT * FROM games WHERE game.id = '#{game.lid}';
		])

		if result.count > 1
			true
		else
			false
		end
	end

	def build_game(data)
		Arena::Game.new(data['user_id'], data['status'], data['opponent'])
	end









		def self.dbi
		  @__db_instance ||= DBI.new
		end
	end
end
