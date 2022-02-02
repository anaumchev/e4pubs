note
	description: "Linked list using singly linked nodes and with an `index_of' operation."

class
	SINGLY_LINKED_LIST [G]

feature -- Access

	first: LINKED_NODE [G]
			-- First node in list.

	last: LINKED_NODE [G]
			-- Last node in list.

	count: INTEGER
			-- Number of elements in list.

feature -- Status report

	is_empty: BOOLEAN
			-- Is list empty?
		note
			status: functional
		require
			reads (Current)
		do
			Result := first = Void
		end

feature -- Element change

	extend_back (a_value: G)
			-- Extend list at back with `a_value'.
		local
			l_node: LINKED_NODE [G]
		do
			create l_node.make (a_value)
			if first = Void then
				first := l_node
			else
				last.set_next (l_node)
			end
			last := l_node
			count := count + 1

			nodes := nodes & l_node
			sequence := sequence & a_value
		ensure
			sequence_effect: sequence ~ (old sequence) & a_value
			nodes_effect: nodes ~ (old nodes) & last
		end

feature -- Basic operations

	index_of (v: G): INTEGER
			-- First index of `v'.
			-- Returns `count' + 1 if `v' is not in list.
		require
			count > 0
		local
			i: LINKED_NODE [G]
		do
			from
				i := first
				Result := 1
			invariant
				result_in_range: 1 <= Result and Result <= count + 1
				result_c_relation: 1 <= Result and Result <= count implies i = nodes[Result]
				i_at_end: i = Void implies Result = count + 1
				i_in_range: i /= Void implies i = nodes[Result]
				v_not_yet: not sequence.front (Result - 1).has (v)
			until
				i = Void or else i.value = v
			loop
				Result := Result + 1
				i := i.next
			variant
				count + 1 - Result
			end
		ensure
			not_found: not sequence.has (v) implies Result = count + 1
			found: sequence.has (v) implies 1 <= Result and Result <= count and then sequence [Result] = v
			v_not_in_front: not sequence.front (Result - 1).has (v)
		end

feature -- Specification

	sequence: MML_SEQUENCE [G]
			-- Sequence of elements.
		note
			status: ghost
		attribute
		end

	nodes: MML_SEQUENCE [LINKED_NODE [G]]
			-- Sequence of nodes.
		note
			status: ghost
		attribute
		end

	is_linked (ns: like nodes): BOOLEAN
			-- Are adjacent nodes of `ns' liked to each other?
		note
			status: ghost, functional
		require
			ns.non_void
			reads_field ("next", ns)
		do
			Result := across 1 |..| ns.count as i all
				across 1 |..| ns.count as j all
					i.item + 1 = j.item implies ns [i.item].next = ns [j.item] end end
		end

invariant
	count_definition: count = sequence.count
	nodes_domain: sequence.count = nodes.count
	first_void: nodes.is_empty = (first = Void)
	last_void: nodes.is_empty = (last = Void)
	owns_definition: owns = nodes.range
	nodes_exist: nodes.non_void
	sequence_implementation: across 1 |..| nodes.count as i all sequence [i.item] = nodes [i.item].value end
	nodes_linked: is_linked (nodes)
	nodes_first: nodes.count > 0 implies first = nodes.first
	nodes_last: nodes.count > 0 implies last = nodes.last and then last.next = Void

end
