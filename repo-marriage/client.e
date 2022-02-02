note
	description: "Test harness."

class
	CLIENT

feature

	make
			-- Using person objects.
		local
			alice: PERSON
			bob: PERSON
			eve: PERSON
		do
			create alice.make
			create bob.make
			create eve.make

			alice.marry (bob)
			bob.divorce
			bob.marry (eve)

			check alice.spouse = Void end
			check bob.spouse = eve end
			check eve.spouse = bob end
		end

end
