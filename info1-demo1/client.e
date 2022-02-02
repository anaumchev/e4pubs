class CLIENT

feature

	make
		local
			a: ACCOUNT
		do
			create a.make
			
			a.deposit (100)
			
			check a.balance = 100 end
			check a.credit_limit = 0 end
		end

end
