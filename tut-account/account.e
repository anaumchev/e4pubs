note
	description: "Account class with balance and credit limit."
	model: balance, credit_limit

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
			Result := balance + credit_limit
		end

feature -- Element change

	set_credit_limit (limit: INTEGER)
			-- Set `credit_limit' to `limit'.
		require
			limit_valid: limit >= (0).max(-balance)

		do
			credit_limit := limit
		ensure
			modify_model ("credit_limit", Current)
			credit_limit_set: credit_limit = limit
		end

	deposit (amount: INTEGER)
			-- Deposit `amount’' in this account.
		require
			amount_non_negative: amount >= 0

		do
			balance := balance + amount
		ensure
			modify_model ("balance", Current)
			balance_set: balance = old balance + amount
		end

	withdraw (amount: INTEGER)
			-- Withdraw `amount’' from this account.
		require
			amount_not_negative: amount >= 0
			amount_available: amount <= available_amount

		do
			balance := balance - amount
		ensure
			modify_field (["balance", "closed"], Current)
			balance_set: balance = old balance - amount
		end

feature -- Basic operations

	transfer (amount: INTEGER; other: ACCOUNT)
			-- Transfer `amount' from this account to `other'.
		require
			amount_not_negative: amount >= 0
			amount_available: amount <= available_amount
			no_aliasing: other /= Current

		do
			balance := balance - amount
			other.deposit (amount)
		ensure
			modify (Current, other)
			withdrawal_made: balance = old balance - amount
			despoit_made: other.balance = old other.balance + amount
			same_credit_limit: credit_limit = old credit_limit
			other_same_credit_limit: other.credit_limit = old other.credit_limit
		end

invariant
	credit_limit_not_negative: credit_limit >= 0
	balance_not_below_credit: balance >= -credit_limit

end
