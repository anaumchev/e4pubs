class TAPE_ARCHIVE

create
	make

feature {NONE}

	make
			-- Initialize tape archive.
		note
			status: creator
		do
			create tape
			is_loaded := True
			set_owns (create {MML_SET [ANY]} & tape)
		ensure
			tape_created: tape /= Void
			loaded: is_loaded
		end

feature -- Access

	tape: TAPE
			-- Tape in archive.

	is_loaded: BOOLEAN
			-- Is archive loaded with a tape?

feature -- Basic operations

	eject
			-- Eject tape.
		do
			tape := Void
			is_loaded := False
			set_owns (create {MML_SET [ANY]})
		ensure
			tape_ejected: tape = Void
			not_loaded: not is_loaded
		end

	store (o: ANY)
			-- Store `o' on `tape'.
		require
			o_not_void: o /= Void
			o_not_current: o /= Current
			loaded: is_loaded
		do
			tape.save (o)
		end

invariant
	owns_def: is_loaded implies owns = create {MML_SET [ANY]} & tape
	loaded: is_loaded implies tape /= Void

end
