note
	description: "Binary search on integer arrays."

class
	BINARY_SEARCH

feature -- Basic operations

	binary_search (a: SIMPLE_ARRAY [INTEGER]; value: INTEGER): INTEGER
			-- Index of `value' in `a' using binary search. Return 0 if not found.
			-- https://en.wikipedia.org/wiki/Binary_search_algorithm#Recursive
		require
			sorted: across 1 |..| a.sequence.count as i all
						across 1 |..| a.sequence.count as j all
							i.item <= j.item implies a.sequence[i.item] <= a.sequence[j.item] end end
		do
			if a.count > 0 then
				Result := binary_search_recursive_step (a, value, 1, a.count)
			else
				Result := 0
			end
		ensure
			result_range: 0 <= Result and Result <= a.count
			present: a.sequence.has (value) = (Result > 0)
			not_present: not a.sequence.has (value) = (Result = 0)
			found_if_present: Result > 0 implies a.sequence[Result] = value
		end

	binary_search_recursive_step (a: SIMPLE_ARRAY [INTEGER]; value, lower, upper: INTEGER): INTEGER
			-- Index of `value' in `a' between indexes `lower' and `upper'.
		require
			sorted: across 1 |..| a.sequence.count as i all
						across 1 |..| a.sequence.count as j all
							i.item <= j.item implies a.sequence[i.item] <= a.sequence[j.item] end end
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
			result_range: Result = 0 or (lower <= Result and Result <= upper)
			present: a.sequence.interval(lower, upper).has (value) = (Result > 0)
			not_present: not a.sequence.interval (lower, upper).has (value) = (Result = 0)
			found_if_present: Result > 0 implies a.sequence[Result] = value
		end

feature -- Alternative encoding of postcondition

	binary_search_alt (a: SIMPLE_ARRAY [INTEGER]; value: INTEGER): INTEGER
			-- Index of `value' in `a' using binary search. Return 0 if not found.
			-- https://en.wikipedia.org/wiki/Binary_search_algorithm#Recursive
		require
			sorted: across 1 |..| a.sequence.count as i all
						across 1 |..| a.sequence.count as j all
							i.item <= j.item implies a.sequence[i.item] <= a.sequence[j.item] end end
		do
			if a.count > 0 then
				Result := binary_search_recursive_step_alt (a, value, 1, a.count)
			else
				Result := 0
			end
		ensure
            result_range: 0 <= Result and Result <= a.count
			present: (across 1 |..| a.sequence.count as i some a.sequence[i.item] = value end) = (Result > 0)
			not_present: (across 1 |..| a.sequence.count as i all a.sequence[i.item] /= value end) = (Result = 0)
			found_if_present: Result > 0 implies a.sequence[Result] = value
		end

	binary_search_recursive_step_alt (a: SIMPLE_ARRAY [INTEGER]; value, lower, upper: INTEGER): INTEGER
			-- Index of `value' in `a' between indexes `lower' and `upper'.
		require
			sorted: across 1 |..| a.sequence.count as i all
						across 1 |..| a.sequence.count as j all
							i.item <= j.item implies a.sequence[i.item] <= a.sequence[j.item] end end
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
				elseif a[mid] > value then
					Result := binary_search_recursive_step_alt (a, value, lower, mid - 1)
				else
					Result := binary_search_recursive_step_alt (a, value, mid + 1, upper)
				end
			end
		ensure
			result_range: Result = 0 or (lower <= Result and Result <= upper)
			present: (across lower |..| upper as i some a.sequence[i.item] = value end) = (Result > 0)
			not_present: (across lower |..| upper as i all a.sequence[i.item] /= value end) = (Result = 0)
			found_if_present: Result > 0 implies a.sequence[Result] = value
		end
end
