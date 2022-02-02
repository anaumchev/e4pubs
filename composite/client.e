note
	description: "Test harness."

class CLIENT

create
	test

feature {NONE} -- Initialization

	test
			-- Using composites.
		note
			status: creator
		local
			c1, c2, c3: COMPOSITE
		do
			create c1.make (1)
			create c2.make (2)
			create c3.make (0)

			c1.add_child (c2)
			check c1.value >= c2.value end
			c2.add_child (c3)
			check c2.value >= c3.value end
		end

end
