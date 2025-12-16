extends Node

const HACK_SCENE:PackedScene = preload("uid://4514u05j1ne2")
const TARGET_SCENE:PackedScene = preload("uid://bt8f4hpfefm4n")
const OPTION_SELECT_SCENE:PackedScene = preload("uid://d3fhfnmocvxqs")
var hack_layer:CanvasLayer:
	get:
		return get_tree().get_first_node_in_group("hack_layer") as CanvasLayer

func initiate_hack(from:Node3D) -> bool:
	# TODO: Get hackable targets from the initial hacker.
	var screen_position:Vector2 = CameraManager.camera.unproject_position(from.global_position)
	var hacking_ui:HackingUI = HACK_SCENE.instantiate()
	hack_layer.add_child(hacking_ui)
	hacking_ui.position = screen_position
	
	var hacked:bool = await hacking_ui.closed
	
	await hacking_ui._close().finished
	GameManager.state = GameManager.State.DEFAULT
	hacking_ui.queue_free()
	return hacked

func get_target(from_options:Array) -> Interactable:
	GameManager.state = GameManager.State.PAUSED
	var target_selector:TargetSelector = TARGET_SCENE.instantiate()
	target_selector.options = from_options
	hack_layer.add_child(target_selector)
	return await target_selector.done as Interactable

func get_target_action(from_target:Interactable) -> StringName:
	var option_select:HackOptions = OPTION_SELECT_SCENE.instantiate()
	option_select.options = from_target.hack_options()
	var screen_position:Vector2 = CameraManager.camera.unproject_position(from_target.global_position)
	hack_layer.add_child(option_select)
	option_select.position = screen_position
	return await option_select.selected
