class
	SWITCH

feature

	execute_command (cmd: LIGHT_COMMAND)
		note
			explicit: wrapping
		require
			can_execute: cmd.light.is_wrapped

			modify (Current, cmd.light)
		do
			cmd.execute
		ensure
			(agent cmd.execute).postcondition ([])
		end

end
