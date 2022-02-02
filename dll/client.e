note
	description: "Test harness."

class CLIENT

create
	test

feature
	test
			-- Using doubly-linked list nodes.
		note
			status: creator
		local
			n1, n2: NODE
		do
			create n1.make
			check n1_singleton: n1.left = n1 end

			n1.insert_right (n1)
			check n1_singleton: n1.left = n1 end

			create n2.make
			n1.insert_right (n2)
			check connected: n1.left = n2 and n2.left = n1 end

			n2.remove
			check n2_singleton: n2.left = n2 end
			check n1_singleton: n1.left = n1 end
		end

end
