class CLIENT

feature

	make
		local
			a1, a2: ACCOUNT
		do
			create a1.make
			create a2.make
      a1.set_credit_limit (-100)
      a1.transfer (50, a2)
			
      check a1.balance = -50 end
      check a2.balance = 50 end
		end

note
  skip: True
end
