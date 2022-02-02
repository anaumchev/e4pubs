class CLIENT

feature

	switch_light
		local
			light: LIGHT
			switch: SWITCH
			cup, cdown: LIGHT_COMMAND
		do
			create light
			create {FLIP_UP_COMMAND} cup.make (light)
			create {FLIP_DOWN_COMMAND} cdown.make (light)
			create switch

			switch.execute_command (cup)
			check light.is_on end

			switch.execute_command (cdown)
			check not light.is_on end
		end

end
