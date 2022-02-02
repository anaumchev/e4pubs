-- Write the missing preconditions and postconditions and
-- verify the routine without changing the implementation.

class WRAPPING_COUNTER

feature

	increment (count: INTEGER): INTEGER
			-- Increases the input by 1 and wraps around after 59.
		require
			-- TODO: add preconditions
		do
			if (count = 59) then
				Result := 0
			else
				Result := count + 1
			end
		ensure
			counter_in_range: Result >= 0 and Result < 60
			
			-- TODO: add missing postcondition
			-- the method should increment all values by 1, 
			-- except those above 58 (which wrap back to 0).
	end

end
