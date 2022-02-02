note
	description : "Test harness."

class
	CLIENT

feature

	test_lcp
			-- Using lcp.
		local
			l: LCP [INTEGER]
			a: SIMPLE_ARRAY [INTEGER]
			x: INTEGER
		do
			create l
			create a.init (<< 1 >>)

			x := l.lcp (a, 1, 1)
			check x = 1 end

			create a.init (<< 1, 1 >>)

			x := l.lcp (a, 1, 2)
			check x = 1 end
			x := l.lcp (a, 1, 1)
			check x = 2 end

			create a.init (<< 1, 2 >>)

			x := l.lcp (a, 1, 2)
			check x = 0 end
			x := l.lcp (a, 1, 1)
			check x = 2 end

			create a.init (<< 1, 2, 2, 5>>)

			x := l.lcp (a, 1, 2)
			check x = 0 end

			create a.init (<< 1, 2, 3, 4, 1, 2, 3>>)

			x := l.lcp (a, 1, 3)
			check x = 0 end
			x := l.lcp (a, 1, 5)
			check x = 3 end
			x := l.lcp (a, 2, 6)
			check x = 2 end
		end

end
