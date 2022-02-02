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
			count, i: INTEGER
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
			check across game.winners.sequence as o all o.item.closed end end
			if game.winners.count = 1 then
				print ("%NAnd the winner is: " + game.winners [1].name)
			else
				print ("%NAnd the winners are: ")
				from
					i := game.winners.lower
				invariant
					game.winners.lower <= i and i <= game.winners.upper + 1

					modify ([])
				until
					i > game.winners.upper
				loop
					print (game.winners [i].name + " ")
					i := i + 1
				end
			end
			print ("%N*** Game Over ***")

		end
end
