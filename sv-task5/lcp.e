-- The LCP class implements a Longest Common Prefix algorithm with
-- input and output defined as follows:
--   Input: an integer array a, and two indices x and y into this array
--   Output: length of longest common prefix of the subarrays of a
--           starting at x and y respectively.
-- What can you prove about it?

class
	LCP

feature

	lcp (a: SIMPLE_ARRAY [INTEGER]; x, y: INTEGER): INTEGER
			-- Return the length of the longest common prefix of a [x..] and a [y..]
		note
			status: impure -- This function is not used in contracts.
		require
			-- TODO: Preconditions

			modify ([]) -- This function does not modify anything.
		do
			from
				Result := 0
			invariant
				-- TODO: Loop invariants
			until
				x + Result = a.count + 1 or else
				y + Result = a.count + 1 or else
				a[x + Result] /= a[y + Result]
			loop
				Result := Result + 1
			variant
				a.count - Result + 1
			end
		ensure
			-- TODO: Postconditions
		end

	test_lcp
			-- Test harness.
		note
			explicit: wrapping
		local
			a: SIMPLE_ARRAY [INTEGER]
			x: INTEGER
		do
			create a.init (<< 1 >>)

			x := lcp (a, 1, 1)
			check x = 1 end

			create a.init (<< 1, 1 >>)

			x := lcp (a, 1, 2)
			check x = 1 end
			x := lcp (a, 1, 1)
			check x = 2 end

			create a.init (<< 1, 2 >>)

			x := lcp (a, 1, 2)
			check x = 0 end
			x := lcp (a, 1, 1)
			check x = 2 end

			create a.init (<< 1, 2, 2, 5>>)

			x := lcp (a, 1, 2)
			check x = 0 end

			create a.init (<< 1, 2, 3, 4, 1, 2, 3>>)

			x := lcp (a, 1, 3)
			check x = 0 end
			x := lcp (a, 1, 5)
			check x = 3 end
			x := lcp (a, 2, 6)
			check x = 2 end
		end

end
