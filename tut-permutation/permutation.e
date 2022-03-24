class PERMUTATION

feature -- Potential permutation encodings

	is_permutation_1 (a, b: MML_SEQUENCE [INTEGER]): BOOLEAN
			-- Is `b' a permutation of `a'?
		note
			status: functional
		do
			Result := across a as i all b.has (i) end
		end

	is_permutation_2 (a, b: MML_SEQUENCE [INTEGER]): BOOLEAN
			-- Is `b' a permutation of `a'?
		note
			status: functional
		do
			Result := across a as i all b.has (i) end and
						across b as i all a.has (i) end and
						a.count = b.count
		end

	is_permutation_3 (a, b: MML_SEQUENCE [INTEGER]): BOOLEAN
			-- Is `b' a permutation of `a'?
		note
			status: functional
		do
			Result := a.to_bag = b.to_bag
		end

	is_permutation_4 (a, b: MML_SEQUENCE [INTEGER]): BOOLEAN
			-- Is `b' a permutation of `a'?
		note
			status: functional
		do
			Result := a.range = b.range
		end

feature -- Test

	test_permutation
		local
			s1, s2: MML_SEQUENCE [INTEGER]
		do
			s1 := << 1, 2, 3, 4 >>
			s2 := << 1 >>
			check p1: is_permutation_1 (s1, s2) end

			s1 := << 1, 2, 3, 4 >>
			s2 := << 1 >>
			check p2: is_permutation_2 (s1, s2) end

			s1 := << 1, 2, 3, 4 >>
			s2 := << 1 >>
			check p3: is_permutation_3 (s1, s2) end

			s1 := << 1, 2, 3, 4 >>
			s2 := << 1 >>
			check p4: is_permutation_4 (s1, s2) end
		end

end
