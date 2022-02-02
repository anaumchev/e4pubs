note
	description: "Bank account -- basic version without multi-object features."

class
	ACCOUNT_WARMUP

create
	make


feature {NONE} -- Initialization

	make
			-- Create a new account with balance of 0.
		note
			status: creator  -- Only verify `make' as constructor.
		do
			balance := 0
		ensure
			balance_zero: balance = 0
		end


feature -- Access

	balance: INTEGER
			-- Balance of this account.


feature -- Operations

	deposit (amount: INTEGER)
			-- Deposit `amount' in this account.
		require
			amount_non_negative: 0 <= amount
		do
			update_balance (amount)
		ensure
			balance_set: balance = old balance + amount
		end

	withdraw (amount: INTEGER)
			-- Withdraw `amount' from this account.
		require
			amount_non_negative: 0 <= amount
		do
			if amount <= balance then
				balance := balance - amount
			end
		ensure
			balance_set:
				( amount <= old balance )
				implies ( balance = old balance - amount )
			balance_not_set:
				( amount > old balance )
				implies ( balance = old balance )
		end


feature {NONE} -- Implementation

	update_balance (amount: INTEGER)
			-- Add `amount' (positive or negative) to `balance'.
		note
			status: inline_in_caller
		require
			inv_without ("balance_non_negative")
		do
			balance := balance + amount
		end


invariant
	balance_non_negative: balance >= 0

end
