note
	description: "Coincidence count."

class
	CC

feature

	cc (a, b: MML_SEQUENCE [INTEGER]): INTEGER
			-- Number of common element occurrences in `a' and `b'.
		note
			status: functional
		do
			Result := (a.to_bag * b.to_bag).count
		end

	increasing (s: MML_SEQUENCE [INTEGER]): BOOLEAN
			-- `s' is stricktly increasing.
		note
			status: functional
		do
			Result := across s.domain as i all across s.domain as j all i < j implies s [i] < s[j] end end
		end

	outsider (s: MML_SEQUENCE [INTEGER]; i, x: INTEGER)
			-- In a stricktly sorted `s', if `x' is less than `s[i]' then it does not occur in `s.tail (i)'.
		note
			status: lemma
		require
			increasing: increasing (s)
			i_in_bound: 1 <= i and i <= s.count + 1
			outsider: i = s.count + 1 or else x < s [i]
		do
			if i /= s.count + 1 then
				check across s.domain as j all i < j implies s [i] < s [j] end end
			end
		ensure
			s.tail (i).to_bag [x] = 0
		end

	compute_cc (a, b: MML_SEQUENCE [INTEGER]): INTEGER
			-- Compute coincidence count of strictly sorted sequences `a' and `b'.
		note
			status: impure
		require
			increasing (a)
			increasing (b)
		local
			i, j: INTEGER
		do
			from
				i := 1
				j := 1
			invariant
				i_in_bounds: 1 <= i and i <= a.count + 1
				j_in_bounds: 1 <= j and j <= b.count + 1
				count_correct: cc (a, b) = Result + cc (a.tail (i), b.tail (j))
			until
				i > a.count or j > b.count
			loop
				check a.tail (i) = (<< a[i] >>).to_mml_sequence + a.tail (i + 1) end
				check b.tail (j) = (<< b[j] >>).to_mml_sequence + b.tail (j + 1) end
				if a [i] < b[j] then
					outsider (b, j, a[i])
					check a.tail (i).to_bag * b.tail (j).to_bag = a.tail (i + 1).to_bag * b.tail (j).to_bag end
					i := i + 1
				elseif b [j] < a[i] then
					outsider (a, i, b[j])
					check a.tail (i).to_bag * b.tail (j).to_bag = a.tail (i).to_bag * b.tail (j + 1).to_bag end
					j := j + 1
				else
					check a.tail (i).to_bag * b.tail (j).to_bag = (a.tail (i + 1).to_bag * b.tail (j + 1).to_bag) + (create {MML_BAG[INTEGER]}.singleton (a[i])) end
					Result := Result + 1
					i := i + 1
					j := j + 1
				end
			variant
				a.count + b.count - i - j
			end
		ensure
			count_correct: Result = cc (a, b)
		end
end
