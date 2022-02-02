note
	description: "Test harness for {ACCOUNT}."

class
	ACCOUNT_TEST

feature

	test_account_pass
		local
			a1, a2: ACCOUNT
		do
			create a1.make
			a1.deposit (70)

			check a1.balance = 70 end
			check a1.credit_limit = 0 end

			a1.set_credit_limit (50)

			create a2.make
			a1.transfer (100, a2)

			check a1.balance = -30 end
			check a2.balance = 100 end
		end

	test_account_fail (i: INTEGER)
		local
			a: ACCOUNT
		do
			if i = 1 then
				create a.make
				a.deposit (-1)
			elseif i = 2 then
				create a.make
				a.withdraw (10)
			elseif i = 3 then
				create a.make
				a.set_credit_limit (50)
				a.withdraw (30)
				a.set_credit_limit (10)
			end
		end

end
