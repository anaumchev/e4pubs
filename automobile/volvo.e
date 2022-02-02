class
	VOLVO

inherit
	AUTOMOBILE

create
	make

feature -- Basic operations

	make
		do
			create odometer
		end

	brand: STRING
		do
			Result := "Volvo"
		end

	odometer: ODOMETER

	drive
		do
			position := position + 10
			odometer.advance (10)
		end

invariant
	odometer_exists: odometer /= Void
	owns_definition: owns = [odometer]

end
