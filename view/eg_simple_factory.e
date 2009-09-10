note
	description: "Factory for the simple figures."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date: 2008-12-30 04:27:11 +0800 (Tue, 30 Dec 2008) $"
	revision: "$Revision: 76420 $"

class
	EG_SIMPLE_FACTORY

inherit
	EG_FIGURE_FACTORY
	
feature -- Basic operations

	new_node_figure (a_node: EG_NODE): EG_LINKABLE_FIGURE
			-- Create a node figure for `a_node'.
		do
			Result := create {EG_SIMPLE_NODE}.make_with_model (a_node)
		end
		
	new_cluster_figure (a_cluster: EG_CLUSTER): EG_CLUSTER_FIGURE
			-- Create a cluster figure for `a_cluster'.
		do
			Result := create {EG_SIMPLE_CLUSTER}.make_with_model (a_cluster)
		end
		
	new_link_figure (a_link: EG_LINK): EG_LINK_FIGURE
			-- Create a link figure for `a_link'.
		do
			Result := create {EG_SIMPLE_LINK}.make_with_model (a_link)
		end
		
	model_from_xml (node: XM_ELEMENT): EG_ITEM
			-- Create an EG_ITEM from `node' if possible.
		local
			node_name, source_name, target_name: STRING
			a_source, a_target: EG_LINKABLE
		do
			node_name := node.name
			if node_name.is_equal ("EG_SIMPLE_NODE") then
				create {EG_NODE} Result
			elseif node_name.is_equal ("EG_SIMPLE_CLUSTER") then
				create {EG_CLUSTER} Result
			elseif node_name.is_equal ("EG_SIMPLE_LINK") then
				source_name := node.attribute_by_name ("SOURCE").value
				target_name := node.attribute_by_name ("TARGET").value
				
				if source_name /= Void and then target_name /= Void and then world /= Void then
					a_source := linkable_with_name (source_name)
					if a_source /= Void then
						a_target := linkable_with_name (target_name)
						if a_target /= Void then
							create {EG_LINK} Result.make_with_source_and_target (a_source, a_target)
						end
					end
				end
			end
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




end -- class EG_SIMPLE_FACTORY
