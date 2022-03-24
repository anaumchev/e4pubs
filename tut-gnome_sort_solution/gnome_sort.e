note
	description: "Gnome sort algorithm."

class
	GNOME_SORT

feature -- Sorting

	gnome_sort (a: SIMPLE_ARRAY [INTEGER])
			-- Sort array `a' using gnome sort.
			-- https://en.wikipedia.org/wiki/Gnome_sort
		note
			explicit: wrapping
		require
			a_not_empty: a.count > 0
			no_overflow: a.count < {INTEGER}.max_value

		local
			pos, t: INTEGER
		do
			from
				pos := 2
			invariant
				a.is_wrapped -- Array stays in a consistent state.
				decreases ([]) -- No termination proof.

				2 <= pos and pos <= a.count + 1

				is_permutation (a.sequence, a.sequence.old_)
				is_part_sorted (a.sequence, 1, pos-1)
			until
				pos > a.count
			loop
				if a[pos] >= a[pos-1] then
					pos := pos + 1
				else
						-- Swap pos and pos-1
					t := a[pos]
					a[pos] := a[pos-1]
					a[pos-1] := t
					if pos > 2 then
						pos := pos - 1
					end
				end
			end
		ensure
			modify (a)
			sorted: is_sorted (a.sequence)
			permutation: is_permutation (a.sequence, old a.sequence)
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
