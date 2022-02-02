class CLIENT

feature

	log (log_file: PROCEDURE [ANY, TUPLE [ANY]]; data: ANY)
		note
			explicit: wrapping, contracts
		require
			log_file_not_void: log_file /= Void
			data_not_void: data /= Void
			data_not_current: data /= Current
			log_file_valid: log_file.precondition ([data])

			modify_agent (log_file, [data])
		do
			log_file.call ([data])
		ensure
			log_file_called: log_file.postcondition ([data])
		end

end
