class
	FLIP_DOWN_COMMAND

inherit
	LIGHT_COMMAND

create
	make

feature

	execute
			-- <Precursor>
		note
			explicit: wrapping
		do
			light.turn_off
		ensure then
			off: not light.is_on
		end

end
