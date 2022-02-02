note
	description: "Queue using a linked list as a storage back-end."

class
	MY_LINKED_QUEUE [G]

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize empty queue.
		note
			status: creator
		do
			create list.make
		ensure
			empty: is_empty
		end

feature -- Access

	item: G
			-- First element in queue.
		require
			not_empty: not is_empty
		do
			check list.inv end
			Result := list.first.value
		ensure
			definition: Result = sequence.first
		end

feature -- Status report

	is_empty: BOOLEAN
			-- Is queue empty?
		require
			reads (Current, list)
		do
			check list.inv end
			Result := list.is_empty
		ensure
			definition: Result = sequence.is_empty
		end

feature -- Element change

	extend (v: G)
			-- Extend queue with `v'.
		do
			list.extend_back (v)
			sequence := sequence & v
		ensure
			definition: sequence = (old sequence).extended (v)
		end

	remove
			-- Remove first element of queue.
		require
			not is_empty
		do
			list.remove_first
			sequence := sequence.but_first
		ensure
			definition: sequence = (old sequence).but_first
		end

feature -- Specification

	sequence: MML_SEQUENCE [G]
			-- Sequence representation of queue.
		note
			status: ghost
		attribute
		end

feature -- Implementation

	list: SINGLY_LINKED_LIST [G]
			-- Implementation of queue.

invariant
	list_not_void: list /= Void
	owns_list: owns = [list]
	sequence_definition: sequence = list.sequence

end
