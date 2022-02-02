class
	FLIP_UP_COMMAND

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
			light.turn_on
		ensure then
			on: light.is_on
		end

end
