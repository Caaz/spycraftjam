@tool class_name Door extends Interactable
var tween:Tween

@export var locked:bool = false
@export var hackable:bool = false

@onready var animation_tree:AnimationTree = find_child("AnimationTree")
@onready var opened:bool = false
@onready var body:StaticBody3D = find_child("StaticBody3D")
@onready var obstacle:NavigationObstacle3D = find_child("NavigationObstacle3D")
func _ready() -> void:
	animation_tree.set("parameters/position/TimeScale/scale", 0)
	animation_tree.set("parameters/position/TimeSeek/seek_request", 0)

func interact() -> void:
	if tween and tween.is_running():
		return
	
	if opened:
		close()
	else:
		open()

func open() -> Tween:
	tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_method(_set_door_position, 0., 1., 1.)
	tween.tween_callback(func() -> void: opened = true )
	body.collision_layer = 0
	obstacle.avoidance_enabled = false
	LevelManager.rebake_navigation()
	return tween
	
func close() -> Tween:
	tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_method(_set_door_position, 1., 0., 1.)
	tween.tween_callback(func() -> void: opened = false )
	body.collision_layer = 0b10
	obstacle.avoidance_enabled = true
	LevelManager.rebake_navigation()
	return tween

func _set_door_position(value:float) -> void:
	animation_tree.set("parameters/position/TimeSeek/seek_request", value)

func hack_options() -> Array[StringName]:
	return [&"open", &"close"]
