-- Write the missing preconditions and postconditions and
-- verify the routine without changing the implementation.

class WRAPPING_COUNTER

feature

	increment (count: INTEGER): INTEGER
			-- Increases the input by 1 and wraps around after 59.
		require
			count_in_range: count >= 0 and count < 60
		do
			if (count = 59) then
				Result := 0
			else
				Result := count + 1
			end
		ensure
			counter_in_range: Result >= 0 and Result < 60
			reset: count >= 59 implies Result = 0
			increment: count < 59 implies Result = count + 1
		end

end
