note
	description: "Nondeterministic GCD with termination guarantees."

class
	GCD

feature -- Implementation

	gcd_nondeterministic (a_, b_: INTEGER): INTEGER
			-- Greatest common divisor of `a_' and `b_';
			-- the implementation uses two "threads" A and B (modeled with nondeterminism);
			-- thread A is "enabled" when `a > b' and updates `a'; thread B is "enabled" when `b > a' and updates `b';
			-- we verify that this implementation termiantes under a fair scheduler.
		require
			a_poisitve: a_ > 0
			b_positive: b_ > 0
		local
			a, b: INTEGER
			i: INTEGER -- Ghost counter
		do
			check assume: a_turn.count > 0 end -- Modeling infinite sequence
			from
				a := a_
				b := b_
				i := 1
			invariant
				a_in_bounds: 0 < a and a <= a_
				b_in_bounds: 0 < b and b <= b_
				maintains_gcd: gcd (a, b) = gcd (a_, b_)
				coin_flips_long_enough: 1 <= i and i <= a_turn.count
				-- Either `a + b' descreases (one of the treads made a move),
				-- or it stays the same, but the time until one of the threads is enabled decreasees
				-- (`a_turn [i] = (a > b)' encodes the conditon under which the scheduled thread is enabled):
				decreases (a + b, next (i, a > b) - i)
			until
				a = b
			loop
				check assume: i + 1 <= a_turn.count end -- Modeling infinite sequence
				if a_turn [i] then -- Thread A is scheduled
					if a > b then
						a := a - b
					end
				else -- Thread B is scheduled
					if b > a then
						b := b - a
					end
				end
				i := i + 1
			end
			Result := a
		ensure
			valid_result: Result = gcd (a_, b_)
		end

feature -- Specification

	gcd (a, b: INTEGER): INTEGER
			-- Recursively defined GCD.
		note
			status: functional, ghost
		require
			a_positive: 0 < a
			b_positive: 0 < b
		do
			Result := if a = b then a else
				if a > b then gcd (a - b, b) else gcd (a, b - a) end end
		end

	a_turn: MML_SEQUENCE [BOOLEAN]
			-- Ghost infinite sequnece of bits that says for each turn, whether thread A should be scheduled.

	next (i: INTEGER; val: BOOLEAN): INTEGER
			-- The earliest position in `a_turn' at or after `i' where the value is equal to `val'.
			-- The existence of this function implies that both values appear in `a_turn' infintely often;
			-- this is our way to model a fair scheduler.
		require
			1 <= i and i <= a_turn.count
		do
			check assume: False end -- This is just an axiomatization, no implementation provided.
		ensure
			valid_index: i <= Result and Result <= a_turn.count
			correct_value: a_turn [Result] = val
			first_correct_value: across i |..| (Result - 1) as k all a_turn [k] /= val end
		end

end
