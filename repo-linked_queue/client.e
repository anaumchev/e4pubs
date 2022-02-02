note
	description: "Test harness."

class
	CLIENT

feature

	test
			-- Using linked queue.
		local
			q: MY_LINKED_QUEUE [INTEGER]
		do
			create q.make
			q.extend (23)
			check q.item = 23 end
			q.extend (13)
			check q.item = 23 end
			q.remove
			q.extend (31)
			check q.item = 13 end
			q.remove
			check q.item = 31 end
			q.remove
			check q.is_empty end
		end

end
