note
	description: "Test harness for CLOCK."

class
	CLOCK_TEST

feature

	test_make_pass
			-- Test of routine `make' that has to pass verification.
		local
			c: CLOCK
		do
			create c.make (0, 0, 0)
			check c.hours = 0 end
			check c.minutes = 0 end
			check c.seconds = 0 end
			
			create c.make (10, 30, 5)
			check c.hours = 10 end
			check c.minutes = 30 end
			check c.seconds = 5 end

			create c.make (23, 59, 59)
			check c.hours = 23 end
			check c.minutes = 59 end
			check c.seconds = 59 end
		end

	test_make_fail (i: INTEGER)
			-- Test of routine `make' that has to fail.
		local
			c: CLOCK
		do
			if i = 1 then
				create c.make (-1, 0, 0)
			elseif i = 2 then
				create c.make (0, 60, 0)
			elseif i = 3 then
				create c.make (0, 0, 100)
			end
		end

	test_set_pass
			-- Test of setter routines that has to pass verification.
		local
			c: CLOCK
		do
			create c.make (0, 0, 0)
			c.set_hours (4)
			check c.hours = 4 end
			check c.minutes = 0 end
			check c.seconds = 0 end
			c.set_minutes (43)
			check c.hours = 4 end
			check c.minutes = 43 end
			check c.seconds = 0 end
			c.set_seconds (25)
			check c.hours = 4 end
			check c.minutes = 43 end
			check c.seconds = 25 end
		end

	test_set_fail (i: INTEGER)
			-- Test of setter routines that has to fail.
		local
			c: CLOCK
		do
			create c.make (0, 0, 0)
			if i = 1 then
				c.set_hours (24)
			elseif i = 2 then
				c.set_minutes (-4)
			elseif i = 3 then
				c.set_seconds (60)
			end
		end

	test_clock_pass1
			-- Test increase hours.
		local
			c: CLOCK
		do
			create c.make (22, 30, 50)
			c.increase_hours
			c.increase_hours
			c.increase_hours
			check c.hours = 1 end
			check c.minutes = 30 end
			check c.seconds = 50 end
		end

	test_clock_pass2
			-- Test increase minutes.
		local
			c: CLOCK
		do
			create c.make (10, 59, 48)
			c.increase_minutes
			c.increase_minutes
			c.increase_minutes
			check c.hours = 11 end
			check c.minutes = 2 end
			check c.seconds = 48 end
		end

	test_clock_pass3
			-- Test increase seconds.
		local
			c: CLOCK
		do
			create c.make (23, 59, 58)
			c.increase_seconds
			c.increase_seconds
			c.increase_seconds
			check c.hours = 0 end
			check c.minutes = 0 end
			check c.seconds = 1 end
		end

	test_clock_fail (i: INTEGER)
			-- Test of increase routines that has to fail.
		local
			c: CLOCK
		do
			if i = 0 then
				create c.make (10, 30, 59)
				c.increase_seconds
				check c.minutes = 30 end
			elseif i = 1 then
				create c.make (10, 59, 59)
				c.increase_seconds
				check c.hours = 10 end
			elseif i = 2 then
				create c.make (23, 59, 5)
				c.increase_minutes
				check c.hours = 23 end
			end
		end

end
