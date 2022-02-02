note
	description: "This example illustrates ownership."

class
	COUNTER

create
	make

feature -- Specification

	value: INTEGER
			-- Abstract representation.
		note
			status: ghost
		attribute
		end

feature {NONE} -- Representation

	cell: V_CELL [INTEGER]
			-- Concrete representation:
			-- the value is stored in a cell, which is owned by the coutner.


feature -- Operations

	make (init_value: INTEGER)
			-- Create a new counter that stores `init_value'.
		note
			status: creator
		require
			non_negative: 0 <= init_value
		do
			create cell.put (init_value)
		ensure
			value_set: value = init_value
		end

	inc
			-- Increase the value of the counter.
		do
			if cell.item \\ 2 = 0 then
				cell.put (cell.item + 1)
			else
				create cell.put (cell.item + 1)
			end
			-- `owns' and `value' are assigned automatically here
		ensure
			value_increased: value > old value
		end

--	inc_explicit
--			-- To see what inc looks like without default annotations,
--			-- uncomment this method and the note clause at the end of the class.
--		note
--			explicit: contracts, wrapping
--		require
--			wrapped: is_wrapped -- Current is closed and free (not owned)
--			modify (Current) -- permission to modify Current and its ownership domain
--		do
--			unwrap -- open up Current, `cell' becomes wrapped
--			if cell.item \\ 2 = 0 then
--				cell.put (cell.item + 1)
--			else
--				create cell.put (cell.item + 1)
--				Current.owns := [cell] -- the `owns' set has changed in this case
--			end
--			value := value + 1
--			wrap -- close Current provided its invariant holds and all objects in its owns set are wrapped
--		ensure
--			value_increased: value > old value
--			wrapped: is_wrapped -- Current is closed and free again
--		end

	havoc
			-- This method has no postcondition, but clients can still rely on the invariant.
		do
			cell.put (42)
		end

invariant
	value_non_negative: value >= 0
	cell_non_void: cell /= Void
	owns_definition: owns = [cell] -- describing the ownership structure
	value_definition: value = cell.item -- made admissible by the previous clause

--note
--	explicit: value, owns

end
