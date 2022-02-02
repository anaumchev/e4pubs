class
	ADDITION_STRATEGY

inherit
	OPERATOR_STRATEGY

feature -- Basic operations

	execute (a, b: INTEGER)
			-- <Precursor>
		do
			last_result := a + b
		ensure then
			last_result = a + b
		end

end
