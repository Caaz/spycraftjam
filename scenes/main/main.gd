class_name Main extends Node
@onready var _scene_container:Node = find_child("SceneContainer")

func _ready() -> void:
	SceneManager.set_scene(SceneManager.Scene.MAIN_MENU)
	
func set_scene(node:Node) -> void:
	for child:Node in _scene_container.get_children():
		child.queue_free()
	
	_scene_container.add_child(node)
