extends Node

enum Scene {
	MAIN_MENU,
	GAMEPLAY,
	CREDITS,
	GAME_OVER,
	GAME_WIN,
}
const scenes:Dictionary[Scene, PackedScene] = {
	Scene.MAIN_MENU: preload("uid://dedxorxw312bn"),
	Scene.GAMEPLAY: preload("uid://bpyi01p72v6e3"),
	Scene.GAME_OVER: preload("uid://c82dxuanc0lh4"),
	Scene.GAME_WIN: preload("uid://bsyj7dj4eswfr"),
}

var main:Main:
	get: return get_tree().get_first_node_in_group("main") as Main


func set_scene(scene:Scene) -> Node:
	var node:Node = scenes[scene].instantiate()
	main.set_scene(node)
	return node

func _ready() -> void:
	pass
	# If you ever need to debug input nonsense, uncomment this.
	#get_tree().node_added.connect(func(node:Node) -> void:
		#var control:Control = node as Control
		#if not control:
			#return
		#control.gui_input.connect(func(event:InputEvent) -> void:
			#print("%s received %s" % [control, event])
		#)
	#)
