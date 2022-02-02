note
	description: "Linear search in integer arrays."

class
	LINEAR_SEARCH

feature -- Basic operations

	linear_search (a: SIMPLE_ARRAY [INTEGER]; value: INTEGER): INTEGER
			-- Index of `value' in `a' using linear search starting from end of array.
			-- https://en.wikipedia.org/wiki/Linear_search#Searching_in_reverse_order
		do
			from
				Result := a.count
			invariant
				-- TASK 3: Add loop invariant to prove postcondition.
			until
				Result = 0 or else a[Result] = value
			loop
				Result := Result - 1
			variant
				0 -- TASK 1: Add loop variant to prove termination.
			end
		ensure
			-- TASK 2: Add postcondition to verify client code.
		end

end
