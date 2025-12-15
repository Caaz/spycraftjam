## Handles loading levels, and managing their navigation meshes.
extends Node

var _navigation_region:NavigationRegion3D:
	get:
		return get_tree().get_first_node_in_group("navigation_region") as NavigationRegion3D
		
func rebake_navigation() -> void:
	var navigation_region:NavigationRegion3D = _navigation_region
	if navigation_region.is_baking():
		return
	navigation_region.bake_navigation_mesh()
	
