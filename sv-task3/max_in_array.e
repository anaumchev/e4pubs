-- Prove the following class correct by providing a 
-- suitable precondition and loop invariant.

-- Note: Use 'across 1 |..| a.count as i all a.sequence[i.item] = a.sequence[i.item] end' to express first-order properties.

class MAX_IN_ARRAY

feature

	max_in_array (a: SIMPLE_ARRAY [INTEGER]): INTEGER
			-- Index of maximum element of `a'.
		note
			status: impure -- this function is not used in contracts
		require
			-- TODO: add preconditions

			modify ([]) -- this function does not modify anything
		local
			x, y: INTEGER
		do
			from
				x := 1
				y := a.count
			invariant
				-- TODO: add loop invariants
			until
				x = y
			loop
				if a[x] <= a[y] then
					x := x + 1
				else
					y := y - 1
				end
			variant
				y - x
			end
			Result := x
		ensure
			result_in_range: 1 <= Result and Result <= a.count
			result_is_max: across 1 |..| a.count as i all a.sequence[i.item] <= a[Result] end
		end

end
