class
	SQUARE

inherit
	ANY
		redefine
			out_
		end

feature -- Basic operations

	affect (p: PLAYER)
			-- Apply square's special effect to `p'.
		note
			explicit: wrapping, contracts
		require
			p_wrapped: p.is_wrapped
		do
			-- For a normal square do nothing.
		ensure
			modify_field(["closed", "money"], p)
			p_wrapped: p.is_wrapped
		end

feature -- Output

	out_: V_STRING
			-- Textual representation.
		note
			status: impure
		do
			Result := "."
		end

end
