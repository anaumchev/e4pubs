note
	manual_inv: True
	false_guards: True

frozen class
	GAME

create
	make

feature {NONE} -- Initialization

	make (n: INTEGER)
			-- Create a game with `n' players.
		note
			status: creator
		require
			n_in_bounds: Min_player_count <= n and n <= Max_player_count
		local
			i: INTEGER
			p: PLAYER
		do
			create players.make (1, n)
			from
				i := 1
			invariant
				players.is_fully_writable and players.is_wrapped
				inv_only ("players_bounds")
				players.observers.is_empty
				1 <= i and i <= players.count + 1
				across 1 |..| (i-1) as k all
					players.sequence[k] /= Void and
					players.sequence[k].is_wrapped and
					players.sequence[k].is_fresh and
					players.sequence[k].position = 1
				end
				across 1 |..| (i-1) as j all
					across 1 |..| (i-1) as k all
						j /= k implies players.sequence[j] /= players.sequence[k] end end

				modify (players)
			until
				i > players.count
			loop
				create p.make ("Player" + i.out_)
				p.set_position (1)
				players [i] := p
				check p.inv_only ("name_not_void", "owns_def") end
				print (p.name + " joined the game.%N")
				i := i + 1
			end
			print ("%N")

			create die_1.roll
			create die_2.roll
		ensure
			not_yet_played: winner = Void
			fair_start: across players.sequence as o all o.position = 1 end
		end

feature -- Basic operations

	play
			-- Start a game.
		require
			not_yet_played: winner = Void
			fair_start: across players.sequence as o all o.position = 1 end
		local
			round, i: INTEGER
		do
			from
				round := 1
				print ("The game begins.%N")
				print_board
			invariant
				players.sequence = players.sequence.old_
				inv_only("players_bounds", "owns_def")
				across owns as o all o.is_wrapped end
				across owns as o all o.is_fully_writable end
				players.inv_only ("lower_definition", "upper_definition")

				is_winner: winner /= Void implies winner.position > Square_count
				has_winner: winner /= Void implies players.sequence.has (winner)

				decreases ([])
			until
				winner /= Void
			loop
				check players.is_wrapped end
				print ("%NRound #" + round.out_ + "%N%N")
				from
					i := 1
				invariant
					players.sequence = players.sequence.old_
					inv_only("players_bounds", "owns_def")
					across owns as o all o.is_wrapped end
					across owns as o all o.is_fully_writable end
					players.inv_only ("lower_definition", "upper_definition")

					1 <= i and i <= players.count + 1
					is_winner: winner /= Void implies winner.position > Square_count
					has_winner: winner /= Void implies players.sequence.has (winner)
				until
					winner /= Void or else i > players.count
				loop
					players [i].play (die_1, die_2)
					if players [i].position > Square_count then
						winner := players [i]
					end
					i := i + 1
				variant
					players.count - i
				end
				print_board
				round := round + 1
			end
		ensure
			modify_field (["closed", "winner"], Current)
			players.sequence = old players.sequence
			is_winner: winner.position > Square_count
			has_winner: winner /= Void and players.sequence.has (winner)
		end

feature -- Constants

	Min_player_count: INTEGER = 2
			-- Minimum number of players.

	Max_player_count: INTEGER = 6
			-- Maximum number of players.

	Square_count: INTEGER = 40
			-- Number of squares.

feature -- Access

	players: V_ARRAY [PLAYER]
			-- Container for players.

	die_1: DIE
			-- The first die.

	die_2: DIE
			-- The second die.

	winner: PLAYER
			-- The winner (Void if the game if not over yet).

feature {NONE} -- Implementation

	print_board
			-- Output players positions on the board.
		require
			inv_only("players_bounds", "owns_def")
			players.inv_only ("lower_definition", "upper_definition")
			across owns as o all o.is_wrapped end
		local
			i, j: INTEGER
			board: V_STRING
		do
			io.put_new_line
			board := "."
			board.multiply (Square_count)
			print (board)
			io.put_new_line
			from
				i := 1
			until
				i > players.count
			loop
				from
					j := 1
				until
					j >= players [i].position
				loop
					print (" ")
					j := j + 1
				end
				print (i.out_)
				io.put_new_line
				i := i + 1
			end
		ensure
			modify ([])
		end

invariant
	dice_exist: die_1 /= Void and die_2 /= Void
	players_exist: players /= Void
	owns_players: owns.has (players) -- needed to be able to read `players.sequence' in next line
	owns_def: owns = {MML_SET [ANY]}[players.sequence.range] & players & die_1 & die_2
	players_bounds: players.lower_ = 1 and Min_player_count <= players.sequence.count and players.sequence.count <= Max_player_count
	players_nonvoid: players.sequence.non_void
	players_distinct: players.sequence.no_duplicates

end
