note
	description: "Objects that ..."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date: 2008-12-30 04:27:11 +0800 (Tue, 30 Dec 2008) $"
	revision: "$Revision: 76420 $"

class
	EG_PROJECTOR

inherit
	EV_MODEL_BUFFER_PROJECTOR
		redefine
			world,
			full_project,
			project
		end
	
create
	make_with_buffer
	
feature -- Access

	world: EG_FIGURE_WORLD

feature -- Display updates

	full_project
			-- Project entire area.
		do
			world.update
			Precursor {EV_MODEL_BUFFER_PROJECTOR}
		end
		
	project
			-- Make a standard projection of world on device.
		do
			world.update
			Precursor {EV_MODEL_BUFFER_PROJECTOR}
		end

note
	copyright:	"Copyright (c) 1984-2006, Eiffel Software and others"
	license:	"Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			 Eiffel Software
			 356 Storke Road, Goleta, CA 93117 USA
			 Telephone 805-685-1006, Fax 805-685-6869
			 Website http://www.eiffel.com
			 Customer support http://support.eiffel.com
		]"




end -- class EG_PROJECTOR

