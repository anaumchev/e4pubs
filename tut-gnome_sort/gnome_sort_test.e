note
	description: "Test harness for gnome sort."

class
	GNOME_SORT_TEST

feature

	test_gnome_sort
		local
			a: SIMPLE_ARRAY [INTEGER]
			s: GNOME_SORT
			input: MML_SEQUENCE [INTEGER]
		do
			input := << 0, -1, 2, -3, 4, -5 >>
			create a.init (input)
			create s

			s.gnome_sort (a)

			check a.sequence.count = input.count end
			check across 1 |..| a.count as i all i < a.count implies a[i] <= a[i+1] end end
			check a.sequence.to_bag = input.to_bag end
		end

end
