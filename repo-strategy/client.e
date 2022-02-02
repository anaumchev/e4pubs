class
	CLIENT

feature

	test_strategy
			-- Demo for strategy classes.
		local
			s1, s2: OPERATOR_STRATEGY
		do
			create {ADDITION_STRATEGY} s1
			create {SUBTRACTION_STRATEGY} s2

			s1.execute (3, 4)
			s2.execute (9, 2)

			check s1.last_result = s2.last_result end
		end

end
