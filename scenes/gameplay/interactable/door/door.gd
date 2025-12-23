@tool class_name Door extends Interactable
var tween:Tween

@export var locked:bool = false:
	set(new):
		locked = new
		_update_text()
@onready var animation_tree:AnimationTree = find_child("AnimationTree")
@export var material:Material
var opened:bool = false:
	set(new):
		opened = new
		_update_text()

@onready var body:StaticBody3D = find_child("StaticBody3D")
@onready var obstacle:NavigationObstacle3D = find_child("NavigationObstacle3D")
func _ready() -> void:
	if material:
		var door_mesh:MeshInstance3D = find_child("Doors") as MeshInstance3D
		door_mesh.set_surface_override_material(0, material)
	opened = false
	animation_tree.set("parameters/position/TimeScale/scale", 0)
	animation_tree.set("parameters/position/TimeSeek/seek_request", 0)

func _update_text() -> void:
	var interact_text:String = "%s\n[f]" % ["Close" if opened else "Open"]
	if locked:
		$Label3D.text = "[LOCKED]\n%s" % interact_text 
	else:
		$Label3D.text = interact_text 
func interact() -> void:
	if tween and tween.is_running():
		return
	if opened:
		close()
	else:
		open()

func open() -> Tween:
	tween = create_tween()
	if locked:
		return tween
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
	if locked:
		return tween
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_method(_set_door_position, 1., 0., 1.)
	tween.tween_callback(func() -> void: opened = false )
	body.collision_layer = 0b10
	obstacle.avoidance_enabled = true
	LevelManager.rebake_navigation()
	return tween

func lock_closed() -> Tween:
	locked = false
	if opened:
		close()
	locked = true
	return tween
	
func lock_opened() -> Tween:
	locked = false
	if not opened:
		open()
	locked = true
	return tween

func _set_door_position(value:float) -> void:
	animation_tree.set("parameters/position/TimeSeek/seek_request", value)

func hack_options() -> Array[StringName]:
	return [&"open", &"close", &"lock_closed", &"lock_opened"]

func _hover() -> void:
	$Label3D.show()

func _off_hover() -> void:
	$Label3D.hide()
