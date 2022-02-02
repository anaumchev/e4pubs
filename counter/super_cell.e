note
	description: "This example shows more advanced mechanisms: obsevers and update guards."

frozen class
	SUPER_CELL

create
	make

feature -- Access

	item: INTEGER
			-- This field is guarded by the `insreases' predicate defined below:
			-- Current reserves a right to increase `item' without notifying observers,
			-- so their invariants better not be affected by such a change.
		note
			guard: increases
		attribute
		end

feature -- Replacement

	make (v: INTEGER)
			-- Create a new cell that stores `v'.
		note
			status: creator
		do
			item := v
		ensure
			item = v
		end

	put (v: INTEGER)
			-- The contract is vague on purpose, to showcase invariant reasoning in the client.
		require
			at_least_item: v >= item -- without this precondition, the body could invalidate the observers
		do
			item := v
		ensure
			at_least_v: item <= v
		end

feature -- Specification

	increases (new_item: INTEGER; o: ANY): BOOLEAN
			-- Definition of the update guard for `item';
			-- can depend on the current state, the new value for `item'
			-- and an individual observer (not used here).
		note
			status: functional, ghost
		do
			Result := new_item >= item
		end

note
	explicit: observers

end
