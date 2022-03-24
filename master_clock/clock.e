note
	description: "Slave clock whose time must not exceed its master's."

class CLOCK

create
	make

feature {NONE} -- Initialization

	make (m: MASTER)
			-- Create a slave clock with master `m'.
		note
			status: creator
		require
			m_exists: m /= Void
		do
			master := m
			local_time := master.time

			m.unwrap
			m.set_observers (m.observers & Current)
			m.wrap
		ensure
			modify (Current)
			modify_field (["observers", "closed"], m)
			master_set: master = m
			time_synchronized: local_time = m.time
			observing_master: m.observers = old m.observers & Current
		end

feature -- Access

	master: MASTER
			-- Master of this clock.

	local_time: INTEGER
			-- Local copy of master's time.

feature -- Update

	sync
			-- Sync clock to master.			
		note
			explicit: contracts, wrapping
		require
			free: is_free
			partially_holds: inv_without ("time_weakly_synchronized")
			master_wrapped: master.is_wrapped
		do
			if closed then
				unwrap
			end
			local_time := master.time
			wrap
		ensure
			modify_field (["local_time", "closed"], Current)
			time_synchronized: local_time = master.time
			wrapped: is_wrapped
		end

invariant
	master_exists: attached master
	subjects_structure: subjects = create {MML_SET [ANY]} & master
	time_non_negative: 0 <= local_time
	time_weakly_synchronized: local_time <= master.time

end
