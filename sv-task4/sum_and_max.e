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
			natural_numbers: across 1 |..| a.count as ai all a.sequence[ai.item] >= 0 end

			modify ([]) -- This function does not modify anything.
		local
			i: INTEGER
			sum, max: INTEGER
		do
			from
				i := 1
			invariant
				-- TODO: add loop invariants
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
			-- TODO: add postconditions
		end

	lemma (old_sum, old_i, old_max, new_max: INTEGER)
			-- Helper lemma for arithmetic property.
		note
			status: lemma
		require
			sum >= 0 and i > 0 and old_max >= 0 and new_max >= 0
		do
		ensure
		end

end
