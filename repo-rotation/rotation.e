note
	description: "Different algorithms for rotating arrays."

class
	ROTATION [G]

feature -- Helper functions

	wrapped_index (i, c: INTEGER): INTEGER
			-- Index `i' wrapped for array of size `s',
		note
			status: functional, ghost
		do
			Result := if i > c then i - c else i end
		end

	is_rotation (a, b: SIMPLE_ARRAY [G]; r: INTEGER): BOOLEAN
			-- Is `b' an `r'-rotation of `a'?
		note
			status: functional, ghost
		require
			a.sequence.count = b.sequence.count
			0 < r and r < a.sequence.count
		do
			Result := across 1 |..| a.sequence.count as i all a.sequence[i.item] = b.sequence[wrapped_index(i.item + a.sequence.count - r, a.sequence.count)] end
		end

feature -- Rotation by copy

	rotate_copy (a: SIMPLE_ARRAY [G]; r: INTEGER): SIMPLE_ARRAY [G]
			-- `r'-rotated version of `a' using a copy algorithm.
		note
			explicit: wrapping
			status: impure
		require
			a.is_wrapped
			1 < a.sequence.count
			0 < r and r < a.sequence.count

			modify ([])
		local
			s, d: INTEGER
		do
			create Result.make (a.count)
			from
				s := 1
				d := 1 + a.count - r
			invariant
				Result.is_wrapped
				Result.sequence.count = a.count
				1 <= s and s <= a.count + 1
				1 <= d and d <= a.count
				d = wrapped_index (s + a.count - r, a.count)
				across 1 |..| (s-1) as i all a.sequence[i.item] = Result.sequence[wrapped_index(i.item + a.count - r, a.count)] end
			until
				s >= a.count + 1
			loop
				Result[d] := a[s]
				s := s + 1
				d := d + 1
				if d > a.count then
					d := 1
				end
			end
		ensure
			is_rotation (a, Result, r)
		end

feature -- Rotation by reversal

	rotate_reverse (a: SIMPLE_ARRAY [G]; r: INTEGER): SIMPLE_ARRAY [G]
			-- `r'-rotated version of `a' using a reverse algorithm.
		note
			explicit: wrapping
			status: impure
		require
			a.is_wrapped
			a.sequence.count > 0
			0 < r and r < a.sequence.count

			modify ([])
		do
			create Result.init (a.sequence)
			Result := reverse_inplace (Result, 1, r)
			Result := reverse_inplace (Result, r + 1, Result.count)
			Result := reverse_inplace (Result, 1, a.count)
		ensure
			is_rotation (a, Result, r)
		end

	reverse_position (i, low, high: INTEGER): INTEGER
			-- Reverse position of `i' in interval `low' to `high'.
		note
			status: functional, ghost
		do
			Result := high + low - i
		end

	reverse_inplace (a: SIMPLE_ARRAY [G]; low, high: INTEGER): SIMPLE_ARRAY [G]
			-- Reverse elements of `a' from `low' to `high'.
		note
			status: impure
			explicit: wrapping
		require
			a.is_wrapped
			1 <= low and low <= high and high <= a.count

			modify ([])
		local
			p, q: INTEGER
			t: G
		do
			create Result.init (a.sequence)
			from
				p := low
				q := high
				check q = reverse_position(p, low, high) end
			invariant
				Result.is_wrapped
				Result.count = a.count
				low <= p and p <= q + 2 and q <= high

				q = reverse_position(p, low, high)
				across low |..| (p-1) as i all a.sequence[i.item] = Result.sequence[reverse_position(i.item, low, high)] end
				across (q+1) |..| high as i all a.sequence[i.item] = Result.sequence[reverse_position(i.item, low, high)] end
				across p |..| q as i all a.sequence[i.item] = Result.sequence[i.item] end
				across 1 |..| (low-1) as i all a.sequence[i.item] = Result.sequence[i.item] end
				across (high+1) |..| a.count as i all a.sequence[i.item] = Result.sequence[i.item] end
			until
				p >= q
			loop
				t := Result[q]
				Result[q] := Result[p]
				Result[p] := t
				p := p + 1
				q := q - 1
			variant
				q - p
			end
		ensure
			Result.is_wrapped
			Result.count = a.count
			across 1 |..| (low-1) as i all a.sequence[i.item] = Result.sequence[i.item] end
			across (high+1) |..| a.count as i all a.sequence[i.item] = Result.sequence[i.item] end
			across low |..| (high) as i all a.sequence[i.item] = Result.sequence[reverse_position(i.item, low, high)] end
		end

end
