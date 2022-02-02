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
			create board.make
			create players.make (1, n)
			from
				i := 1
			invariant
				players.is_fully_writable and players.is_wrapped
				players.inv_only ("lower_definition", "upper_definition")
				players.lower = 1 and players.upper = n and players.observers = []
				board.inv_only ("squares_exists", "squares_bounds")

				1 <=  i and i <= players.count + 1
				across 1 |..| (i-1) as k all
					players.sequence[k.item].is_wrapped and
					players.sequence[k.item].is_fresh and
					players.sequence[k.item].position = board.squares.lower and
					players.sequence[k.item].money = Initial_money and
					players.sequence[k.item].board = board
				end
				across 1 |..| (i-1) as j all
					across 1 |..| (i-1) as k all
						j.item /= k.item implies players.sequence[j.item] /= players.sequence[k.item] end end

				modify (players)
			until
				i > players.count
			loop
				create p.make ("Player" + i.out_, board)
				p.transfer (Initial_money)
				players [i] := p
				check p.inv_only ("owns_def", "name_not_void") end
				print (p.name + " joined the game.%N")
				i := i + 1
			end
			create die_1.roll
			create die_2.roll
			create {V_LINKED_LIST [PLAYER]} winners
		ensure
			not_yet_playerd: winners.sequence.is_empty
			fair_start: across players.sequence as o all o.item.position = board.squares.lower end
			fair_money: across players.sequence as o all o.item.money = Initial_money end
		end

feature -- Basic operations

	play
			-- Start a game.
		require
			not_yet_playerd: winners.sequence.is_empty
			fair_start: across players.sequence as o all o.item.position = board.squares.lower end
			fair_money: across players.sequence as o all o.item.money = Initial_money end
		local
			round, i: INTEGER
		do
			from
				round := 1
				print ("The game begins.%N")
				print_board
			invariant
				inv_only("players_bounds", "owns_def", "players_nonvoid", "players_on_board", "no_observers")
				across owns as o all o.item.is_wrapped end
				players.inv_only ("lower_definition", "upper_definition")

				across winners.sequence as o all players.sequence.has (o.item) end
				across winners.sequence as o all o.item.is_wrapped end

				modify (players.sequence, winners, die_1, die_2)
				decreases ([])
			until
				not winners.is_empty
			loop
				print ("%NRound #" + round.out_ + "%N%N")
				from
					i := 1
				invariant
					inv_only("players_bounds", "owns_def", "players_nonvoid", "players_on_board", "no_observers")
					across owns as o all o.item.is_wrapped end
					players.inv_only ("lower_definition", "upper_definition")

					1 <= i and i <= players.sequence.count + 1

					across winners.sequence as o all players.sequence.has (o.item) end
					across winners.sequence as o all o.item.is_wrapped end

					modify (players.sequence, winners, die_1, die_2)
				until
					not winners.is_empty or else i > players.count
				loop
					players [i].play (die_1, die_2)
					if players [i].position > board.Square_count then
						select_winners
					end
					i := i + 1
				variant
					players.sequence.count - i
				end
				print_board
				round := round + 1
			end
		ensure
			has_winners: winners /= Void and then not winners.is_empty
			winners_are_players: across winners.sequence as o all players.sequence.has (o.item) end
		end

feature -- Constants

	Min_player_count: INTEGER = 2
			-- Minimum number of players.

	Max_player_count: INTEGER = 6
			-- Maximum number of players.

	Initial_money: INTEGER = 7
			-- Initial amount of money of each player.

feature -- Access

	board: BOARD
			-- Board.

	players: V_ARRAY [PLAYER]
			-- Container for players.

	die_1: DIE
			-- The first die.

	die_2: DIE
			-- The second die.

	winners: V_LIST [PLAYER]
			-- Winners (Void if the game if not over yet).

feature {NONE} -- Implementation

	select_winners
			-- Put players with most money into `winners'.
		require
			inv_only("players_bounds", "players_nonvoid")
			players.is_wrapped
			winners.is_wrapped and winners.observers = []
			across players.sequence as o all o.item.is_wrapped end
			winners.sequence.is_empty

			modify (winners)
		local
			i, max: INTEGER
		do
			from
				check players.inv_only ("lower_definition", "upper_definition") end
				winners.extend_back (players [1])
				max := players[1].money
				i := 2
			invariant
				winners.is_wrapped and winners.observers = []
				inv_only("players_bounds", "players_nonvoid")
				players.inv_only ("lower_definition", "upper_definition")

				not winners.sequence.is_empty
				across winners.sequence as o all players.sequence.has (o.item) end

				2 <= i and i <= players.sequence.count + 1
			until
				i > players.count
			loop
				if players [i].money > max then
					max := players [i].money
					winners.wipe_out
					winners.extend_back (players [i])
				elseif players [i].money = max then
					winners.extend_back (players [i])
				end
				i := i + 1
			end
		ensure
			is_wrapped: winners.is_wrapped
			has_winners: not winners.sequence.is_empty
			winners_are_players: across winners.sequence as o all players.sequence.has (o.item) end
			no_observers: winners.observers = []
		end

 	print_board
			-- Output players positions on the board.
		require
			inv_only("players_bounds", "owns_def")
			players.inv_only ("lower_definition", "upper_definition")
			across owns as o all o.item.is_wrapped end
			modify ([])
		local
			i, j: INTEGER
		do
			io.put_new_line
			print (board.out_)
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
		end

invariant
	dice_exist: die_1 /= Void and die_2 /= Void
	board_exists: board /= Void
	players_exist: players /= Void
	winners_exist: winners /= Void
	owns_players: owns.has (players)
	owns_def: owns = {MML_SET [ANY]}[players.sequence.range] + [players, winners, board, die_1, die_2]
	players_bounds: players.lower = 1 and Min_player_count <= players.sequence.count and players.sequence.count <= Max_player_count
	players_on_board: across players.sequence as o all o.item.board = board end
	players_nonvoid: players.sequence.non_void
	players_distinct: players.sequence.no_duplicates
	no_observers: winners.observers = []

end
