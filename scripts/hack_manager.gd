extends Node

const HACK_SCENE:PackedScene = preload("uid://4514u05j1ne2")

var hack_layer:CanvasLayer:
	get:
		return get_tree().get_first_node_in_group("hack_layer") as CanvasLayer

func initiate_hack(from:Node3D) -> void:
	# TODO: Get hackable targets from the initial hacker.
	var screen_position:Vector2 = CameraManager.camera.unproject_position(from.global_position)
	var hacking_ui:HackingUI = HACK_SCENE.instantiate()
	hack_layer.add_child(hacking_ui)
	hacking_ui.position = screen_position
	GameManager.state = GameManager.State.PAUSED
	
	var hacked:bool = await hacking_ui.closed
	
	await hacking_ui._close().finished
	GameManager.state = GameManager.State.DEFAULT
	hacking_ui.queue_free()
