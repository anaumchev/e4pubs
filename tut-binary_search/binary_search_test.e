note
	description: "Test harness for {BINARY_SEARCH}."

class
	BINARY_SEARCH_TEST

feature

	test_binary_search
			-- Test of routine `binary_search'.
		local
			a: SIMPLE_ARRAY [INTEGER]
			s: BINARY_SEARCH
			i: INTEGER
		do
			create a.init (<< -5, -3, -1, 0, 2, 4 >>)
			create s

			i := s.binary_search (a, 2)
			check a.sequence.has (2) end
			check i = 5 end
			check a[i] = 2 end

			i := s.binary_search (a, 3)
			check not a.sequence.has (3) end
			check i = 0 end

			i := s.binary_search (a, -5)
			check a.sequence.has (-5) end
			check i = 1 end
			check a[i] = -5 end

			i := s.binary_search (a, 17)
			check not a.sequence.has (17) end
			check i = 0 end
		end

end
