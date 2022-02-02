class ARCHIVER_APPLICATION

feature

	run (c: CLIENT; data: ANY)
			-- Run application.
		note
			explicit: contracts, wrapping
		require
			c.is_wrapped
			data.is_wrapped
			c /= data

			modify (c)
		local
			archive: TAPE_ARCHIVE
		do
			create archive.make
--			archive.eject -- comment out to see precondition violation
			c.log (agent archive.store, data)
		end

end
