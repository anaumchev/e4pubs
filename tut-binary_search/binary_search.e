note
	description: "Binary search on integer arrays."

class
	BINARY_SEARCH

feature -- Basic operations

	binary_search (a: SIMPLE_ARRAY [INTEGER]; value: INTEGER): INTEGER
			-- Index of `value' in `a' using binary search. Return 0 if not found.
			-- https://en.wikipedia.org/wiki/Binary_search_algorithm#Iterative
		require
			-- TASK 3: Add precondition to require input arrays to be sorted.
		local
			low, up, middle: INTEGER
		do
			from
				low := 1
				up := a.count + 1
			invariant
				-- TASK 1: Add loop invariants to validate array accesses.
				-- TASK 5: Add loop invariants to prove postcondition.
			until
				low >= up or Result > 0
			loop
				middle := low + ((up - low) // 2)
				if a[middle] < value then
					low := middle + 1
				elseif a[middle] > value then
					up := middle
				else
					Result := middle
				end
			variant
				0 -- TASK 2: Add loop variant to prove termination.
			end
		ensure
			-- TASK 4: Add postconditions to verify client code.
		end

end
