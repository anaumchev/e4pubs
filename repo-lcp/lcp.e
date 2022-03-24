note
	description : "Longest common prefix algorithm on arbitrary arrays."

class
	LCP [G]

feature -- LCP

	lcp (a: SIMPLE_ARRAY [G]; x, y: INTEGER): INTEGER
			-- Return the length of the longest common prefix of a [x..] and a [y..]
		require
			x_in_range: 1 <= x and x <= a.count
			y_in_range: 1 <= y and y <= a.count
			no_overflow: 0 < a.count and a.count < {INTEGER}.max_value
		do
			from
				Result := 0
			invariant
				length_non_negative: Result >= 0
				end_in_range_1: x + Result <= a.count + 1
				end_in_range_2: y + Result <= a.count + 1
				is_common: across 0 |..| (Result - 1) as i all a [x + i] = a [y + i] end
				empty_prefix: a [x] /= a [y] implies Result = 0
			until
				x + Result = a.count + 1 or else
				y + Result = a.count + 1 or else
				a [x + Result] /= a [y + Result]
			loop
				Result := Result + 1
			variant
				a.count - Result + 1
			end
		ensure
			length_non_negative: Result >= 0
			end_in_range_1: x + Result <= a.count + 1
			end_in_range_2: y + Result <= a.count + 1
			is_common: across 0 |..| (Result - 1) as i all a [x + i] = a [y + i] end
			longest_prefix: (x + Result = a.count + 1) or else (y + Result = a.count + 1) or else (a [x + Result] /= a[y + Result])
			empty_prefix: a[x] /= a[y] implies Result = 0
		end


end
