class
	CLIENT

feature -- Test

	main
		note
			status: nonvariant
		local
			a, b: AUTOMOBILE
			pos: INTEGER
		do
			create {VOLVO} a.make
			work_it (a)
			pos := a.position
			create {FIAT} b
			work_it (b)
			check a.position = pos end

		end

	work_it (a: AUTOMOBILE)
		note
			status: nonvariant
		do
			a.drive
		ensure
			modify (a)
		end

end
