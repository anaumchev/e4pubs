class
	CLIENT

feature -- Test

	test
			-- Testing ownership.
		local
			counter: COUNTER
		do
			-- The client is completely oblivious of `counter.cell'
			-- and reasons about the counter as if it were implemented
			-- using `counter.value':

			create counter.make (23)
			counter.inc
			counter.inc
			check counter.value >= 25 end

			counter.havoc
			check counter.value >= 0 end
		end

	super_test
			-- Testing collaboration.
		local
			cell: SUPER_CELL
			counter1, counter2: SUPER_COUNTER
		do
			-- Here two coutners are observing the same cell:
			create cell.make (0)

			create counter1.make (cell)
			create counter2.make (cell)

			cell.put (5)
			cell.put (23)

			-- Semantic collaboration guarantees
			-- that as long as there's a closed counter around `cell.item' will be non-negative,
			-- even though `cell' knows nothing about that:
			check counter1.inv end
			check cell.item >= 0 end
		end

end
