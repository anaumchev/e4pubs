note
	description: "Test harness for tree node."

class
	TREE_NODE_TEST

feature

	test_tree_node
		local
			n1, n2, n3, n4, n5: TREE_NODE
		do
			create n5.make (5)
			create n4.make (4)
			create n2.make_with_children (2, n4, n5)
			create n3.make (3)
			create n1.make (1)
			create n1.make_with_children (1, n2, n3)

			check n2.value = 2 end
			check assume: false end

			check n1.value = 1 end
			check n1.left = n2 and n1.right = n3 end
			check n1.maximum = 5 end

			check n2.value = 2 end
			check n2.left = n4 and n2.right = n5 end
			check n2.maximum = 5 end

			check n3.value = 3 end
			check n3.maximum = 3 end
			check n4.value = 4 end
			check n4.maximum = 4 end
			check n5.value = 5 end
			check n5.maximum = 5 end
		end

end
