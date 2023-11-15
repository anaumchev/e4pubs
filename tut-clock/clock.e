note
	description: "Clock counting seconds, minutes, and hours."
	-- TASK 1: Add model declaration.

class
	CLOCK

create
	make

feature {NONE} -- Initialization

	make (a_hours, a_minutes, a_seconds: INTEGER)
			-- Initialize clock.
		note
			status: creator
		require
			-- TASK 3: Add precondition for this routine.
		do
			hours := a_hours
			minutes := a_minutes
			seconds := a_seconds
		ensure
			hours_set: hours = a_hours
			minutes_set: minutes = a_minutes
			seconds_set: seconds = a_seconds
		end

feature -- Access

	hours: INTEGER
			-- Hours of clock.

	minutes: INTEGER
			-- Minutes of clock.

	seconds: INTEGER
			-- Seconds of clock.

feature -- Element change

	set_hours (a_value: INTEGER)
			-- Set `hours' to `a_value'.
		require
			-- TASK 4: Specify procedure.
		do
			hours := a_value
		ensure
			-- TASK 4: Specify procedure.
		end

	set_minutes (a_value: INTEGER)
			-- Set `minutes' to `a_value'.
		require
			-- TASK 4: Specify procedure.
		do
			minutes := a_value
		ensure
			-- TASK 4: Specify procedure.
		end

	set_seconds (a_value: INTEGER)
			-- Set `seconds' to `a_value'.
		require
			-- TASK 4: Specify procedure.
		do
			seconds := a_value
		ensure
			-- TASK 4: Specify procedure.
		end

feature -- Basic operations

	increase_hours
			-- Increase `hours' by one.
		note
			explicit: wrapping
		require
			-- TASK 5: Specify procedure.
		do
			if hours = 23 then
				set_hours (0)
			else
				set_hours (hours + 1)
			end
		ensure
			-- TASK 5: Specify procedure.
		end

	increase_minutes
			-- Increase `minutes' by one.
		note
			explicit: wrapping
		require
			-- TASK 5: Specify procedure.
		do
			if minutes = 59 then
				set_minutes (0)
				increase_hours
			else
				set_minutes (minutes + 1)
			end
		ensure
			-- TASK 5: Specify procedure.
		end

	increase_seconds
			-- Increase `seconds' by one.
		note
			explicit: wrapping
		require
			-- TASK 5: Specify procedure.
		do
			if seconds = 59 then
				set_seconds (0)
				increase_minutes
			else
				set_seconds (seconds + 1)
			end
		ensure
			-- TASK 5: Specify procedure.
		end

invariant
	-- TASK 2: Add class invariant.

end
