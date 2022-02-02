note
	description: "Algorithm to calculate the maximum of an array starting at both ends."

class
	TWO_WAY_MAX

feature

	two_way_max (a: SIMPLE_ARRAY [INTEGER]): INTEGER
			-- Index of maximum element of `a'.
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
				max_front: across 1 |..| x as i all a.sequence[i.item] <= a[x] or a.sequence[i.item] <= a[y] end
				max_back: across y |..| a.count as i all a.sequence[i.item] <= a[x] or a.sequence[i.item] <= a[y] end
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
			result_is_max: across a.sequence as i all i.item <= a[Result] end
		end

end
