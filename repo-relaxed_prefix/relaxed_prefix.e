note
	description: "Algorithm to determine if a sequence is a relaxed prefix of another sequence."
class
	RELAXED_PREFIX

feature

	is_relaxed_prefix (pat, a: MML_SEQUENCE [INTEGER]): TUPLE [res: BOOLEAN; idx1: INTEGER; idx2: INTEGER]
			-- Is any sequence obtained from `pat' by removing at most one character a prefix of `a'?
			-- If yes, `Result.res' is True and `Result.idx1' is the position of the removed character (0 if no character has been removed).
			-- If no, `Result.res' is False and `Result.idx1' and `Result.idx2' are positions of two mismatched characters.
		local
			i: INTEGER
			shift: INTEGER -- How many unmatching positions in `pat' we have already encoutered?
		do
			if pat.count > a.count + 1 then
				Result := [False, a.count + 1, a.count + 2]
			else
				from
					Result := [True, 0, 0]
					i := 1
				invariant
					i_in_bounds: 1 <= i and i <= pat.count + 1
					shift_up_to_two: 0 <= shift and shift <= 2
					shift_zero: (shift = 0) = (Result.idx1 = 0)
					shift_one: (shift = 1) = (1 <= Result.idx1 and Result.idx1 < i and Result.idx2 = 0)
					shift_two: (shift = 2) = (1 <= Result.idx1 and Result.idx1 < Result.idx2 and Result.idx2 < i)
					shift_result: (shift = 2) = (not Result.res)

					match_up_to_idx1: across 1 |..| (Result.idx1 - 1) as k all pat [k] = a [k] end
					no_shift_match: shift = 0 implies across 1 |..| (i - 1) as k all pat [k] = a [k] end
					one_shift_match: shift = 1 implies across (Result.idx1 + 1) |..| (i - 1) as k all pat [k] = a [k - 1] end
					first_mismatch: shift >= 1 implies (Result.idx1 > a.count or else pat [Result.idx1] /= a [Result.idx1])
					second_mismatch: shift = 2 implies (Result.idx2 > a.count or else pat [Result.idx2] /= a [Result.idx2 - 1])
				until
					not Result.res or i > pat.count
				loop
					if i > a.count then
						shift := shift + 1
						if shift = 1 then
							Result := [Result.res, i, 0]
						else
							Result := [False, Result.idx1, i]
						end
					else
						if pat [i] /= a [i - shift] then
							shift := shift + 1
							if shift = 1 then
								Result := [Result.res, i, 0]
							else
								Result := [False, Result.idx1, i]
							end
						end
					end
					i := i + 1
				variant
					pat.count - i
				end
			end
		ensure
			strict_prefix: Result.res and Result.idx1 = 0 implies across 1 |..| pat.count as k all pat [k] = a [k] end
			relaxed_prefix: Result.res and 1 <= Result.idx1 implies
					Result.idx1 <= pat.count and then
					across 1 |..| (Result.idx1 - 1) as k all pat [k] = a [k] end and then
					across (Result.idx1 + 1) |..| pat.count as k all pat [k] = a [k - 1] end
			not_a_prefix: not Result.res implies
					1 <= Result.idx1 and Result.idx1 < Result.idx2 and Result.idx2 <= pat.count and -- both `idx1' and `idx2' are within `pat'
					((Result.idx1 > a.count) or else -- either `a' is two too short
					(pat [Result.idx1] /= a [Result.idx1] and Result.idx2 > a.count) or else -- or there was a mismatch and one too short
					(pat [Result.idx1] /= a [Result.idx1] and pat [Result.idx2] /= a [Result.idx2 - 1])) -- or there were two mismatches
		end

end
