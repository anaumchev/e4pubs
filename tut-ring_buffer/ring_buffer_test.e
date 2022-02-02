note
	description: "Test harness for ring buffer."

class
	RING_BUFFER_TEST

feature

	test_ring_buffer_pass1
		local
			b: RING_BUFFER [INTEGER]
		do
			create b.make (10)

			check b.capacity = 10 end
			check b.count = 0 end

			b.extend (5)
			b.extend (8)

			check b.capacity = 10 end
			check b.count = 2 end
			check b.item = 5 end

			b.remove

			check b.capacity = 10 end
			check b.item = 8 end

			b.remove

			check b.capacity = 10 end
		end

	test_ring_buffer_pass2
		local
			b: RING_BUFFER [INTEGER]
		do
			create b.make (2)

			check b.capacity = 2 end
			check b.count = 0 end

			b.extend (-4)
			b.extend (19)

			check b.capacity = 2 end
			check b.count = 2 end
			check b.item = -4 end
			check b.is_full end

			b.remove

			check b.capacity = 2 end
			check b.count = 1 end
			check b.item = 19 end
			check not b.is_full end
			check not b.is_empty end

			b.extend (36)

			check b.capacity = 2 end
			check b.count = 2 end
			check b.item = 19 end
			check b.is_full end
			check not b.is_empty end
		end

	test_ring_buffer_pass3
		local
			b: RING_BUFFER [INTEGER]
		do
			create b.make (2)

			b.extend (25)
			b.extend (43)

			check not b.is_empty end
			b.wipe_out
			check b.is_empty end
		end

	test_ring_buffer_fail1 (i: INTEGER)
		local
			b: RING_BUFFER [INTEGER]
			t: INTEGER
		do
			if i = 1 then
				create b.make (0)
			elseif i = 2 then
				create b.make (1)
				b.remove
			elseif i = 3 then
				create b.make (4)
				t := b.item
			end
		end

	test_ring_buffer_fail2 (i: INTEGER)
		local
			b: RING_BUFFER [INTEGER]
		do
			if i = 1 then
				create b.make (1)
				b.extend (4)
				b.extend (5)
			elseif i = 2 then
				create b.make (1)
				b.extend (6)
				check not b.is_full end
			elseif i = 3 then
				create b.make (1)
				b.extend (7)
				b.remove
				check not b.is_empty end
			end
		end

end
