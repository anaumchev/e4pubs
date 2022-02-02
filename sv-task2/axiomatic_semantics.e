-- Write for each of these simple program specifications a
-- contract-equipped method and verify it.
--
-- (A) |= {x = 21 /\ y = 5} skip {y = 5}
-- (B) |= {x > 10} x := 2 * x {x > 21}
-- (C) |= {x >= 0 ^ y > 1} while x < y do x := x * x {x >= y}
-- (D) |= {x = 5} while x > 0 do x := x + 1 {x < 0}
-- (E) |= {x = a /\ y = b} t := x; x := x + y; y := t {x = a + b /\ y = a}
-- (F) |= {in + m = 250} while (i > 0) do m := m + n; i := i - 1 {in + m = 250}

-- Note: for each loop, add an invariant 'modify_field ("x", Current)'.
-- Note: for each call f, add a call 'wrap' before the call and 'unwrap' after the call.
-- Note: to skip the termination check add the following precondition (for recursion) 
--       or loop invariant (for loops): 'decreases([])'

class AXIOMATIC_SEMANTICS

feature
	a, b, i, m, n, x, y: INTEGER

feature

	part_a
		require
			-- TODO: add precondition
		do
			-- TODO: add implementation
		ensure
			-- TODO: add postcondition
		end

	-- etc.

end
