note
	description: "[
		FIFO queue implemented as a ring buffer.
		https://en.wikipedia.org/wiki/Circular_buffer

		The ring buffer uses two indexes for the first element and the 
		next free slot of the buffer. The "Always keep one slot open"
		technique is used to distinguish between empty and full buffers.
		https://en.wikipedia.org/wiki/Circular_buffer#Always_Keep_One_Slot_Open
	]"
	-- TASK 3: Add model declaration.

class
	RING_BUFFER [G]

create
	make

feature {NONE} -- Initialization

	make (n: INTEGER)
			-- Initialize empty buffer with capacity `n'.
		note
			status: creator
		require
			n_positive: n > 0
		do
			create data.make (n + 1)
			start := 1
			free := 1
		ensure
			-- TASK 4: Add specifications.
		end

feature -- Access

	item: G
			-- Current item of buffer.
		require
			-- TASK 4: Add specifications.
		do
			Result := data[start]
		ensure
			-- TASK 4: Add specifications.
		end

	count: INTEGER
			-- Number of items in buffer.
		do
			if free >= start then
				Result := free - start
			else
				Result := data.count - start + free
			end
		ensure
			-- TASK 4: Add specifications.
		end

	capacity: INTEGER
			-- Maximum capacity of buffer.
		do
			Result := data.count - 1
		ensure
			-- TASK 4: Add specifications.
		end

feature -- Status report

	is_empty: BOOLEAN
			-- Is buffer empty?
		do
			Result := (start = free)
		ensure
			-- TASK 4: Add specifications.
		end

	is_full: BOOLEAN
			-- Is buffer full?
		do
			if start = 1 then
				Result := (free = data.count)
			else
				Result := (free = start - 1)
			end
		ensure
			-- TASK 4: Add specifications.
		end

feature -- Element change

	extend (a_value: G)
			-- Add `a_value' to end of buffer.
		require
			-- TASK 4: Add specifications.
		do
			data[free] := a_value
			if free = data.count then
				free := 1
			else
				free := free + 1
			end
		ensure
			-- TASK 4: Add specifications.
		end

	remove
			-- Remove current item from buffer.
		require
			-- TASK 4: Add specifications.
		do
			if start = data.count then
				start := 1
			else
				start := start + 1
			end
		ensure
			-- TASK 4: Add specifications.
		end

	wipe_out
			-- Remove all elements from buffer.
		require
			-- TASK 4: Add specifications.
		do
			start := free
		ensure
			-- TASK 4: Add specifications.
		end

feature -- Model

	-- TASK 3: Add model fields.

feature {NONE} -- Implementation

	data: SIMPLE_ARRAY [G]
			-- Array used to store data.

	start: INTEGER
			-- Index of first element.

	free: INTEGER
			-- Index of next free position.

invariant

	data_not_void: data /= Void

	-- TASK 1: Add ownership definition.

	-- TASK 2: Add bounds for `start' and `free' to verify array accesses.

	-- TASK 3: Add model definition.

end
