note
	description: "Observer that needs to maintain a cache of its subject's state."

class
	OBSERVER

create
	make

feature {NONE} -- Initialization

	make (s: SUBJECT)
			-- Create an observer subscribed to `s'.
		note
			status: creator
		require
			s_exists: s /= Void
		do
			subject := s
			s.register (Current)
			cache := s.value
		ensure
			modify (s, Current)
			subject_set: subject = s
			observeing_subject: s.observers = old s.observers & Current
		end

feature -- Public access

	subject: SUBJECT
			-- Subject.

	cache: INTEGER
			-- Copy of subject's state.

feature {SUBJECT} -- Internal communication

	notify
			-- Update `cache' according to the state `subject'.
		require
			open: is_open
			partially_holds: inv_without ("cache_synchronized")
		do
			cache := subject.value
		ensure
			modify_field ("cache", Current)
			invariant_holds: inv
		end

invariant
	subject_exists: subject /= Void
	subjects_structure: subjects = create {MML_SET [ANY]} & subject
	subject_aware: subject.observers.has (Current)
	cache_synchronized: cache = subject.value
end
