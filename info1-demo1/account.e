class
	ACCOUNT

create
	make

feature {NONE} -- Initialization
	
	make
			-- Initialize empty account.
		note
			status: creator
		do
			balance := 0
			credit_limit := 0
		ensure
			balance_set: balance = 0
			credit_limit_set: credit_limit = 0
		end

feature -- Access

	balance: INTEGER
			-- Balance of this account.

	credit_limit: INTEGER
			-- Credit limit of this account.

	available_amount: INTEGER
			-- Amount available on this account.
		note
			status: functional
		do
			Result := balance - credit_limit
		end

feature -- Basic operations

	deposit (amount: INTEGER)
			-- Deposit `amount’ in this account.
		require
			amount_non_negative: amount >= 0
		do
			balance := balance + amount
		ensure
			balance_set: balance = old balance + amount
		end

invariant
	credit_limit_not_positive: 0 >= credit_limit
	balance_non_negative: balance >= credit_limit

end




--			modify_field (["balance", "closed"], Current)
