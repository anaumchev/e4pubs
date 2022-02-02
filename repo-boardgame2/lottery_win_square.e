class
	LOTTERY_WIN_SQUARE

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
			p.transfer (10)
		ensure then
			lottery_won: p.money = old p.money + 10
		end

feature -- Output

	out_: V_STRING
			-- Textual representation.
		note
			status: impure
		do
			Result := "$"
		end

end
