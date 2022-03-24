note
	description: "Subject that keeps a list of subscribers and notifies then of its state changes."

class SUBJECT

create
	make

feature {NONE} -- Initialization

	make (v: INTEGER)
			-- Create a subject with state `v' and no subscribers.
		note
			status: creator
		do
			value := v
			create subscribers.make
			set_owns (create {MML_SET [ANY]} & subscribers)
		ensure
			value_set: value = v
			no_subscribers: subscribers.is_empty
		end

feature -- Public access

	value: INTEGER
			-- State.

	subscribers: SIMPLE_LIST [OBSERVER]
			-- List of observers subscribed to the state updates.

feature -- State update

	update (v: INTEGER)
			-- Update state to `v'.
		require
			observers_wrapped: across observers as o all o.is_wrapped end
		local
			i: INTEGER
		do
			unwrap_all (observers)
			value := v

			from
				i := 1
			invariant
				across 1 |..| (i - 1) as j all subscribers.sequence [j].inv end
				modify_field (["cache"], subscribers.sequence)
			until
				i > subscribers.count
			loop
				subscribers [i].notify
				i := i + 1
			end

			wrap_all (observers)
		ensure
			modify_field (["value", "closed"], Current)
			modify_field (["cache", "closed"], subscribers.sequence)
			observers_wrapped: across observers as o all o.is_wrapped end
			value_set: value = v
		end

feature {OBSERVER} -- Internal communication

	register (o: OBSERVER)
			-- Add `o' to `subscribers'.
		require
			wrapped: is_wrapped
			o_open: o.is_open
		do
			unwrap
			subscribers.extend_back (o)
			wrap
		ensure
			observers_extended: observers = old observers & o
			wrapped: is_wrapped
		end

invariant
	subscribers_exists: subscribers /= Void
	owns_structure: owns = create {MML_SET [ANY]} & subscribers
	all_subscribers_exist: subscribers.sequence.non_void
	observers_structure: observers = subscribers.sequence.range

note
	explicit: owns
end
