note
	description: "Insertion sort on integer arrays."

class
	INSERTION_SORT

feature -- Basic operations

	insertion_sort (a: SIMPLE_ARRAY [INTEGER])
			-- Sort array `a' using insertion sort.
			-- https://en.wikipedia.org/wiki/Insertion_sort
		note
			explicit: wrapping
		require
			a_not_empty: a.count > 0
			no_overflow: a.count < {INTEGER}.max_value

		local
			i, j: INTEGER
		do
			from
				i := 2
			invariant
				a.is_wrapped
				2 <= i and i <= a.count + 1

				is_permutation (a.sequence, a.sequence.old_)
				is_part_sorted (a.sequence, 1, i-1)
			until
				i > a.count
			loop
				from
					j := i
				invariant
					a.is_wrapped
					1 <= j and j <= i

					is_permutation (a.sequence, a.sequence.old_)
					is_part_sorted (a.sequence, 1, j-1)
					is_part_sorted (a.sequence, j, i)
					across 1 |..| (j-1) as k all
						across (j+1) |..| i as l all
							a.sequence[k] <= a.sequence[l] end end
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
			modify (a)
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

		local
			t: INTEGER
		do
			t := a[i]
			a[i] := a[j]
			a[j] := t
		ensure
			modify (a)
			swapped: a.sequence ~ (old a.sequence).replaced_at (i, (old a.sequence[j])).replaced_at (j, (old a.sequence[i]))
			is_permutation: a.sequence.to_bag ~ old a.sequence.to_bag
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
			Result := across lower |..| (upper) as i all
						across lower |..| (upper) as j all
							i <= j implies s[i] <= s[j] end end
		end

	is_permutation (s1, s2: MML_SEQUENCE [INTEGER]): BOOLEAN
			-- Are `s1' and `s2' permutations of each other?
		note
			status: functional, ghost
		do
			Result := s1.to_bag ~ s2.to_bag and s1.count = s2.count
		end

end
