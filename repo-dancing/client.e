note
	description: "Testing removal followed by unremoval"

class
	CLIENT

feature

	test_singleton
			-- Test with a singleton list.
		local
			n1: DANCING
		do
			create n1.make
			check n1.right = n1 end
			check n1.left = n1 end

			n1.remove

			n1.unremove
			check n1.right = n1 end
			check n1.left = n1 end
		end

	test_remove_once
			-- Test with a three-element list, single removal.
		local
			n1, n2, n3: DANCING
		do
			create n1.make
			create n2.make
			create n3.make

			n1.insert_right (n2)
			n2.insert_right (n3)

			check n1.right = n2 end
			check n1.left = n3 end
			check n2.right = n3 end
			check n2.left = n1 end
			check n3.right = n1 end
			check n3.left = n2 end

			n2.remove

			check n1.right = n3 end
			check n1.left = n3 end
			check n2.right = n3 end
			check n2.left = n1 end
			check n3.right = n1 end
			check n3.left = n1 end

			n2.unremove

			check n1.right = n2 end
			check n1.left = n3 end
			check n2.right = n3 end
			check n2.left = n1 end
			check n3.right = n1 end
			check n3.left = n2 end
		end

	test_remove_multiple
			-- Test with a three-element list, multiple removals.
		local
			n1, n2, n3: DANCING
		do
			create n1.make
			create n2.make
			create n3.make

			n1.insert_right (n2)
			n2.insert_right (n3)

			check n1.right = n2 end
			check n1.left = n3 end
			check n2.right = n3 end
			check n2.left = n1 end
			check n3.right = n1 end
			check n3.left = n2 end

			n1.remove
			n2.remove
			n3.remove

			n3.unremove
			n2.unremove
			n1.unremove

			check n1.right = n2 end
			check n1.left = n3 end
			check n2.right = n3 end
			check n2.left = n1 end
			check n3.right = n1 end
			check n3.left = n2 end
		end

end