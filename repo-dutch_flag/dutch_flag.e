note
	description: "Dutch flag sorting algorithm on arrays."

class
	DUTCH_FLAG

feature -- Flag sort

	flag_sort (a: SIMPLE_ARRAY [CHARACTER]): TUPLE [b, r: INTEGER]
			-- Sorts array `a' which consists only of elements 'b', 'w', and 'r' according to the Dutch flag.
			-- https://en.wikipedia.org/wiki/Dutch_national_flag_problem
		note
			status: impure
		require
			three_values: across a.sequence.domain as ai all a[ai.item]='b' or a[ai.item]='w' or a[ai.item]='r' end
			no_overflow: a.count < {INTEGER}.max_value

			modify (a)
		local
			b, i, r: INTEGER
		do
			from
				b := 1
				i := 1
				r := a.count
			invariant
				a_wrapped: a.is_wrapped
				three_values: across a.sequence.domain as ai all a[ai.item]='b' or a[ai.item]='w' or a[ai.item]='r' end
				is_permutation: a.sequence.to_bag = a.sequence.old_.to_bag
				b_in_range: 1 <= b and b <= i and b <= r + 1
				i_in_range: 1 <= i and i <= r + 1
				r_in_range: 0 <= r and r <= a.count
				blue_first: across 1 |..| (b-1) as ai all a.sequence[ai.item] = 'b' end
				white_second: across b |..| (i-1) as ai all a.sequence[ai.item] = 'w' end
				red_last: across (r+1) |..| a.count as ai all a.sequence[ai.item] = 'r' end
			until
				i > r
			loop
				if a[i] = 'b' then
					swapc (a, b, i)
					b := b + 1
					i := i + 1
				elseif a[i] = 'w' then
					i := i + 1
				else
					check a[i] = 'r' end
					swapc (a, r, i)
					r := r - 1
				end
			end
			Result := [b, r]
		ensure
			blue_before_red: Result.b <= Result.r + 1
			blue_first: across 1 |..| (Result.b-1) as ai all a.sequence[ai.item] = 'b' end
			white_second: across Result.b |..| Result.r as ai all a.sequence[ai.item] = 'w' end
			red_last: across (Result.r+1) |..| a.count as ai all a.sequence[ai.item] = 'r' end
			is_permutation: a.sequence.to_bag = old a.sequence.to_bag
		end

feature -- Three way partition

	three_way_partition (a: SIMPLE_ARRAY [INTEGER]; pivot, lower, upper: INTEGER): TUPLE [left: INTEGER; right: INTEGER]
			-- Partition array `a' in the range `lower' to `upper' according to `pivot'.
			-- https://en.wikipedia.org/wiki/Dutch_national_flag_problem
		note
			status: impure
		require
			lower_bounds: 1 <= lower and lower <= upper
			upper_bounds: upper <= a.count
			no_overflow: a.count < {INTEGER}.max_value - 1

			modify (a)
		local
			i, j, k: INTEGER
		do
			from
				i := lower
				j := lower
				k := upper
			invariant
				a.is_wrapped
				lower <= i and i <= j
				lower <= j and j <= k + 1
				j - 1 <= k and k <= upper

				across lower |..| (i-1) as ai all a.sequence[ai.item] < pivot end
				across i |..| (j-1) as ai all a.sequence[ai.item] = pivot end
				across (k+1) |..| upper as ai all a.sequence[ai.item] > pivot end

				is_permutation (a.sequence, a.sequence.old_)
				a.sequence.front (lower - 1) ~ a.sequence.old_.front (lower - 1)
				a.sequence.tail (upper + 1) ~ a.sequence.old_.tail (upper + 1)
			until
				j > k
			loop
				if a[j] < pivot then
					swap (a, i, j)
					i := i + 1
					j := j + 1
				elseif a[j] > pivot then
					swap (a, j, k)
					k := k - 1
				else
					j := j + 1
				end
			end
			Result := [i - 1, k + 1]
		ensure
			left_bounds: lower - 1 <= Result.left and Result.left <= upper
			right_bounds: lower <= Result.right and Result.right <= upper + 1
			left_right_relation: Result.left <= Result.right + 1

			smaller_left: across lower |..| Result.left as ai all a.sequence[ai.item] < pivot end
			pivots_middle: across (Result.left+1) |..| (Result.right-1) as ai all a.sequence[ai.item] = pivot end
			larger_right: across Result.right |..| upper as ai all a.sequence[ai.item] > pivot end

			permutation: is_permutation (a.sequence, old a.sequence)
			unchanged_left: a.sequence.front (lower - 1) ~ old a.sequence.front (lower - 1)
			unchanged_right: a.sequence.tail (upper + 1) ~ old a.sequence.tail (upper + 1)
		end

feature -- Helper

	swapc (a: SIMPLE_ARRAY [CHARACTER]; i, j: INTEGER)
			-- Swap elements `i' and `j' of array `a'.
		note
			explicit: wrapping
		require
			i_in_range: 1 <= i and i <= a.count
			j_in_range: 1 <= j and j <= a.count

			modify (a)
		local
			t: CHARACTER
		do
			t := a[i]
			a[i] := a[j]
			a[j] := t
		ensure
			swapped: a.sequence = (old a.sequence).replaced_at (i, (old a.sequence[j])).replaced_at (j, (old a.sequence[i]))
			is_permutation: a.sequence.to_bag = old a.sequence.to_bag
		end

	swap (a: SIMPLE_ARRAY [INTEGER]; i, j: INTEGER)
			-- Swap elements `i' and `j' of array `a'.
		note
			explicit: wrapping
		require
			i_in_range: 1 <= i and i <= a.count
			j_in_range: 1 <= j and j <= a.count

			modify (a)
		local
			t: INTEGER
		do
			t := a[i]
			a[i] := a[j]
			a[j] := t
		ensure
			swapped: a.sequence ~ old (a.sequence.replaced_at (i, a.sequence[j]).replaced_at (j, a.sequence[i]))
			is_permutation: a.sequence.to_bag ~ old a.sequence.to_bag
		end

	is_permutation (s1, s2: MML_SEQUENCE [INTEGER]): BOOLEAN
			-- Are `s1' and `s2' permutations of each other?
		note
			status: functional, ghost
		do
			Result := s1.to_bag ~ s2.to_bag and s1.count = s2.count
		end

end
