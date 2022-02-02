note
	description : "Test harness."

class
	CLIENT

create
	test

feature -- Initialization

	test
			-- Use subjects and observers.
		note
			status: creator
		local
			s: SUBJECT
			o1, o2: OBSERVER
		do
			create s.make (1)
			create o1.make (s)
			create o2.make (s)

			s.update (5)

			check o1_synch: o1.cache = 5 end
			check o2_synch: o2.cache = 5 end
		end

end
