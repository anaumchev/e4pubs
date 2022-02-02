class
	BAD_INVESTMENT_SQUARE

inherit
	SQUARE
		redefine
			affect,
			out_
		end

feature -- Basic operations

	affect (p: PLAYER)
			-- Apply square's special effect to `p'.
		note
			explicit: wrapping
		do
			p.transfer (-5)
		ensure then
			investment_lost: p.money = (old p.money - 5).max (0)
		end

feature -- Output

	out_: V_STRING
			-- Textual representation.
		note
			status: impure
		do
			Result := "#"
		end

end
