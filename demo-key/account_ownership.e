note
	description: "Bank account -- verified version with list of transactions."

class
	ACCOUNT_OWNERSHIP

create
	make


feature {NONE} -- Initialization

	make
			-- Create a new account with balance of 0.
		note
			status: creator  -- Only verify `make' as constructor.
		do
			balance := 0
			create transactions.make  -- Empty list of transactions.
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
			transactions.extend_back (amount)
			check transactions.sequence.old_ = transactions.sequence.but_last end
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
				transactions.extend_back (-amount)
				check transactions.sequence.old_ = transactions.sequence.but_last end
			end
		ensure
			balance_set:
				( amount <= old balance )
				implies ( balance = old balance - amount )
			balance_not_set:
				( amount > old balance )
				implies ( balance = old balance )
		end


feature  -- Breaking encapsulation

	leak_transactions: SIMPLE_LIST [INTEGER]
			-- Reference to internal list of transactions
		do
			Result := transactions
		ensure
			result_transactions: Result = transactions
				-- Cannot prove that the result is consistent
				-- because `Current' owns `transactions'
			result_consistent: Result.is_wrapped
		end

	leak_transactions_unsafe: SIMPLE_LIST [INTEGER]
			-- Reference to internal list of transactions;
			-- leaves `Current' unwrapped.
		note
			explicit: "all"	-- forgo default annotations
			status: impure  -- ignore command/query separation
		require
			is_wrapped		-- start from consistent `Current',
							-- otherwise cannot guarantee anything about `transactions'
			modify_field ("closed", Current)
		do
			Result := transactions
			unwrap			-- open `Current'
		ensure
			consistency_broken: is_open
			result_transactions: Result = transactions
				-- Can prove that the result is consistent
				-- because `Current' does not own `transactions' anymore
			result_consistent: Result.is_wrapped
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

	transactions: SIMPLE_LIST [INTEGER]
		-- History of transactions:
		--           positive integer = deposited amount
		--           negative integer = withdrawn amount
		--           latest transactions in back of list


feature -- Specification

	sum (s: MML_SEQUENCE [INTEGER]): INTEGER
			-- Sum of elements of a sequence.
		note
			status: functional, ghost
		require
			reads ([])
		do
			Result := if s.is_empty then 0 else sum (s.but_last) + s.last end
		end


invariant
	balance_non_negative: balance >= 0

	transactions /= Void
	owns = [ transactions ]  -- The account controls access to list of transactions.
	balance = sum (transactions.sequence)

end
