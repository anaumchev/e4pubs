note
	description: "A collection implemented using an array-based list."

frozen class MY_COLLECTION

create
	make

feature {NONE} -- Initialization

	make (c: INTEGER)
			-- Create a collection with capacity `c'.
		note
			status: creator
		require
			capacity_non_negative: c >= 0
		do
			create elements.make (c)
		ensure
			capacity_set: capacity = c
			empty: count = 0
			no_observers: observers.is_empty
		end

feature -- Access

	count: INTEGER
			-- Number of elements in the collection.

	capacity: INTEGER
			-- Maximum number of elements in the collection.
		do
			Result := elements.count
		ensure
			Result = elements.sequence.count
		end

feature -- Element change		

	add (v: INTEGER)
			-- Add `v' to the collection.
		require
			observers_wrapped: across observers as o all o.is_wrapped end
			not_full: count < capacity
		do
			unwrap_all (observers)
			set_observers (create {MML_SET [ANY]})
			count := count + 1
			elements.put (v, count)
		ensure
			modify (Current)
			modify_field ("closed", observers)
			count_increased: count = old count + 1
			no_observers: observers.is_empty
			old_observers_open: across old observers as o all o.is_open end
			elements_unchanged: elements = old elements
			capacity_unchanged: capacity = old capacity
		end

	remove_last
			-- Remove the last added elements from the collection.
		require
			observers_wrapped: across observers as o all o.is_wrapped end
			not_empty: count > 0
		do
			unwrap_all (observers)
			set_observers (create {MML_SET [ANY]})
			count := count - 1
		ensure
			modify (Current)
			modify_field ("closed", observers)
			count_decreased: count = old count - 1
			no_observers: observers.is_empty
			old_observers_open: across old observers as o all o.is_open end
			elements_unchanged: elements = old elements
			capacity_unchanged: capacity = old capacity
		end

feature {MY_ITERATOR} -- Implementation

	elements: SIMPLE_ARRAY [INTEGER]
			-- Element storage.

invariant
	elements /= Void
	owns = create {MML_SET [ANY]} & elements
	0 <= count and count <= elements.sequence.count
	across observers as o all attached o and o /= Current end

end
