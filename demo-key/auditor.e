note
	description: "Auditor of bank accounts, which performs unsafe operations."

class
	AUDITOR


feature -- Operations

	audit (an_account: ACCOUNT_OWNERSHIP)
		note
			explicit: wrapping
		local
			transactions: SIMPLE_LIST [INTEGER]
		do
			transactions := an_account.leak_transactions
				-- The leaked transactions list can be modified
				-- only if it is wrapped; which is possible
				-- only by explicitly invalidating `an_account':
				-- stability is enforced.
			transactions.extend_front (0)
		ensure
			modify (an_account)
			account_valid: an_account.is_wrapped
		end

	audit_unsafe (an_account: ACCOUNT_OWNERSHIP)
		note
			explicit: "all"
		require
			an_account.is_wrapped
		local
			transactions: SIMPLE_LIST [INTEGER]
		do
			transactions := an_account.leak_transactions_unsafe
			transactions.extend_front (0)
		ensure
			modify (an_account)
			account_invalid: an_account.is_open
		end

end
