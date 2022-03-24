class ACCOUNT_CLIENT

feature

	test_agents
		local
			a1, a2: ACCOUNT
			p1, p2, p3: PROCEDURE
		do
			create a1.make
			create a2.make

			p1 := agent a1.deposit (100)
			p2 := agent a1.withdraw (40)
			p3 := agent a1.transfer (20, a2)

			p1.call ([])
			p3.call ([])
			p2.call ([])
			p3.call ([])

			check a1.balance = 20 end
			check a2.balance = 40 end

--			p2.call ([]) -- uncomment to show precondition violation
		end

end
