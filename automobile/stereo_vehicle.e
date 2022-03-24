class
	STEREO_VEHICLE

inherit
	AUTOMOBILE

create
	make

feature	-- Basic operations

	make
		do
			create volvo.make
			create fiat
		end

	volvo: VOLVO
	fiat: FIAT

	brand: STRING
		do
			Result := "Stereo"
		end

	drive
		do
			volvo.drive
			fiat.drive
		end

invariant
	volvo_exists: volvo /= Void
	fiat_exists: fiat /= Void
	owns_definition: owns = create {MML_SET [ANY]} & volvo & fiat
end
