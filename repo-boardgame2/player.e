frozen class
	PLAYER

create
	make

feature {NONE} -- Initialization

	make (n: V_STRING; b: BOARD)
			-- Create a player with name `n' playing on board `b'.
		note
			status: creator
		require
			name_exists: not n.is_empty
			board_exists: b /= Void
		do
			create name.make_from_v_string (n)
			board := b
			position := {BOARD}.Start_position
		ensure
			name_set: name.sequence = n.sequence
			board_set: board = b
			at_start: position = {BOARD}.Start_position
			broke: money = 0
		end

feature -- Access

	name: V_STRING
			-- Player name.

	board: BOARD
			-- Board on which the player in playing.			

	position: INTEGER
			-- Current position on the board.

	money: INTEGER
			-- Amount of money.

feature -- Moving

	move (n: INTEGER)
			-- Advance `n' positions on the board.
		require
			not_beyond_start: n >= {BOARD}.Start_position - position

		do
			position := position + n
		ensure
			modify_field(["closed", "position"], Current)
			position_set: position = old position + n
		end

feature -- Money

	transfer (amount: INTEGER)
			-- Add `amount' to `money'.
		do
			money := (money + amount).max (0)
		ensure
			modify_field(["closed", "money"], Current)
			money_set: money = (old money + amount).max (0)
		end

feature -- Basic operations

	play (d1, d2: DIE)
			-- Play a turn with dice `d1', `d2'.
		note
			explicit: wrapping
			manual_inv: True
		require
			board.is_wrapped

		do
			d1.roll
			d2.roll
			check d1.inv and d2.inv and inv_only ("position_not_negative", "position_valid") end
			move (d1.face_value + d2.face_value)
			check board.inv_only ("owns_def") end
			if position <= board.squares.upper then
				check board.inv_only ("squares_bounds") and board.squares.inv_only ("lower_definition", "upper_definition") end
				board.squares [position].affect (Current)
			end
			check inv_only ("owns_def", "name_not_void") end
			print (name + " rolled " + d1.face_value.out_ + " and " + d2.face_value.out_ +
				". Moves to " + position.out_ +
				". Now has " + money.out_ + " CHF.%N")
		ensure
			modify_field (["closed", "money", "position"], Current)
			modify (d1, d2)
		end

invariant
	position_not_negative: position >= 0
	money_non_negative: money >= 0
	owns_def: owns = create {MML_SET [ANY]} & name
	name_not_void: name /= Void
	name_exists: not name.sequence.is_empty
	board_exists: board /= Void
	position_valid: position >= {BOARD}.Start_position -- Token can go beyond the finish position, but not the start

end
