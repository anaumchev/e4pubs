note
	description: "Linked list using singly linked nodes."

class
	SINGLY_LINKED_LIST [G]

create
    make

feature {NONE} -- Initialization

	make
			-- Initialize empty list.
		note
			status: creator
		do
			first := Void
			last := Void
			count := 0
		ensure
			empty: is_empty
		end

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

	extend_front (a_value: G)
			-- Extend list at front with `a_value'.
		local
			l_node: LINKED_NODE [G]
		do
			create l_node.make (a_value)
			if first = Void then
				first := l_node
				last := l_node
			else
				l_node.set_next (first)
				first := l_node
			end
			count := count + 1

			nodes := nodes.prepended (l_node)
			sequence := sequence.prepended (a_value)
		ensure
			sequence_effect: sequence ~ old (sequence).prepended (a_value)
			nodes_effect: nodes ~ (old nodes).prepended (first)
		end

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

	remove_first
			-- Remove fist element.
		require
			not_empty: count > 0
		do
			if count = 1 then
				first := Void
				last := Void
			else
				check first.next = nodes [2] end
				first := first.next
			end
			count := count - 1

			nodes := nodes.but_first
			sequence := sequence.but_first
		ensure
			sequence_effect: sequence ~ (old sequence).but_first
			nodes_effect: nodes ~ old nodes.but_first
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
