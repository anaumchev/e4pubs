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
			x = 21 and y = 5
		do
			do_nothing
		ensure
			y = 5
		end

	part_b
		require
			x > 10
		do
			x := 2 * x
		ensure
			x > 21
		end

	part_c_loop
		require
			x >= 0 and y > 1
		do
			from
			invariant
				x >= 0 and y > 1

				modify_field ("x", Current)
				decreases([])
			until
				not (x < y)
			loop
				x := x * x
			end
		ensure
			x >= y
		end

	part_c_recursion
		require
			x >= 0 and y > 1

			decreases([])
		do
			if
				x < y
			then
				x := x * x
				wrap
				part_c_recursion
				unwrap
			end
		ensure
			x >= y
		end

	part_d_loop
		require
			x = 5
		do
			from
			invariant
				x >= 5

				modify_field ("x", Current)
				decreases([])
			until
				not (x > 0)
			loop
				x := x + 1
			end
		ensure
			x < 0
		end

	part_d_recursion
		require
			x = 5
		do
			wrap
			part_d_recursion_increment
			unwrap
		ensure
			x < 0
		end

	part_d_recursion_increment
		require
			x > 0

			decreases([])
		do
			if
				x > 0
			then
				x := x + 1
				wrap
				part_d_recursion_increment
				unwrap
			end
		ensure
			x < 0
		end

	part_e
		require
			x = a and y = b
		local
			t : INTEGER
		do
			t := x
			x := x + y
			y := t
		ensure
			x = a + b and y = a
		end

	part_f_loop
		require
			(i*n) + m = 250
		do
			from
			invariant
				(i*n) + m = 250

				modify_field (["m", "i"], Current)
			until
				not (i > 0)
			loop
				m := m + n
				i := i - 1
			variant
				i
			end
		ensure
			(i*n) + m = 250
		end

	part_f_recursion
		require
			(i*n) + m = 250

			decreases (i)
		do
			if
				i > 0
			then
				m := m + n
				i := i - 1
				wrap
				part_f_recursion
				unwrap
			end
		ensure
			(i*n) + m = 250
		end

end
