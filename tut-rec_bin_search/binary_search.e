note
	description: "Binary search on integer arrays."

class
	BINARY_SEARCH

feature -- Basic operations

	binary_search (a: SIMPLE_ARRAY [INTEGER]; value: INTEGER): INTEGER
			-- Index of `value' in `a' using binary search. Return 0 if not found.
			-- https://en.wikipedia.org/wiki/Binary_search_algorithm#Iterative
		require
			-- TASK 1: Add specification.
		local
			low, up, middle: INTEGER
		do
			if a.count > 0 then
				Result := binary_search_recursive_step (a, value, 1, a.count)
			else
				Result := 0
			end
		ensure
			-- TASK 1: Add specification.
		end

	binary_search_recursive_step (a: SIMPLE_ARRAY [INTEGER]; value, lower, upper: INTEGER): INTEGER
			-- Index of `value' in `a' between indexes `lower' and `upper'.
		require
			-- TASK 2: Add precondition.
			-- TASK 3: Add decreases clause.
		local
			mid: INTEGER
		do
			if lower > upper then
				Result := 0
			else
				mid := lower + (upper - lower) // 2
				if a[mid] = value then
					Result := mid
				elseif a[mid] > value then
					Result := binary_search_recursive_step (a, value, lower, mid - 1)
				else
					Result := binary_search_recursive_step (a, value, mid + 1, upper)
				end
			end
		ensure
			-- TASK 4: Add postcondition.
		end

end
