note
	description: "Person with marry and divorce operations."

frozen class
	PERSON

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize person.
		note
			status: creator
		do
			spouse := Void
		ensure
			spouse = Void
		end

feature -- Access

	spouse: PERSON
			-- Spouse of person

feature -- Basic operations

	marry (a_other: attached PERSON)
			-- Marry person `a_other'.
		require
			other_not_void: a_other /= Void
			other_not_current: a_other /= Current
			other_not_married: a_other.spouse = Void
			current_not_married: spouse = Void

			modify (Current, a_other)
		do
			a_other.unwrap

			spouse := a_other
			a_other.set_spouse (Current)

			set_subjects ([spouse])
			set_observers ([spouse])
			a_other.set_subjects ([Current])
			a_other.set_observers ([Current])

			a_other.wrap
		ensure
			married_to_other: spouse = a_other
			married_to_current: a_other.spouse = Current
		end

	divorce
			-- Divorce from `spouse'.
		require
			married: spouse /= Void
			spouse_wrapped: spouse.is_wrapped

			modify (Current, spouse)
		do
			spouse.unwrap

			spouse.set_spouse (Void)

			spouse.set_subjects ([])
			spouse.set_observers ([])
			set_subjects ([])
			set_observers ([])

			spouse.wrap
			spouse := Void
		ensure
			not_married: spouse = Void
			old_spouse_not_married: (old spouse).spouse = Void
			old_spouse_wrapped: (old spouse).is_wrapped
		end

feature {PERSON} -- Implementation

	set_spouse (a_person: PERSON)
			-- Set `spouse' to `a_person'.
		note
			explicit: contracts, wrapping
		require
			person_not_current: a_person /= Current
			open: is_open
			observers_open: across observers as o all o.item.is_open end

			modify_field ("spouse", Current)
		do
			spouse := a_person
		ensure
			spouse_set: spouse = a_person
		end

invariant
	subjects_definition: if spouse = Void then subjects = [] else subjects = [spouse] end
	observers_definition: observers = subjects
	not_married_to_self: spouse /= Current
	marriage_symmetric: spouse /= Void implies spouse.spouse = Current

end
