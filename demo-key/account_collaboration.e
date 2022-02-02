note
	description: "Bank account -- verified version with interest rate and managing bank."

class
	ACCOUNT_COLLABORATION

create
	make


feature {NONE} -- Initialization

	make (b: BANK)
			-- Create a new account with balance of 0,
			-- managed by bank `b'.
		note
			status: creator  -- Only verify `make' as constructor.
		require
			modify (Current, b)
		do
			balance := 0
			create transactions.make  -- Empty list of transactions.
			bank := b
			bank.register_account (Current)
			interest_rate := bank.master_rate -- Initial rate.
		ensure
			balance_zero: balance = 0
		end


feature -- Access

	balance: INTEGER
			-- Balance of this account.

	interest_rate: REAL
			-- Current interest rate for this account.

	bank: BANK
			-- Provider of this account.			


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


feature {BANK} -- Implementation

	update_rate
			-- Update `interest_rate' to bank's `master_rate'.
		require
			open: is_open
			inv_partially_holds: inv_without ("consistent_rate")
			non_negative_master_rate: bank.inv_only ("non_negative_rate")
			modify_field ("interest_rate", Current)
		do
			interest_rate := bank.master_rate
		ensure
			inv_holds: inv
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

	non_negative_rate: 0 <= interest_rate
	bank_exists: bank /= Void
	subjects_definition: subjects = [ bank ]
	consistent_rate: interest_rate = bank.master_rate

end
