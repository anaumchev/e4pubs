class FORMATTER_APPLICATION

feature -- Basic operations

	apply_align_left (a_formatter: FORMATTER; a_paragraph: PARAGRAPH)
			-- Use `a_formatter' to left-align `a_paragraph'.
		note
			explicit: wrapping
		require
			a_formatter /= Void
			a_paragraph /= Void
			not a_paragraph.is_left_aligned

			modify (a_paragraph)
		local
			l_agent: PROCEDURE [FORMATTER, TUPLE [PARAGRAPH]]
		do
			l_agent := agent a_formatter.align_left
			a_paragraph.format (l_agent)
		ensure
			a_paragraph.is_left_aligned
		end

	apply_align_right (a_formatter: FORMATTER; a_paragraph: PARAGRAPH)
			-- Use `a_formatter' to right-align `a_paragraph'.
		note
			explicit: wrapping
		require
			a_formatter /= Void
			a_paragraph /= Void
			a_paragraph.is_left_aligned

			modify (a_paragraph)
		local
			l_agent: PROCEDURE [FORMATTER, TUPLE [PARAGRAPH]]
		do
			l_agent := agent a_formatter.align_right
			a_paragraph.format (l_agent)
		ensure
			not a_paragraph.is_left_aligned
		end

end
