-- Investigate what the following class does.
-- What can you prove about it?

-- Note: You might need a lemma.

class SUM_AND_MAX

feature

	sum_and_max (a: SIMPLE_ARRAY [INTEGER]): TUPLE [sum, max: INTEGER]
			-- Calculate sum and maximum of array `a'.
		note
			status: impure -- This function is not used in contracts.
		require
			a_not_void: a /= Void
			natural_numbers: across 1 |..| a.count as ai all a.sequence[ai] >= 0 end

		local
			i: INTEGER
			sum, max: INTEGER
		do
			from
				i := 1
			invariant
				i_in_range: 1 <= i and i <= a.count + 1
				sum_and_max_not_negative: sum >= 0 and max >= 0
				partial_sum_and_max: sum <= (i-1) * max
			until
				i > a.count
			loop
				if a[i] > max then
					lemma (sum, i, max, a[i])
					max := a[i]
				end
				sum := sum + a[i]
				i := i + 1
			end
			Result := [sum, max]
		ensure
			modify ([]) -- This function does not modify anything.
			sum_in_range: Result.sum <= a.count * Result.max
		end

	lemma (old_sum, i, old_max, new_max: INTEGER)
			-- Helper lemma for arithmetic property.
		note
			status: lemma
		require
			old_sum >= 0 and i > 0 and old_max >= 0 and new_max >= 0
			old_sum <= (i-1) * old_max
			old_max < new_max
		do
		ensure
			(old_sum + new_max) <= i * new_max
		end

end
