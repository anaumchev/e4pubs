note
	description: "Test harness for {LINEAR_SEARCH}."

class
	LINEAR_SEARCH_TEST

feature

	test_linear_search
			-- Test of routine `linear_search'.
		local
			a: SIMPLE_ARRAY [INTEGER]
			s: LINEAR_SEARCH
			i: INTEGER
		do
			create a.init (<< 0, -1, 2, -3, 4, -5 >>)
			create s

			i := s.linear_search (a, 2)
			check i = 3 end
			check a[i] = 2 end

			i := s.linear_search (a, 3)
			check i = 0 end
			check not a.sequence.has (3) end

			i := s.linear_search (a, -5)
			check i = 6 end
			check a[i] = -5 end

			i := s.linear_search (a, 17)
			check i = 0 end
			check not a.sequence.has (17) end
		end

end
