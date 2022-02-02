note
	description: "[
		FIFO queue implemented as a ring buffer.
		https://en.wikipedia.org/wiki/Circular_buffer

		The ring buffer uses two indexes for the first element and the 
		next free slot of the buffer. The "Always keep one slot open"
		technique is used to distinguish between empty and full buffers.
		https://en.wikipedia.org/wiki/Circular_buffer#Always_Keep_One_Slot_Open
	]"
	model: sequence, capacity_

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
			empty_buffer: is_empty
			capacity_set: capacity = n
		end

feature -- Access

	item: G
			-- Current item of buffer.
		require
			not_empty: not is_empty
		do
			Result := data[start]
		ensure
			definition: Result = sequence.first
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
			definition: Result = sequence.count
		end

	capacity: INTEGER
			-- Maximum capacity of buffer.
		do
			Result := data.count - 1
		ensure
			definition: Result = capacity_
		end

feature -- Status report

	is_empty: BOOLEAN
			-- Is buffer empty?
		do
			Result := (start = free)
		ensure
			definition: Result = sequence.is_empty
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
			definition: Result = (count = capacity)
		end

feature -- Element change

	extend (a_value: G)
			-- Add `a_value' to end of buffer.
		require
			not_full: not is_full

			modify_model ("sequence", Current)
		do
			data[free] := a_value
			if free = data.count then
				free := 1
			else
				free := free + 1
			end
		ensure
			definition: sequence = old sequence.extended (a_value)
		end

	remove
			-- Remove current item from buffer.
		require
			not_empty: not is_empty

			modify_model ("sequence", Current)
		do
			if start = data.count then
				start := 1
			else
				start := start + 1
			end
		ensure
			definition: sequence = old sequence.but_first
		end

	wipe_out
			-- Remove all elements from buffer.
		require
			modify_model ("sequence", Current)
		do
			start := free
		ensure
			empty: is_empty
		end

feature -- Model

	sequence: MML_SEQUENCE [G]
			-- Sequence representation of buffer.
		note
			status: ghost
		attribute
		end

	capacity_: INTEGER
			-- Capacity of buffer.
		note
			status: ghost
		attribute
		end

feature {NONE} -- Implementation

	data: SIMPLE_ARRAY [G]
			-- Array used to store data.

	start: INTEGER
			-- Index of first element.

	free: INTEGER
			-- Index of next free position.

invariant

	data_not_void: data /= Void
	owns_definition: owns = [data]

	free_in_bounds: 1 <= free and free <= data.count
	start_in_bounds: 1 <= start and start <= data.count

	sequence_definition:
		sequence = if free < start
					then data.sequence.tail (start) + data.sequence.front (free - 1)
					else data.sequence.interval (start, free - 1) end
	capacity_definition: capacity_ = data.count - 1
	capacity_positive: capacity_ > 0

end
