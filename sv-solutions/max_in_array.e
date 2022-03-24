-- Prove the following class correct by providing a 
-- suitable precondition and loop invariant.

-- Note: Use 'across 1 |..| a.count as i all a.sequence[i.item] = a.sequence[i.item] end' to express first-order properties.

class MAX_IN_ARRAY

feature

	max_in_array (a: SIMPLE_ARRAY [INTEGER]): INTEGER
			-- Index of maximum element of `a'.
		note
			status: impure
		require
			a_not_empty: a.count > 0

		local
			x, y: INTEGER
		do
			from
				x := 1
				y := a.count
			invariant
				x_and_y_in_range: 1 <= x and x <= y and y <= a.count
				max_until_x: across 1 |..| x as i all a.sequence[i] <= a.sequence[x] or a.sequence[i] <= a.sequence[y] end
				max_until_y: across y |..| a.count as i all a.sequence[i] <= a.sequence[x] or a.sequence[i] <= a[y] end
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
			modify ([])
			result_in_range: 1 <= Result and Result <= a.count
			result_is_max: across 1 |..| a.count as i all a.sequence[i] <= a[Result] end
		end

end
