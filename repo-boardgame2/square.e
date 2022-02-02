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
			modify_field(["closed", "money"], p)
		do
			-- For a normal square do nothing.
		ensure
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
