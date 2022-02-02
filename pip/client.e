note
	description: "Test harness."

class CLIENT

create
	test

feature {NONE} -- Initialization

	test
			-- Using PIP nodes.
		note
			status: creator
		local
			c1, c2, c3: NODE
			a1, a2, a3: MML_SET [NODE]
		do
			create c1.make (1)
			create c2.make (2)
			create c3.make (0)

			a1 := << c1 >>
			c1.acquire (c2, a1)
			check c1.value = 2 end

			a2 := << c1, c2 >>
			c2.acquire (c3, a2)
			check c1.value = 2 end
			check c2.value = 2 end
			check c3.value = 0 end

			a3 := << c1, c2, c3 >>
			c3.acquire (c1, a3)
			check c1.value = c2.value end
			check c2.value = c3.value end
			check c3.value = 2 end
		end

end
