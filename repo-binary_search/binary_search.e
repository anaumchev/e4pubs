note
	description: "Binary search on integer arrays with both iterative and recursive versions."

class
	BINARY_SEARCH

feature -- Test harness

	test_binary_search
			-- Using binary search.
		note
			explicit: wrapping
		local
			a: SIMPLE_ARRAY [INTEGER]
			i: INTEGER
		do
			create a.init (<<-3, 5, 9, 22, 104, 105, 107, 213>>)

			i := binary_search_iterative (a, -3)
			check i = 1 end
			i := binary_search_recursive (a, 22)
			check i = 4 end
			i := binary_search_iterative (a, 56)
			check i = 0 end
			i := binary_search_recursive (a, 400)
			check i = 0 end
		end

feature -- Binary search

	binary_search_iterative (a: SIMPLE_ARRAY [INTEGER]; value: INTEGER): INTEGER
			-- Index of `value' in `a' using binary search. Return 0 if not found.
			-- https://en.wikipedia.org/wiki/Binary_search_algorithm#Iterative
		note
			status: impure
		require
			no_overflow: a.count < {INTEGER}.max_value
			a_sorted: is_sorted (a.sequence)
		local
			low, up, middle: INTEGER
		do
			from
				low := 1
				up := a.count + 1
			invariant
				low_and_up_range: 1 <= low and low <= up and up <= a.sequence.count + 1
				result_range: Result = 0 or 1 <= Result and Result <= a.sequence.count
				not_in_lower_part: across 1 |..| (low-1) as i all a.sequence[i] < value end
				not_in_upper_part: across up |..| a.sequence.count as i all value < a.sequence[i] end
				found: Result > 0 implies a.sequence[Result] = value
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
				(a.count - Result) + (up - low)
			end
		ensure
			present: a.sequence.has (value) = (Result > 0)
			not_present: not a.sequence.has (value) = (Result = 0)
			found_if_present: Result > 0 implies a.sequence[Result] = value
		end

	binary_search_recursive (a: SIMPLE_ARRAY [INTEGER]; value: INTEGER): INTEGER
			-- Index of `value' in `a' using recursive binary search. Return 0 if not found.
			-- https://en.wikipedia.org/wiki/Binary_search_algorithm#Recursive
		require
			no_overflow: a.count < {INTEGER}.max_value
			is_sorted (a.sequence)
		do
			if a.count > 0 then
				Result := binary_search_recursive_step (a, value, 1, a.count)
			else
				Result := 0
			end
		ensure
			present: a.sequence.has (value) = (Result > 0)
			not_present: not a.sequence.has (value) = (Result = 0)
			found_if_present: Result > 0 implies a.sequence[Result] = value
		end

	binary_search_recursive_step (a: SIMPLE_ARRAY [INTEGER]; value, lower, upper: INTEGER): INTEGER
			-- Index of `value' in `a' between indexes `lower' and `upper'.
		require
			no_overflow: a.count < {INTEGER}.max_value
			sorted: is_sorted (a.sequence)
			lower_in_bounds: 1 <= lower and lower <= a.count + 1
			upper_in_bounds: 0 <= upper and upper <= a.count

			decreases (upper - lower)
		local
			mid: INTEGER
		do
			if lower > upper then
				Result := 0
			else
				mid := lower + (upper - lower) // 2
				if a[mid] = value then
					Result := mid
					check a.sequence.interval (lower, upper)[mid - lower + 1] = a.sequence[mid] end
				elseif a[mid] > value then
					Result := binary_search_recursive_step (a, value, lower, mid - 1)
					check a.sequence.interval (lower, upper) ~ a.sequence.interval(lower, mid-1) + a.sequence.interval (mid, upper) end
				else
					Result := binary_search_recursive_step (a, value, mid + 1, upper)
				end
			end
		ensure
			present: a.sequence.interval(lower, upper).has (value) = (Result > 0)
			not_present: not a.sequence.interval (lower, upper).has (value) = (Result = 0)
			found_if_present: Result > 0 implies a.sequence[Result] = value
		end

feature -- Specification

	is_sorted (s: MML_SEQUENCE [INTEGER]): BOOLEAN
			-- Is `s' sorted?
		note
			status: functional, ghost
		do
			Result := across 1 |..| s.count as i all
						across 1 |..| s.count as j all
							i <= j implies s[i] <= s[j] end end
		end

end
