class
	FIAT

inherit
	AUTOMOBILE

feature -- Basic operations

	brand: STRING
		do
			Result := "Fiat"
		end

	drive
		do
			position := position + 3
--		ensure then
--			position = old position + 3
		end

end
