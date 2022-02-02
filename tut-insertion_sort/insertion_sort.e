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
			-- TASK 1: Add precondition and modifies clause.
			-- TASK 5: Adapt specification to prevent overflows.
		local
			i, j: INTEGER
		do
			from
				i := 2
			invariant
				a.is_wrapped -- Array stays in a consistent state.
				2 <= i and i <= a.count + 1

				-- TASK 4: Add loop invariant to verify postcondition.
			until
				i > a.count
			loop
				from
					j := i
				invariant
					a.is_wrapped -- Array stays in a consistent state.

					-- TASK 1: Add loop invariant to verify array accesses.
					-- TASK 4: Add loop invariant to verify postcondition.
				until
					j = 1 or else a[j-1] <= a[j]
				loop
					swap (a, j, j-1)
					j := j - 1
				variant
					0 -- TASK 2: Add the loop variant to verify termination.
				end
				i := i + 1
			variant
				0 -- TASK 2: Add the loop variant to verify termination.
			end
		ensure
			-- TASK 3: Add the postcondition to verify clients.
		end

feature -- Helper

	swap (a: SIMPLE_ARRAY [INTEGER]; i, j: INTEGER)
			-- Swap elements `i' and `j' of array `a'.
		note
			explicit: wrapping
		require
			-- TASK 1: Add precondition and modifies clause.
		local
			t: INTEGER
		do
			t := a[i]
			a[i] := a[j]
			a[j] := t
		ensure
			-- TASK 4: Add postcondition to verify clients.
		end

end
