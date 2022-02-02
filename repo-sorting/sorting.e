note
	description: "[
		Multiple algorithms for sorting of integer arrays.
		The specification covers sortedness of the output, input-output permutation,
		overflow prevention of arithmetic expressions, and (in most cases) termination.
	]"

class
	SORTING

feature -- Algorithms

	quick_sort (a: SIMPLE_ARRAY [INTEGER])
			-- Sort array `a' using quick sort.
			-- https://en.wikipedia.org/wiki/Quicksort
		note
			explicit: wrapping
		require
			no_overflow: a.count < {INTEGER}.max_value
			no_overflow: are_values_in_range (a.sequence, 1, a.count, {INTEGER}.min_value + 1, {INTEGER}.max_value - 1)

			modify (a)
		do
			if a.count > 1 then
				quick_sort_recursive_step (a, 1, a.count, {INTEGER}.min_value + 1, {INTEGER}.max_value - 1)
			end
		ensure
			sorted: is_sorted (a.sequence)
			permutation: is_permutation (a.sequence, old a.sequence)
		end

	quick_sort_recursive_step (a: SIMPLE_ARRAY [INTEGER]; lower, upper, min, max: INTEGER)
			-- Sort array `a' between `lower' and `upper' using quick sort.
			-- The array values between `lower' and `upper' are in the range from `min' to `max'.
		note
			explicit: wrapping
		require
			lower_bounds: 1 <= lower and lower <= a.count + 1
			upper_bounds: 0 <= upper and upper <= a.count
			value_bounds: are_values_in_range (a.sequence, lower, upper, min, max)
			no_overflow: a.count < {INTEGER}.max_value and min > {INTEGER}.min_value and max < {INTEGER}.max_value

			modify (a)
			decreases (max - min)
		local
			pivot: INTEGER
			partition: TUPLE [left: INTEGER; right: INTEGER]
			s1, s2, s3: MML_SEQUENCE [INTEGER]
		do
			if lower < upper then
				pivot := a[upper]
				partition := three_way_partition (a, pivot, lower, upper, min, max)
				quick_sort_recursive_step (a, lower, partition.left, min, pivot - 1)
				quick_sort_recursive_step (a, partition.right, upper, pivot + 1, max)
			end
		ensure
			finished: lower >= upper implies a.sequence ~ old a.sequence
			sorted: is_part_sorted (a.sequence, lower, upper)
			value_bounds: are_values_in_range (a.sequence, lower, upper, min, max)

			permutation: is_permutation (a.sequence, old a.sequence)
			unchanged_left: is_unchanged (a.sequence, old a.sequence, 1, lower - 1)
			unchanged_right: is_unchanged (a.sequence, old a.sequence, upper + 1, a.sequence.count)
		end

	insertion_sort (a: SIMPLE_ARRAY [INTEGER])
			-- Sort array `a' using insertion sort.
			-- https://en.wikipedia.org/wiki/Insertion_sort
		note
			explicit: wrapping
		require
			a_not_empty: a.count > 0
			no_overflow: a.count < {INTEGER}.max_value

			modify (a)
		local
			i, j: INTEGER
		do
			from
				i := 2
			invariant
				a.is_wrapped
				2 <= i and i <= a.count + 1

				is_part_sorted (a.sequence, 1, i-1)
				is_permutation (a.sequence, a.sequence.old_)
			until
				i > a.count
			loop
				from
					j := i
				invariant
					a.is_wrapped
					1 <= j and j <= i

					is_part_sorted (a.sequence, 1, j-1)
					is_part_sorted (a.sequence, j, i)
					is_area1_smaller_equal_area2 (a.sequence, 1, j-1, j+1, i)
					is_permutation (a.sequence, a.sequence.old_)
				until
					j = 1 or else a[j-1] <= a[j]
				loop
					swap (a, j, j-1)
					j := j - 1
				variant
					j
				end
				i := i + 1
			end
		ensure
			sorted: is_sorted (a.sequence)
			permutation: is_permutation (a.sequence, old a.sequence)
		end

	selection_sort (a: SIMPLE_ARRAY [INTEGER])
			-- Sort array `a' using selection sort.
			-- https://en.wikipedia.org/wiki/Selection_sort
		note
			explicit: wrapping
		require
			a_not_empty: a.count > 0
			no_overflow: a.count < {INTEGER}.max_value

			modify (a)
		local
			i, j, m: INTEGER
		do
			from
				i := 1
			invariant
				a.is_wrapped
				1 <= i and i <= a.count + 1
				is_part_sorted (a.sequence, 1, i)
				is_area1_smaller_equal_area2 (a.sequence, 1, i-1, i, a.count)
				is_permutation (a.sequence, a.sequence.old_)
			until
				i >= a.count
			loop
				from
					j := i + 1
					m := i
				invariant
					a.is_wrapped
					1 <= i and i < a.count
					i < j and j <= a.count + 1
					i <= m and m < j
					is_part_sorted (a.sequence, 1, i)
					is_area1_smaller_equal_area2 (a.sequence, 1, i-1, i, a.count)
					is_permutation (a.sequence, a.sequence.old_)
					across 1 |..| (i-1) as ai all a.sequence[ai.item] <= a.sequence[m] end
					across i |..| (j-1) as ai all a.sequence[m] <= a.sequence[ai.item] end
				until
					j = a.count + 1
				loop
					if a[j] < a[m] then
						m := j
					end
					j := j + 1
				end
				swap (a, i, m)
				i := i + 1
			end
		ensure
			is_sorted: is_sorted (a.sequence)
			is_permutation: is_permutation (a.sequence, old a.sequence)
		end

	bubble_sort (a: SIMPLE_ARRAY [INTEGER])
			-- Sort array `a' using bubble sort.
			-- https://en.wikipedia.org/wiki/Bubble_sort
		note
			explicit: wrapping
		require
			a_not_empty: a.count > 0
			no_overflow: a.count < {INTEGER}.max_value

			modify (a)
		local
			i, j: INTEGER
		do
			from
				i := a.count
				j := 2
			invariant
				a.is_wrapped
				0 <= i and i <= a.count
				is_part_sorted (a.sequence, i, a.count)
				is_area1_smaller_equal_area2 (a.sequence, 1, i, i+1, a.count)
				is_permutation (a.sequence, a.sequence.old_)
			until
				i <= 1
			loop
				from
					j := 1
				invariant
					a.is_wrapped
					1 <= i and i <= a.count
					1 <= j and j <= i
					is_part_sorted (a.sequence, i, a.count)
					is_area1_smaller_equal_area2 (a.sequence, 1, i, i+1, a.count)
					is_permutation (a.sequence, a.sequence.old_)
					across 1 |..| j as ai all a.sequence[ai.item] <= a.sequence[j] end
				until
					j = i
				loop
					if a[j] > a[j+1] then
						swap (a, j, j+1)
					end
					j := j + 1
				end
				i := i - 1
			end
		ensure
			is_sorted: is_sorted (a.sequence)
			is_permutation: is_permutation (a.sequence, old a.sequence)
		end

	gnome_sort (a: SIMPLE_ARRAY [INTEGER])
			-- Sort array `a' using gnome sort.
			-- https://en.wikipedia.org/wiki/Gnome_sort
		note
			explicit: wrapping
		require
			a_not_empty: a.count > 0
			no_overflow: a.count < {INTEGER}.max_value

			modify (a)
		local
			pos: INTEGER
		do
			from
				pos := 2
			invariant
				a.is_wrapped
				2 <= pos and pos <= a.count + 1

				is_part_sorted (a.sequence, 1, pos-1)
				is_permutation (a.sequence, a.sequence.old_)
				decreases ([]) -- No termination proof
			until
				pos > a.count
			loop
				if a[pos] >= a[pos-1] then
					pos := pos + 1
				else
					swap (a, pos, pos-1)
					if pos > 2 then
						pos := pos - 1
					end
				end
			end
		ensure
			sorted: is_sorted (a.sequence)
			permutation: is_permutation (a.sequence, old a.sequence)
		end

	optimized_gnome_sort (a: SIMPLE_ARRAY [INTEGER])
			-- Sort array `a' using optimized gnome sort.
			-- https://en.wikipedia.org/wiki/Gnome_sort#Optimization
		note
			explicit: wrapping
		require
			a_not_empty: a.count > 0
			no_overflow: a.count < {INTEGER}.max_value - 1

			modify (a)
		local
			pos: INTEGER
			last: INTEGER
		do
			from
				pos := 2
				last := 1
			invariant
				a.is_wrapped
				2 <= pos and pos <= a.count + 1
				1 <= last and last <= a.count

				is_part_sorted (a.sequence, 1, pos-1)
				is_part_sorted (a.sequence, pos, last)
				is_area1_smaller_equal_area2 (a.sequence, 1, pos-1, pos+1, last)
				is_permutation (a.sequence, a.sequence.old_)

				decreases ([]) -- No termination proof
			until
				pos > a.count
			loop
				if a[pos] >= a[pos-1] then
					if last /= 1 then
						pos := last
						last := 1
					else
						pos := pos + 1
					end
				else
					swap (a, pos, pos-1)
					if pos > 2 then
						if last = 1 then
							last := pos
						end
						pos := pos - 1
					else
						pos := pos + 1
					end
				end
			end
		ensure
			sorted: is_sorted (a.sequence)
			permutation: is_permutation (a.sequence, old a.sequence)
		end

feature -- Helper

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
			swapped: a.sequence = (old a.sequence).replaced_at (i, (old a.sequence[j])).replaced_at (j, (old a.sequence[i]))
			is_permutation: a.sequence.to_bag = old a.sequence.to_bag
		end

	three_way_partition (a: SIMPLE_ARRAY [INTEGER]; pivot, lower, upper, min, max: INTEGER): TUPLE [left: INTEGER; right: INTEGER]
			-- Partition array `a' in the range `lower' to `upper' according to `pivot'.
		note
			status: impure
		require
			lower_upper_bounds: 1 <= lower and lower <= upper and upper <= a.count
			no_overflow: a.count < {INTEGER}.max_value and min > {INTEGER}.min_value and max < {INTEGER}.max_value
			pivot_bounds: min <= pivot and pivot <= max
			value_bounds: are_values_in_range (a.sequence, lower, upper, min, max)

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

				are_values_in_range (a.sequence, lower, upper, min, max)

				is_permutation (a.sequence, a.sequence.old_)
				is_unchanged (a.sequence, a.sequence.old_, 1, lower - 1)
				is_unchanged (a.sequence, a.sequence.old_, upper + 1, a.sequence.count)

				are_values_in_range (a.sequence, lower, i-1, min, pivot - 1)
				are_values_in_range (a.sequence, i, j-1, pivot, pivot)
				are_values_in_range (a.sequence, k+1, upper, pivot + 1, max)
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
			left_right_relation: Result.left < Result.right

			smaller_left: are_values_in_range (a.sequence, lower, Result.left, min, pivot - 1)
			pivots_middle: are_values_in_range (a.sequence, Result.left + 1, Result.right - 1, pivot, pivot)
			larger_right: are_values_in_range (a.sequence, Result.right, upper, pivot + 1, max)

			permutation: is_permutation (a.sequence, old a.sequence)
			unchanged_left: is_unchanged (a.sequence, old a.sequence, 1, lower - 1)
			unchanged_right: is_unchanged (a.sequence, old a.sequence, upper + 1, a.sequence.count)
		end

feature -- Specification

	is_sorted (s: MML_SEQUENCE [INTEGER]): BOOLEAN
			-- Is `s' sorted?
		note
			status: functional, ghost
		do
			Result := is_part_sorted (s, 1, s.count)
		end

	is_part_sorted (s: MML_SEQUENCE [INTEGER]; lower, upper: INTEGER): BOOLEAN
			-- Is `s' sorted from `lower' to `upper'?
		note
			status: functional, ghost
		require
			lower_in_bounds: lower >= 1
			upper_in_bounds: upper <= s.count
		do
			Result := across lower |..| upper as i all
						across lower |..| upper as j all
							i.item <= j.item implies s[i.item] <= s[j.item] end end
		end

	is_area1_smaller_equal_area2 (s: MML_SEQUENCE [INTEGER]; lower_a1, upper_a1, lower_a2, upper_a2: INTEGER): BOOLEAN
			-- Is `s' sorted from `lower' to `upper'?
		note
			status: functional, ghost
		require
			area1_bounds: 1 <= lower_a1 and upper_a1 <= s.count
			area1_bounds: 1 <= lower_a2 and upper_a2 <= s.count
		do
			Result := across lower_a1 |..| upper_a1 as i all
						across lower_a2 |..| upper_a2 as j all
							s[i.item] <= s[j.item] end end
		end

	is_permutation (s1, s2: MML_SEQUENCE [INTEGER]): BOOLEAN
			-- Are `s1' and `s2' permutations of each other?
		note
			status: functional, ghost
		do
			Result := s1.to_bag ~ s2.to_bag and s1.count = s2.count
		end
		
	is_unchanged (s1, s2: MML_SEQUENCE [INTEGER]; lower, upper: INTEGER): BOOLEAN
			-- Are `s1' and `s2' equal from `lower' to `upper'?
		note
			status: functional, ghost
		require
			same_size: s1.count = s2.count
			lower_upper_bounds: 1 <= lower and upper <= s1.count
		do
			Result := across lower |..| (upper) as i all s1[i.item] = s2[i.item] end
		end

	are_values_in_range (s: MML_SEQUENCE [INTEGER]; lower, upper, min, max: INTEGER): BOOLEAN
			-- Are all values between `lower' and `upper' between `min' and `max'?
		note
			status: functional, ghost
		require
			lower_upper_bounds: 1 <= lower and upper <= s.count
			min_lower_relation: min <= max + 1
		do
			Result := across lower |..| (upper) as i all min <= s[i.item] and s[i.item] <= max end
		end

end
