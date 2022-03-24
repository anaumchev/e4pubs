note
	description: "Node in a linked list carrying a value and next pointer."

class
	LINKED_NODE [G]

create
	make

feature {NONE} -- Initialization

	make (a_value: G)
			-- Initialize node with `a_value'.
		note
			status: creator
		do
			value := a_value
		ensure
			value_set: value = a_value
			next_void: next = Void
		end

feature -- Access

	value: G
			-- Value of node.

	next: LINKED_NODE [G]
			-- Next node.

feature -- Element change

	set_next (a_node: LINKED_NODE [G])
			-- Set `next' to `a_node'.
		do
			next := a_node
		ensure
			modify_field (["next", "closed"], Current)
			next_set: next = a_node
		end

end
