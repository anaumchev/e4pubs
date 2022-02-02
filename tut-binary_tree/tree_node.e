note
	description: "Node in a binary tree storing an integer at each node and with a `maximum' operation."

class
	TREE_NODE

create
	make, make_with_children

feature {NONE} -- Initialization

	make (a_value: INTEGER)
			-- Initialize node with `a_value'.
		note
			status: creator
		do
			value := a_value
		ensure
			value_set: value = a_value
			no_left: left = Void
			no_right: right = Void
		end

	make_with_children (a_value: INTEGER; a_left, a_right: TREE_NODE)
			-- Initialize node with `a_value' and children `a_left' and `a_right'.
		note
			status: creator
            explicit: contracts
		require
			a_left.is_wrapped
			a_right.is_wrapped

            modify (Current)
            modify_field ("owner", [a_left, a_right])
		do
			value := a_value
			left := a_left
			right := a_right
		ensure
			value_set: value = a_value
			left_set: left = a_left
			right_set: right = a_right
            default_is_closed: is_wrapped
		end

feature -- Access

	value: INTEGER
			-- Value of this node.

	left: TREE_NODE
			-- Left node (Void if none).

	right: TREE_NODE
			-- Right node (Void if none).

feature -- Element change

	set_left (a_node: TREE_NODE)
			-- Set `left' to `a_node'.
		note
			explicit: contracts
		require
			default_is_wrapped: is_wrapped
			default_is_wrapped: a_node.is_wrapped
			node_free: a_node.is_free
			node_not_current: a_node /= Current

			modify_field ("owner", a_node)
			modify_field (["closed", "left", "owns", "sequence"], Current)
		do
			left := a_node
			check right /= Void implies owns.has (right) end
		ensure
			default_is_wrapped: is_wrapped
			left_set: left = a_node
		end

	set_right (a_node: TREE_NODE)
			-- Set `right' to `a_node'.
		note
			explicit: contracts
		require
			default_is_wrapped: is_wrapped
			default_is_wrapped: a_node.is_wrapped
			node_free: a_node.is_free
			node_not_current: a_node /= Current

			modify_field ("owner", a_node)
			modify_field (["closed", "right", "owns", "sequence"], Current)
		do
			right := a_node
			check left /= Void implies owns.has (left) end
		ensure
			default_is_wrapped: is_wrapped
			right_set: right = a_node
		end

feature -- Basic operations

	maximum: INTEGER
			-- Maximum value of this tree.
		require
			decreases (sequence)
		do
			Result := value
			if left /= Void then
				check owns.has (left) end
				Result := Result.max (left.maximum)
			end
			if right /= Void then
				check owns.has (right) end
				Result := Result.max (right.maximum)
			end
		ensure
			max: across sequence.domain as i all sequence[i.item] <= Result end
			exists: sequence.has (Result)
		end

feature -- Model

	sequence: MML_SEQUENCE [INTEGER]
			-- Sequence of values.
		note
			status: ghost
		attribute
		end

invariant

	owns_definition: owns = {like owns}[[left, right]] / Void

--	owns_definition_alt: owns =
--		if left = Void then
--			if right = Void then {like owns}[[]] else {like owns}[[right]] end
--		else
--			if right = Void then {like owns}[[left]] else {like owns}[[left, right]] end
--		end

	sequence_definition: sequence =
		(if left = Void then {like sequence}.empty_sequence else left.sequence end) +
		{like sequence}[<<value>>] +
		(if right = Void then {like sequence}.empty_sequence else right.sequence end)

end
