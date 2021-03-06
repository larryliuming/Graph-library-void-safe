note
	description: "EG_CLUSTER can be connectet to other EG_LINKABLEs and contains any number of EG_LINKABLEs"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date: 2008-12-30 04:27:11 +0800 (Tue, 30 Dec 2008) $"
	revision: "$Revision: 76420 $"

class
	EG_CLUSTER

inherit
	EG_LINKABLE
		redefine
			default_create
		end

feature {NONE} -- Initialization

	default_create
			-- Create an empty cluster.
		do
			Precursor {EG_LINKABLE}
			create linkables.make (0)

			create linkable_add_actions
			linkable_add_actions.compare_objects
			create linkable_remove_actions
			linkable_remove_actions.compare_objects
		end

feature -- Access

	flat_linkables: like linkables
			-- Return all linkables containing in `Current'
			-- including all linkables containing in sub clusters.
		local
			l_cluster: detachable like Current
		do
			Result := linkables.twin
			from
				linkables.start
			until
				linkables.after
			loop
				l_cluster ?= linkables.item
				if l_cluster /= Void then
					Result.append (l_cluster.flat_linkables)
				end
				linkables.forth
			end
		ensure
			result_not_void: Result /= Void
		end

	sub_clusters: ARRAYED_LIST [like Current]
			-- Sub clusters (top level) of Current.
		local
			l_cluster: detachable like Current
		do
			create Result.make (10)
			from
				linkables.start
			until
				linkables.after
			loop
				l_cluster ?= linkables.item
				if l_cluster /= Void then
					Result.extend (l_cluster)
				end
				linkables.forth
			end
		ensure
			result_not_void: Result /= Void
		end

	sub_nodes: ARRAYED_LIST [like node_type]
			-- Nodes (top level) of Current.
		local
			l_node: detachable like node_type
		do
			create Result.make (10)
			from
				linkables.start
			until
				linkables.after
			loop
				l_node ?= linkables.item
				if l_node /= Void then
					Result.extend (l_node)
				end
				linkables.forth
			end
		ensure
			result_not_void: Result /= Void
		end

	sub_nodes_recursive: ARRAYED_LIST [like node_type]
			-- All nodes in current.
		local
			l_sub_clusters: like sub_clusters
		do
			Result := sub_nodes
			l_sub_clusters := sub_clusters
			from
				l_sub_clusters.start
			until
				l_sub_clusters.after
			loop
				Result.merge_right (l_sub_clusters.item.sub_nodes_recursive)
				l_sub_clusters.forth
			end
		ensure
			result_not_void: Result /= Void
		end

	linkable_add_actions: EG_LINKABLE_ACTION
			-- a linkable was added to `Current'.

	linkable_remove_actions: EG_LINKABLE_ACTION
			-- a linkable was removed from `Current'.

feature -- Status report

	has (a_linkable: EG_LINKABLE): BOOLEAN
			-- Is `a_linkable' part of the cluster (without subclusters)?
		require
			a_linkable_not_void: a_linkable /= Void
		do
			Result := linkables.has (a_linkable)
		end

feature -- Element change

	extend (a_linkable: EG_LINKABLE)
			-- add `a_linkable' to `Current'.
		require
			a_linkable_not_void: a_linkable /= Void
			not_has_a_linkable: not has (a_linkable)
		local
			a_cluster: detachable EG_CLUSTER
			a_node: detachable like node_type
		do
			if attached a_linkable.cluster as l_cluster then
				l_cluster.prune_all (a_linkable)
			end
			linkables.extend (a_linkable)
			a_linkable.set_cluster (Current)

			if attached graph as l_graph and then not l_graph.has_linkable (a_linkable) then
				a_cluster ?= a_linkable
				if a_cluster /= Void then
					l_graph.add_cluster (a_cluster)
				else
					a_node ?= a_linkable
					if a_node /= Void then
						l_graph.add_node (a_node)
					end
				end
			end
			linkable_add_actions.call ([a_linkable])
		ensure
			has_a_linkable: has (a_linkable)
			a_linkable_cluster_equal_current: a_linkable.cluster = Current
		end

	prune_all (a_linkable: EG_LINKABLE)
			-- remove all occurrences of `a_linkable' from `Current'.
		require
			a_linkable_not_void: a_linkable /= Void
			has_a_linkable: has (a_linkable)
		do
			linkables.prune_all (a_linkable)
			a_linkable.remove_cluster
			linkable_remove_actions.call ([a_linkable])
		ensure
			not_has_a_linkable: not has (a_linkable)
			a_linkable_cluster_equal_void: a_linkable.cluster = Void
		end

feature {EG_GRAPH, EG_FIGURE_WORLD, EG_FIGURE_FACTORY} -- Implementation

	linkables: ARRAYED_LIST [EG_LINKABLE];
			-- linkable elements of `Current'.

feature {NONE} -- Node type

	node_type: EG_NODE
			-- Anchor type
		local
			l_result: detachable like node_type
		do
			check anchor_type_only: False end
			check l_result /= Void end -- Satisfy void-safe compiler
			Result := l_result
		end

;note
	copyright:	"Copyright (c) 1984-2006, Eiffel Software and others"
	license:	"Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			 Eiffel Software
			 356 Storke Road, Goleta, CA 93117 USA
			 Telephone 805-685-1006, Fax 805-685-6869
			 Website http://www.eiffel.com
			 Customer support http://support.eiffel.com
		]"




end -- class EG_CLUSTER

