class_name Door extends Area3D

@export var locked:bool = false
@export var hackable:bool = false

@onready var animation_tree:AnimationTree = find_child("AnimationTree")
@onready var opened:bool = false

func _ready() -> void:
	animation_tree.set("parameters/position/TimeScale/scale", 0)
	animation_tree.set("parameters/position/TimeSeek/seek_request", 0)
	
func interact() -> void:
	if opened:
		close()
	else:
		open()

func open() -> Tween:
	var tween:Tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CIRC)
	tween.tween_method(_set_door_position, 0., 1., 1.)
	tween.tween_callback(func() -> void: opened = true )
	return tween
	
func close() -> Tween:
	var tween:Tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CIRC)
	tween.tween_method(_set_door_position, 1., 0., 1.)
	tween.tween_callback(func() -> void: opened = false )
	return tween

func _set_door_position(value:float) -> void:
	animation_tree.set("parameters/position/TimeSeek/seek_request", value)
