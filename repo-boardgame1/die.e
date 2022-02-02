class
	DIE

create
	roll

feature -- Access

	Face_count: INTEGER = 6
			-- Number of faces.

	face_value: INTEGER
			-- Latest value.

feature -- Basic operations

	roll
			-- Roll die.
		do
			if random = Void then
				create random
			end
			random.forth
			face_value := random.bounded_item (1, Face_count)
		end

feature {NONE} -- Implementation

	random: V_RANDOM
			-- Random sequence.

invariant
	owns_def: owns = [random]
	face_value_valid: face_value >= 1 and face_value <= Face_count

end
