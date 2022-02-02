class
	APPLICATION

create
	make

feature

	make
			-- Launch the application.
		note
			status: creator
			explicit: wrapping, contracts
		local
			count : INTEGER
			game: GAME
		do
			from
				count := {GAME}.Min_player_count - 1
			invariant
				decreases ([])
			until
				{GAME}.Min_player_count <= count and count <= {GAME}.Max_player_count
			loop
				print ("Enter number of players between " + {GAME}.Min_player_count.out_ + " and " + {GAME}.Max_player_count.out_ + ": ")
				io.read_integer
				count := io.last_integer
			end

			create game.make (count)
			game.play
			check game.winner.inv end
			print ("%NAnd the winner is: " + game.winner.name)
			print ("%N*** Game Over ***")
		end

end
