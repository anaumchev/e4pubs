deferred class
	OPERATOR_STRATEGY

feature -- Access

	last_result: INTEGER
			-- Result of last execution.

feature -- Basic operations

	execute (a, b: INTEGER)
			-- Execute operator strategy.
		deferred
		end

end
