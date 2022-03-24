note
	description: "Node in a binary tree storing an integer at each node and with a `maximum' operation."

class
	BINARY_NODE

create
	make, make_with_children

feature {NONE} -- Initialization

	make (a_value: INTEGER)
			-- Initialize node with `a_value'.
		note
			status: creator
		do
			value := a_value
			sequence := << value >>
		ensure
			value_set: value = a_value
			no_left: left = Void
			no_right: right = Void
		end

	make_with_children (a_value: INTEGER; a_left, a_right: BINARY_NODE)
			-- Initialize node with `a_value' and children `a_left' and `a_right'.
		note
			status: creator
      explicit: contracts
		require
			a_left.is_wrapped
			a_right.is_wrapped
      
		do
			value := a_value
			left := a_left
			right := a_right
			if left /= Void then
				sequence := left.sequence & value
			else
				sequence := << value >>
			end
			if right /= Void then
				sequence := sequence + right.sequence
			end
		ensure
      modify (Current)
      modify_field ("owner", [a_left, a_right])
			value_set: value = a_value
			left_set: left = a_left
			right_set: right = a_right
      default_is_closed: is_wrapped
		end

feature -- Access

	value: INTEGER
			-- Value of this node.

	left: BINARY_NODE
			-- Left node (Void if none).

	right: BINARY_NODE
			-- Right node (Void if none).

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
			max: across sequence.domain as i all sequence[i] <= Result end
			exists: sequence.has (Result)
		end

feature -- Specification

	sequence: MML_SEQUENCE [INTEGER]
			-- Sequence of values.
		note
			status: ghost
		attribute
		end

invariant

	owns_definition: owns = create {MML_SET [ANY]} & left & right / Void
	sequence_definition: sequence =
		((if left = Void then {like sequence}.empty_sequence else left.sequence end) & value) +
		 (if right = Void then {like sequence}.empty_sequence else right.sequence end)

end
