class
	LIGHT

feature

	is_on: BOOLEAN
			-- Is light on?

	turn_on
			-- Turn light on.
		do
			is_on := True
		ensure
			on: is_on
		end

	turn_off
			-- Turn light off.
		do
			is_on := False
		ensure
			off: not is_on
		end

end
