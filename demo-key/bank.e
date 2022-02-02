class
	BANK

create
	make


feature {NONE} -- Initialization

	make
			-- Create bank with no accounts.
		note
			status: creator
		do
			create accounts.make
		end


feature	-- Access

	master_rate: REAL
			-- Master rate, to which all account rates synchronize.

	accounts: SIMPLE_LIST [ACCOUNT_COLLABORATION]
			-- Accounts at this bank.


feature -- Operations

	change_master_rate (new_rate: REAL)
			-- Change `master_rate' to `new_rate'; update all accounts accordingly.
		require
			non_negative: new_rate >= 0
			accounts_wrapped: across accounts.sequence as o all o.item.is_wrapped end
			modify_field (["master_rate", "closed"], Current)
			modify_field (["interest_rate", "closed"], accounts.sequence)
		local
			i: INTEGER
		do
			unwrap_all (observers)
			master_rate := new_rate

			from
				i := 1
			invariant
				across i |..| accounts.sequence.count as j all accounts.sequence [j.item].inv_without ("consistent_rate") end
				across 1 |..| (i - 1) as j all accounts.sequence [j.item].inv end
				modify_field (["interest_rate"], accounts.sequence)
			until
				i > accounts.count
			loop
				accounts [i].update_rate
				i := i + 1
			end

			wrap_all (observers)
		ensure
			rate_set: master_rate = new_rate
			accounts_wrapped: across accounts.sequence as o all o.item.is_wrapped end
		end


feature {ACCOUNT_COLLABORATION} -- Implementation

	register_account (new_account: ACCOUNT_COLLABORATION)
			-- Add `new_account' to `accounts'.
		require
			wrapped: is_wrapped
		do
			unwrap
			accounts.extend_back (new_account) -- Add account to list of managed accounts.
			Current.observers := observers & new_account -- Add account to observers (& is union).
			wrap
		ensure
			wrapped: is_wrapped
			account_added: accounts.sequence.last = new_account
		end


invariant
	non_negative_rate: 0 <= master_rate
	accounts_exist: accounts /= Void

	owns = [ accounts ]
		-- The *list* of accounts is part of the bank's internal representation.

	observers = accounts.sequence.range
		-- The actual accounts are observers of the bank's.

end
