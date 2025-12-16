extends Node

enum Scene {
	MAIN_MENU,
	GAMEPLAY,
	CREDITS,
}
const scenes:Dictionary[Scene, PackedScene] = {
	Scene.MAIN_MENU: preload("uid://dedxorxw312bn"),
	Scene.GAMEPLAY: preload("uid://bpyi01p72v6e3")
}

var main:Main:
	get: return get_tree().get_first_node_in_group("main") as Main


func set_scene(scene:Scene) -> Node:
	var node:Node = scenes[scene].instantiate()
	main.set_scene(node)
	return node
