class
	SWITCH

feature

	execute_command (cmd: LIGHT_COMMAND)
		note
			explicit: wrapping
		require
			can_execute: cmd.light.is_wrapped

		do
			cmd.execute
		ensure
			modify (Current, cmd.light)
			(agent cmd.execute).postcondition ([])
		end

end
