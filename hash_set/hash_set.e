note
	description: "Simple hash set (with constant number of buckets). Uses a helper lock object to prevent unwwanted modification of set elements."
	manual_inv: true
	false_guards: true
	model: set, lock

class
	HASH_SET [G -> MY_HASHABLE]

create
	make

feature {NONE} -- Initialization

	make (l: LOCK [G])
			-- Create an empty set that will use the lock `l'.
		note
			status: creator
		do
			create buckets.constant ({MML_SEQUENCE [G]}.empty_sequence, 10)
			lock := l
			set_observers (create {MML_SET [ANY]} & lock)
		ensure
			set_empty: set.is_empty
			lock_set: lock = l
		end

feature -- Status report

	has (v: G): BOOLEAN
			-- Does the set contain an element equal to `v'?
		require
			v_closed: v.closed
			lock_wrapped: lock.is_wrapped
			set_registered: lock.sets [Current]
		local
			b: MML_SEQUENCE [G]
		do
			check inv; lock.inv_only ("owns_items", "valid_buckets") end
			b := buckets [bucket_index (v.hash_code, buckets.count)]
			Result := b.domain [index_of (b, v)]
		ensure
			definition: Result = set_has (v)
		end

feature -- Modification

	extend (v: G)
			-- Add `v' to the set if not already present.
		require
			v_locked: lock.owns [v]
			lock_wrapped: lock.is_wrapped
			set_registered: lock.sets [Current]
		local
			idx: INTEGER
			b: MML_SEQUENCE [G]
		do
			check lock.inv_only ("owns_items", "valid_buckets") end
			idx := bucket_index (v.hash_code, buckets.count)
			b := buckets [idx]
			if not b.domain [index_of (b, v)] then
				buckets := buckets.replaced_at (idx, b & v)
				set := set & v
				check set [v] end
			end
			check set_has (v) end
		ensure
			modify_model ("set", Current)
			abstract_effect: set_has (v)
			precise_effect_has: old set_has (v) implies set = old set
			precise_effect_new: not old set_has (v) implies set = old set & v
		end

	join (other: HASH_SET [G])
			-- Add all elements of `other' that are not already present.
			-- (The sets must share the same lock).
		note
			explicit: wrapping
		require
			lock_wrapped: lock.is_wrapped
			set_registered: lock.sets [Current]
			other_registered: lock.sets [other]
		local
			i, j: INTEGER
			ss: MML_SEQUENCE [MML_SEQUENCE [G]]
			s: MML_SEQUENCE [G]
		do
			check inv_only ("set_non_void") end
			if other /= Current then
				from
					i := 1
					ss := other.buckets
				invariant
					is_wrapped
					other.inv
					1 <= i and i <= ss.count + 1
					across 1 |..| (i - 1) as k all
						across 1 |..| (ss [k].count) as l all set_has ((ss [k]) [l]) end end
					set.old_ <= set
					across set as x all x /= Void and then (set.old_ [x] or other.set_has (x).old_) end
				until
					i > ss.count
				loop
					s := other.buckets [i]
					from
						j := 1
					invariant
						is_wrapped
						lock.inv_only ("owns_items")
						1 <= j and j <= s.count + 1
						set.old_ <= set
						across 1 |..| (j - 1) as l all set_has (s [l]) end
						across 1 |..| (i - 1) as k all
							across 1 |..| (ss [k].count) as l all set_has ((ss [k]) [l]) end end
						across set as x all x /= Void and then (set.old_ [x] or other.set_has (x).old_) end
					until
						j > s.count
					loop
						extend (s [j])
						j := j + 1
					end
					i := i + 1
				end
				check lock.inv_only ("valid_buckets") end
			end
		ensure
			modify_model ("set", Current)
			has_old: old set <= set
			has_other: across old other.set as y all y /= Void and then set_has (y) end
			no_extra: across set as x all set_has (x).old_ or other.set_has (x).old_ end
		end

	remove (v: G)
			-- Remove an element equal to `v' if present.
		require
			v_locked: lock.owns [v]
			lock_wrapped: lock.is_wrapped
			set_registered: lock.sets [Current]
		local
			b: MML_SEQUENCE [G]
			idx, i: INTEGER
			x: G
		do
			check lock.inv_only ("owns_items", "valid_buckets", "no_duplicates") end
			idx := bucket_index (v.hash_code, buckets.count)
			b := buckets [idx]
			i := index_of (b, v)
			if b.domain [i] then
				x := b [i]
				set := set / x
				buckets := buckets.replaced_at (idx, b.removed_at (i))
				x.lemma_transitive (v, set)
			end
		ensure
			modify_model ("set", Current)
			abstract_effect: not set_has (v)
			precise_effect_not_found: not old set_has (v) implies set = old set
			precise_effect_found: old set_has (v) implies
				across old set as y some (set = old set / y) and v.is_model_equal (y) end
		end

	wipe_out
			-- Remove all elements.
		require
			lock_wrapped: lock.is_wrapped
			set_registered: lock.sets [Current]
		do
			create set
			create buckets.constant ({MML_SEQUENCE [G]}.empty_sequence, buckets.count)
		ensure
			modify_model ("set", Current)
			set_empty: set.is_empty
		end

feature {HASH_SET, LOCK} -- Implementation

	bucket_index (hc, n: INTEGER): INTEGER
			-- The bucket an item with hash code `hc' belongs,
			-- if there are `n' buckets in total.
		note
			explicit: contracts
		require
			reads ([])
			n_positive: n > 0
			hc_non_negative: 0 <= hc
		do
			Result := (hc \\ n) + 1
		ensure
			in_bounds: 1 <= Result and Result <= n
		end

	index_of (b: MML_SEQUENCE [G]; v: G): INTEGER
			-- Index in `b' of an element that is equal to `v'.
		require
			v_closed: v.closed
			items_closed: across 1 |..| b.count as j all b [j].closed end
		do
			from
				Result := 1
			invariant
				1 <= Result and Result <= b.count + 1
				across 1 |..| (Result - 1) as j all not v.is_model_equal (b [j]) end
			until
				Result > b.count or else v.is_model_equal (b [Result])
			loop
				Result := Result + 1
			variant
				b.count - Result
			end
		ensure
			definition_found: b.domain [Result] implies v.is_model_equal (b [Result])
			definition_not_found: not b.domain [Result] implies across 1 |..| b.count as j all not v.is_model_equal (b [j]) end
		end

feature -- Specification

	set: MML_SET [G]
			-- Set of elements.
		note
			status: ghost
			guard: new_locked_and_in_buckets
		attribute
		end

	buckets: MML_SEQUENCE [MML_SEQUENCE [G]]
			-- Storage.
		note
			guard: not_in_set
		attribute
		end

	lock: LOCK [G]
			-- Helper object for keeping items consistent.
		note
			status: ghost
		attribute
		end

	set_has (v: G): BOOLEAN
			-- Does `set' contain an element equal to `v'?
		note
			status: ghost, functional
		require
			v_exists: v /= Void
			set_non_void: set.non_void
			reads (Current, set, v)
		do
			Result := across set as x some v.is_model_equal (x) end
		end

	no_duplicates (s: like set): BOOLEAN
			-- Are all objects in `s' unique by value?
		note
			status: ghost, functional
		require
			non_void: s.non_void
			reads (s)
		do
			Result := across s as x all across s as y all x /= y implies not x.is_model_equal (y) end end
		end

	new_locked_and_in_buckets (new_set: like set; o: ANY): BOOLEAN
			-- Are all elements of `new_set' locked and contained in appropriate buckets?
			-- (This guard allows updating `set' without notifying the lock).
		note
			status: functional
		do
			Result := lock /= Void and then
				buckets.count > 0 and then
				new_set.non_void and then
				no_duplicates (new_set) and then
				across new_set as x all
					lock.owns [x] and
					buckets [bucket_index (x.hash_code_, buckets.count)].has (x)
				end
		end

	not_in_set (new_buckets: like buckets; o: ANY): BOOLEAN
			-- Are any elements of `buckets' that are not in `new_buckets' also not is `set'?
			-- (This guard allows updating `buckets' without notifying the lock).
		note
			status: functional
		do
			Result := new_buckets.count = buckets.count and then
				across 1 |..| buckets.count as i all
					(buckets [i].range - new_buckets [i].range).is_disjoint (set) end
		end

invariant
	buckets_non_empty: not buckets.is_empty
	observers_definition: observers = create {MML_SET [ANY]} & lock
	set_non_void: set.non_void
	set_not_too_small: across 1 |..| buckets.count as i all
		across 1 |..| buckets [i].count as j all set [(buckets [i])[j]] end end
	no_precise_duplicates: across 1 |..| buckets.count as i all
		across 1 |..| buckets.count as j all
			across 1 |..| buckets [i].count as k all
				across 1 |..| buckets [j].count as l all
					i /= j or k /= l implies (buckets [i])[k] /= (buckets [j])[l] end end end end

end
