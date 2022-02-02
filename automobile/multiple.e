class
	MULTIPLE

inherit
	VOLVO
		redefine
			brand
		end

	FIAT
		undefine
			drive
		redefine
			brand
		end

create
	make

feature -- Basic operations

	brand: STRING
		do
			Result := "Freak"
		end

end
