note
	description: "Implementation of a map based on two lists."

class
	MAP [K, V]

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize empty map.
		note
			status: creator
		do
			create keys.make
			create data.make
		end

feature -- Access

	item (k: K): V
			-- Element with key `k'.
		require
			has_key (k)
		local
			i: INTEGER
			found: BOOLEAN
		do
			i := index_of_key (k)
			check keys.sequence.domain.has (i) end
			Result := data.item (i)
		ensure
			across keys.sequence.domain as j some
				k = keys.sequence[j] and Result = data.sequence[j]
			end
		end

	count: INTEGER
			-- Number of elements in map.
		do
			Result := keys.count
		ensure
			Result = keys.sequence.count
		end

feature -- Status report

	has_key (k: K): BOOLEAN
			-- Is there a key `k' in the map?
		local
			i: INTEGER
		do
			Result := index_of_key (k) > 0
		ensure
			Result = keys.sequence.has (k)
		end

	has_value (v: V): BOOLEAN
			-- Is there a value `v' in the map?
		local
			i: INTEGER
		do
			from
				i := 1
			invariant
				Result implies data.sequence[i-1] = v
				not Result implies not data.sequence.interval (1, i-1).has (v)
			until
				i > data.count or Result
			loop
				Result := data.item (i) = v
				i := i + 1
			variant
				keys.count - i
			end
		ensure
			Result = data.sequence.has (v)
		end

feature -- Element change

	extend (k: K; v: V): INTEGER
			-- Extend map with key `k' mapped to `v'.
			-- Returns index of key `k' (ghost value).
		note
			status: impure
			explicit: wrapping
		do
			Result := index_of_key (k)
			unwrap
			if Result > 0 then
				check keys.sequence.to_bag.occurrences (k) = 1 end
				data.put (v, Result)
			else
				check keys.sequence.to_bag.occurrences (k) = 0 end
				keys.extend_back (k)
				data.extend_back (v)
				Result := keys.count
				check keys.sequence.to_bag.occurrences (k) = 1 end
			end
			wrap
		ensure
			modify (Current)
			key_set: keys.sequence[Result] = k
			data_set: data.sequence[Result] = v
			other_keys_unchanged: keys.sequence.interval (1, Result-1) = old keys.sequence.interval (1, Result-1)
			other_keys_unchanged: keys.sequence.interval (Result+1, keys.sequence.count) = old keys.sequence.interval (Result+1, keys.sequence.count)
			other_data_unchanged: data.sequence.interval (1, Result-1) = old data.sequence.interval (1, Result-1)
			other_data_unchanged: data.sequence.interval (Result+1, data.sequence.count) = old data.sequence.interval (Result+1, data.sequence.count)
		end

	remove (k: K): INTEGER
			-- Remove element mapped to `k'.
			-- Returns index of removed key `k' (ghost value).
		note
			status: impure
			explicit: wrapping
		require
			has_key (k)
			not_empty: count > 0

		do
			Result := index_of_key (k)
			unwrap
			keys.remove_at (Result)
			data.remove_at (Result)
			wrap
		ensure
			modify (Current)
			result_is_index: old keys.sequence[Result] = k
			key_removed: not keys.sequence.has (k)
			other_keys_unchanged: keys.sequence.interval (1, Result-1) = old keys.sequence.interval (1, Result-1)
			other_keys_unchanged: keys.sequence.interval (Result, keys.sequence.count) = old keys.sequence.interval (Result+1, keys.sequence.count+1)
			other_data_unchanged: data.sequence.interval (1, Result-1) = old data.sequence.interval (1, Result-1)
			other_data_unchanged: data.sequence.interval (Result, data.sequence.count) = old data.sequence.interval (Result+1, data.sequence.count+1)
		end

feature -- Implementation

	index_of_key (k: K): INTEGER
			-- Index of key `k'.
		local
			i: INTEGER
		do
			from
				i := 1
			invariant
				Result > 0 implies keys.sequence[Result] = k
				Result = 0 implies not keys.sequence.interval (1, i-1).has (k)
			until
				i > keys.count or Result > 0
			loop
				if keys.item (i) = k then
					Result := i
				end
				i := i + 1
			variant
				keys.count - i
			end
		ensure
			0 <= Result and Result <= count
			Result > 0 implies keys.sequence[Result] = k
			Result > 0 implies keys.sequence.to_bag.occurrences (k) = 1
			Result = 0 implies not keys.sequence.has (k)
			Result = 0 implies keys.sequence.to_bag.occurrences (k) = 0
		end

	keys: SIMPLE_LIST [K]
			-- Keys of this map.

	data: SIMPLE_LIST [V]
			-- Values of this map.

invariant
	keys /= Void and data /= Void and keys /= data
	owns = create {MML_SET [ANY]} & keys & data
	key_data_sync: keys.sequence.count = data.sequence.count
	no_duplicates: keys.sequence.to_bag.is_constant (1)

end
