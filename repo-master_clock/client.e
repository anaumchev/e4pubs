note
	description : "Test harness."

class
	CLIENT

feature -- Initilization

	test
			-- Use master and slave clocks.
		local
			m: MASTER
			c1, c2: CLOCK
		do
			create m.make
			create c1.make (m)
			create c2.make (m)

			m.tick
			-- Still weakly synchronized, according to the invariant
			check c1_in_synch: c1.local_time <= m.time end
			check c2_in_synch: c2.local_time <= m.time end

			c1.sync
			c2.sync

			unwrap_all (create {MML_SET [ANY]} & c1 & c2)
			m.reset
			-- sync can be called on both wrapped and open clocks:
			c1.sync
			c2.sync

			-- Synchronized again, thanks to sync
			check c1_in_synch: c1.local_time <= m.time end
			check c2_in_synch: c2.local_time <= m.time end
		end

end
