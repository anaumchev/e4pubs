class
	ODOMETER

feature -- Basic operations

	value: INTEGER

	advance (d: INTEGER)
		do
			value := value + d
		end

end
