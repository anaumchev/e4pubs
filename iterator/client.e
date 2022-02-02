note
	description : "Test harness."

class CLIENT

create
	test

feature {NONE} -- Initialization

	test
			-- Use collections and iterators.
		note
			status: creator
--			explicit: contracts, wrapping
		local
			c: MY_COLLECTION
			i1, i2: MY_ITERATOR
			v: INTEGER
		do
			create c.make (10)
			c.add (1)
			c.add (2)

			create i1.make (c)
			i1.forth
			if not i1.after then
				v := i1.item
			end

			create i2.make (c)
			i2.forth
			if not i2.after then
				v := i2.item
			end

			c.remove_last

			-- Comment out the following line to see that
			-- the client cannot access disabled iterators:
			create i1.make (c)
			if not i1.after then
				i1.forth
			end

		end

end
