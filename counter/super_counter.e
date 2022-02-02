note
	description: "This example shows more advanced mechanisms: obsevers and update guards."

class
	SUPER_COUNTER

create
	make

feature -- Acess

	cell: SUPER_CELL
		-- Reference to the cell which we are going to observe.

feature -- Operations

	make (c: SUPER_CELL)
			-- Create a new counter observing `c'.
		note
			status: creator
		require
			non_negative: c.item >= 0
			modify (Current)
			modify_field (["observers", "closed"], c)
		do
			cell := c

			-- Now we need to add Current to `c.observers',
			-- lest we violate the implicit invariant clause
			-- that all Current's subjects know Current for an observer:
			c.unwrap
			c.observers := c.observers & Current
			c.wrap
		ensure
			cell_set: cell = c
		end

invariant
	cell_non_void: cell /= Void
	subject_definition: subjects = [cell]
--	subjects_observers_inverse: across subjects as s all s.item.observers [Current] end -- This clause is implicitly added by AutoProof;
											-- it is required to make sure that all subjects
											-- indeed take care of their observers.
	non_negative: cell.item >= 0 -- This clause is admissible because:
				-- a) `cell' is our subject and
				-- b) it cannot be violated by increasing `cell.item' (which could happen at any point due to the update guard of field `item').
end
