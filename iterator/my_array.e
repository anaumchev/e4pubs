note
	description: "Minimal array interface (non-generic)."
	status: skip

class MY_ARRAY

create
	make

feature {NONE} -- Initialization

	make (n: INTEGER)
			-- Create an array of size `n'.
		note
			status: creators
		require
			size_non_negative: n >= 0
		do
		ensure
			count_set: count = n
		end

feature -- Access		

	count: INTEGER
			-- Size of the array.

	item alias "[]" (i: INTEGER): INTEGER
			-- Element at position `i'.
		require
			closed: closed
			in_bounds: 1 <= i and i <= count
		do
		end

feature -- Update	

	put (v, i: INTEGER)
			-- Replace element at position `i' with `v'.
		require
			in_bounds: 1 <= i and i <= count
		do
		ensure
			new_item: item (i) = v
			same_size: count = old count
		end

invariant
	count_non_negative: count >= 0

end
