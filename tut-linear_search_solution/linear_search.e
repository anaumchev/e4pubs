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
				not a.sequence.interval (Result + 1, a.count).has (value)
			until
				Result = 0 or else a[Result] = value
			loop
				Result := Result - 1
			variant
				Result
			end
		ensure
			present: a.sequence.has (value) = (Result > 0)
			not_present: not a.sequence.has (value) = (Result = 0)
			found_if_present: Result > 0 implies a.sequence[Result] = value
			first_from_back: across (Result+1) |..| a.count as i all a.sequence[i] /= value end
		end

feature -- Alternative encoding of loop invariant

	linear_search_alt (a: SIMPLE_ARRAY [INTEGER]; value: INTEGER): INTEGER
			-- Index of `value' in `a' using linear search starting from end of array.
			-- https://en.wikipedia.org/wiki/Linear_search#Searching_in_reverse_order
		do
			from
				Result := a.count
			invariant
				across (Result+1) |..| a.count as i all a.sequence[i] /= value end
			until
				Result = 0 or else a[Result] = value
			loop
				Result := Result - 1
			variant
				Result
			end
		ensure
			present: a.sequence.has (value) = (Result > 0)
			not_present: not a.sequence.has (value) = (Result = 0)
			found_if_present: Result > 0 implies a.sequence[Result] = value
			first_from_back: across (Result+1) |..| a.count as i all a.sequence[i] /= value end
		end

end
