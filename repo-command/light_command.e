deferred class
	LIGHT_COMMAND

feature

	make (a_light: LIGHT)
			-- Initialize
		note
			status: creator
		do
			light := a_light
		ensure
			light = a_light
		end

	light: LIGHT
			-- Light to operate on.

	execute
			-- Execute command.
		require
			light.is_wrapped
			modify (light)
		deferred
		ensure
			light.is_wrapped
		end

invariant
	light /= Void

end
