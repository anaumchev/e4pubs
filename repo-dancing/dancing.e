note
	description: "Node in a circular doubly-linked list that retain pointers to its neighbors upon removal from the list and thus can be 'un-removed' (reinserted at the same position)."

frozen class DANCING

create
	make

feature {NONE} -- Initialization

	make
			-- Create a singleton node.
		note
			status: creator
		do
			left := Current
			right := Current
		ensure
			singleton: left = Current
		end

feature -- Access

	left: DANCING
			-- Left neighbor.
		note
			guard: not_left
		attribute
		end

	right: DANCING
			-- Right neighbor.			
		note
			guard: not_right
		attribute
		end

feature -- Modification

	insert_right (n: DANCING)
			-- Insert node `n' to the right of the current node.
		note
			explicit: wrapping
		require
			n_singleton: n.left = n
			right_wrapped: right.is_wrapped
		local
			r: DANCING
		do
			r := right
			unwrap_all (create {MML_SET [ANY]} & Current & r & n)

			n.set_right (r)
			n.set_left (Current)

			r.set_left (n)
			set_right (n)

			n.set_subjects (create {MML_SET [ANY]} & r & Current)
			n.set_observers (create {MML_SET [ANY]} & r & Current)
			set_subjects (create {MML_SET [ANY]} & left & n)
			set_observers (create {MML_SET [ANY]} & left & n)
			r.set_subjects (create {MML_SET [ANY]} & n & r.right)
			r.set_observers (create {MML_SET [ANY]} & n & r.right)
			wrap_all (create {MML_SET [ANY]} & Current & r & n)
		ensure
			modify_field (["right", "closed", "subjects", "observers"], Current)
			modify_field (["left", "closed", "subjects", "observers"], right)
			modify (n)
			n_left_set: right = n
			n_right_set: n.right = old right
			old_right_wrapped: (old right).is_wrapped
		end

	remove
			-- Remove the current node from the list.
		note
			explicit: wrapping, contracts
		require
			wrapped: is_wrapped	-- Current is consistent (class invariant holds)
			left_wrapped: left.is_wrapped -- left is consistent
			right_wrapped: right.is_wrapped -- right is consistent
		do
			unwrap_all (create {MML_SET [ANY]} & Current & left & right)	-- Ghost: open objects for modification

			left.set_right (right)	-- R[L[x]] := R[x]
			right.set_left (left)	-- L[R[x]] := L[x]

			left.set_subjects (create {MML_SET [ANY]} & left.left & right)	-- Ghost: update subjects set
			left.set_observers (create {MML_SET [ANY]} & left.left & right)	-- Ghost: update observers set
			right.set_subjects (create {MML_SET [ANY]} & left & right.right)	-- Ghost: update subjects set
			right.set_observers (create {MML_SET [ANY]} & left & right.right)	-- Ghost: update observers set
			if left /= Current then
				check right /= Current end	-- Follows from the invariant
				wrap_all (create {MML_SET [ANY]} & left & right)	-- Ghost: close objects after checking their invariant
			end
		ensure
			modify_field (["closed"], Current)
			modify_field (["left", "closed", "subjects", "observers"], right)
			modify_field (["right", "closed", "subjects", "observers"], left)
			open: is_open	-- Current remains detached from the rest of the list (invariant might not hold)
			inv_without ("left_consistent", "right_consistent", "A2")	-- All invariant clauses except those listed hold
			left_unchanged: left = old left
			right_unchanged: right = old right
			left_wrapped: left /= Current implies left.is_wrapped		-- Consistent, unless aliased to Current
			right_wrapped: right /= Current implies right.is_wrapped	-- Consistent, unless aliased to Current
			neighbors_connected: left.right = right
		end

	unremove
			-- Reinsert the current node into the previous position.
		note
			explicit: wrapping, contracts
		require
			open: is_open
			inv_without ("left_consistent", "right_consistent", "A2")
			left_wrapped: left /= Current implies left.is_wrapped
			right_wrapped: right /= Current implies right.is_wrapped
			both_or_neither: (left = Current) = (right = Current)
			neighbors_connected: left.right = right
			left_exists: left /= Void
			right_exists: right /= Void
		do
			if left /= Current then
				unwrap_all (create {MML_SET [ANY]} & left & right)
			end

			left.set_right (Current)	-- R[L[x]] := x
			right.set_left (Current)	-- L[R[x]] := x

			left.set_subjects (create {MML_SET [ANY]} & left.left & Current)
			left.set_observers (create {MML_SET [ANY]} & left.left & Current)
			right.set_subjects (create {MML_SET [ANY]} & Current & right.right)
			right.set_observers (create {MML_SET [ANY]} & Current & right.right)
			wrap_all (create {MML_SET [ANY]} & Current & left & right)
		ensure
			modify_field (["closed"], Current)
			modify_field (["left", "closed", "subjects", "observers"], right)
			modify_field (["right", "closed", "subjects", "observers"], left)
			wrapped: is_wrapped		-- Current is back in the list (invariant holds)
			left_wrapped: left.is_wrapped	-- Left is consistent
			right_wrapped: right.is_wrapped	-- Right is consistent
			left_unchanged: left = old left
			right_unchanged: right = old right
		end

feature {DANCING} -- Implementation

	set_left (n: DANCING)
			-- Set left neighbor to `n'.
		require
			open: is_open
			left_open: left.is_open
		do
			left := n -- preserves `right'
		ensure
			modify_field ("left", Current)
			left = n
		end

	set_right (n: DANCING)
			-- Set right neighbor to `n'.
		require
			open: is_open
			right_open: right.is_open
		do
			right := n -- preserves `left'
		ensure
			modify_field ("right", Current)
			right = n
		end

feature -- Specification

	not_left (new_left: DANCING; o: ANY): BOOLEAN
			-- Is `o' different from `left'?
		note
			status: functional
		do
			Result := o /= left
		end

	not_right (new_right: DANCING; o: ANY): BOOLEAN
			-- Is `o' different from `right'?
		note
			status: functional
		do
			Result := o /= right
		end

invariant
	left_exists: left /= Void
	right_exists: right /= Void
	subjects_structure: subjects = create {MML_SET [ANY]} & left & right -- Objects the invariant depends on
	observers_structure: observers = create {MML_SET [ANY]} & left & right -- Objects whose invariant can depend on Current
	left_consistent: left.right = Current
	right_consistent: right.left = Current

end
