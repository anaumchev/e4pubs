deferred class
	AUTOMOBILE

feature -- Basic operations

	position: INTEGER

	brand: STRING
		deferred
		ensure
			attached Result
		end

	drive
		deferred
		ensure
			position >= old position
		end

end
