class
	PLAYER

create
	make

feature {NONE} -- Initialization

	make (n: V_STRING)
			-- Create a player with name `n'.
		note
			status: creator
		require
			name_valid: n.is_wrapped
			name_exists: not n.sequence.is_empty
		do
			create name.make_from_v_string (n)
		ensure
			name_set: name.sequence = n.sequence
		end

feature -- Access

	name: V_STRING
			-- Player name.

	position: INTEGER
			-- Current position on the board.

feature -- Moving

	set_position (pos: INTEGER)
			-- Set position to `pos'.
		require
			pos_not_negative: pos >= 0
		do
			position := pos
		ensure
			position_set: position = pos
		end

feature -- Basic operations

	play (d1, d2: DIE)
			-- Play a turn with dice `d1', `d2'.
		note
			explicit: wrapping
		require
			dice_exist: d1 /= Void and d2 /= Void
			modify (Current, d1, d2)
		do
			d1.roll
			d2.roll
			set_position (position + d1.face_value + d2.face_value)
			print (name + " rolled " + d1.face_value.out_ + " and " + d2.face_value.out_ + ". Moves to " + position.out_ + ".%N")
		ensure
			position_increased: old position + {DIE}.Face_count + {DIE}.Face_count >= position and position >= old position + 2
		end

invariant
	position_not_negative: position >= 0
	name_not_void: name /= Void
	owns_def: owns = [name]
	name_exists: not name.sequence.is_empty

end
