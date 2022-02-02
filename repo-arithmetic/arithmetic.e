note
	description: "Implementation of arithmetic operations based on increment."

class
	ARITHMETIC

feature -- Addition

	add (a, b: INTEGER): INTEGER
			-- Add two numbers by repeated increment.
			-- Iterative version.
		local
			i: INTEGER
		do
			if b >= 0 then
				from
					Result := a
					i := b
				invariant
					Result = a + (b - i)
					0 <= i and i <= b
				until
					i = 0
				loop
					Result := Result + 1
					i := i - 1
				variant
					i
				end
			else
				from
					Result := a
					i := b
				invariant
					Result = a + (b - i)
					b <= i and i <= 0
				until
					i = 0
				loop
					Result := Result - 1
					i := i + 1
				variant
					-i
				end
			end
		ensure
			result_correct: Result = a + b
		end

	add_recursive (a, b: INTEGER): INTEGER
			-- Add two numbers by repeated increment.
			-- Recursive version.
		require
			decreases (if b < 0 then -b else b end)
		do
			if b = 0 then
				Result := a
			elseif b > 0 then
				Result := add_recursive (a, b - 1) + 1
			else
				Result := add_recursive (a, b + 1) - 1
			end
		ensure
			result_correct: Result = a + b
		end

feature -- Multiplication

	multiply (a, b: INTEGER): INTEGER
			-- Multiply two numbers by repeated addition.
			-- Iterative version.
		require
			b_not_negative: b >= 0
		local
			i: INTEGER
		do
			if a = 0 or b = 0 then
				Result := 0
			else
				from
					Result := a
					i := b
				invariant
					Result = a * (b - i + 1)
					1 <= i and i <= b
				until
					i = 1
				loop
					Result := add (Result, a)
					i := i - 1
				variant
					i
				end
			end
		ensure
			result_correct: Result = a * b
		end

	multiply_recursive (a, b: INTEGER): INTEGER
			-- Multiply two numbers by repeated addition.
			-- Recursive version.
		require
			b_not_negative: b >= 0
		do
			if a = 0 or b = 0 then
				Result := 0
			else
				if b = 1 then
					Result := a
				else
					Result := add_recursive (a, multiply (a, b-1))
				end
			end
		ensure
			result_correct: Result = a * b
		end

feature -- Division

	divide (n, m: INTEGER): TUPLE [quotient, remainder: INTEGER]
			-- Integer division of `n' divided by `m'.
			-- Iterative version.
		require
			n_not_negative: n >= 0
			m_positive: m > 0
		local
			q, r: INTEGER
		do
			from
				r := n
				q := 0
			invariant
				0 <= r
				n = m * q + r
			until
				r < m
			loop
				r := add (r, -m)
				q := q + 1
			variant
				r
			end
			Result := [q ,r]
		ensure
			n = m * Result.quotient + Result.remainder
		end

	divide_recursive (n, m: INTEGER): TUPLE [quotient, remainder: INTEGER]
			-- Integer division of `n' divided by `m'.
			-- Recursive version.
		require
			n_not_negative: n >= 0
			m_positive: m > 0
		local
			q, r: INTEGER
			res: TUPLE [quotient, remainder: INTEGER]
		do
			if n < m then
				Result := [0, n]
			else
				res := divide_recursive (add_recursive (n, -m), m)
				Result := [res.quotient + 1, res.remainder]
			end
		ensure
			n = m * Result.quotient + Result.remainder
		end

end
