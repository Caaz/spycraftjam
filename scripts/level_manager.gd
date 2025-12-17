## Handles loading levels, and managing their navigation meshes.
extends Node
enum LevelKey {
	HOME,
	FINAL,
}
const levels:Dictionary[LevelKey, PackedScene] = {
	LevelKey.HOME: preload("uid://ctcr8qha71wmq"),
	LevelKey.FINAL: preload("uid://ti62h0kpf680"),
}
var _navigation_region:NavigationRegion3D:
	get: return get_tree().get_first_node_in_group("navigation_region") as NavigationRegion3D

var level_container:Node:
	get: return _navigation_region

func rebake_navigation() -> void:
	var navigation_region:NavigationRegion3D = _navigation_region
	if navigation_region.is_baking():
		return
	navigation_region.bake_navigation_mesh()
	
func load_level(key:LevelKey) -> void:
	load_level_by_scene(levels[key])

func load_level_by_scene(packed_scene:PackedScene) -> void:
	var level:Level = packed_scene.instantiate() as Level
	for child in level_container.get_children():
		child.queue_free()
	# TODO: Fade to black here
	level.process_mode = PROCESS_MODE_DISABLED
	level_container.add_child(level)
	# TODO: Fade off of black
	level.process_mode = PROCESS_MODE_INHERIT
	CameraManager.set_target(level.player, true)
	
	await create_tween().tween_interval(.5).finished
	rebake_navigation()
