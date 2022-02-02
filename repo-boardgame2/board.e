class
	BOARD

inherit
	ANY
		redefine
			out_
		end

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize squares.
		note
			status: creator
		local
			i: INTEGER
		do
			create squares.make (Start_position, Square_count)
			check squares.is_wrapped end
			from
				i := 1
			invariant
				squares.is_wrapped and squares.is_fully_writable
				squares.lower = 1 and squares.sequence.count = Square_count and squares.observers = []
				1 <= i and i <= Square_count + 1

				across 1 |..| (i-1) as k all
					squares.sequence[k.item].is_wrapped and
					squares.sequence[k.item].is_fresh
				end
				across 1 |..| (i-1) as j all
					across 1 |..| (i-1) as k all
						j.item /= k.item implies squares.sequence[j.item] /= squares.sequence[k.item] end end

				modify (squares)
			until
				i > Square_count
			loop
				if i \\ 10 = 5 then
					squares [i] := create {BAD_INVESTMENT_SQUARE}
				elseif i \\ 10 = 0 then
					squares [i] := create {LOTTERY_WIN_SQUARE}
				else
					squares [i] := create {SQUARE}
				end
				i := i + 1
			end
		end

feature -- Access

	squares: V_ARRAY [SQUARE]
			-- Container for squares

feature -- Constants

	Square_count: INTEGER = 40
			-- Number of squares.

	Start_position: INTEGER = 1
			-- Start position on board.

feature -- Output

	out_: V_STRING
		note
			status: impure
		do
			Result := ""
			across
				squares as c
			loop
				Result.append (c.item.out_)
			end
		end

invariant
	squares_exists: squares /= Void
	owns_squares: owns.has (squares)
	owns_def: owns = {MML_SET [ANY]}[squares.sequence.range] + [squares]
	squares_bounds: squares.lower = Start_position and squares.sequence.count = Square_count
	squares_exist: squares.sequence.non_void
	squares_distinct: squares.sequence.no_duplicates

end
