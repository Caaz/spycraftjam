class_name TargetSelector extends Node3D
signal done(selection:Node3D)

const TWEEN_DURATION:float = .3

var options:Array
var _tween:Tween
@onready var mesh:MeshInstance3D = find_child("MeshInstance3D")

var selected_index:int = 0:
	set(new):
		var options_size:int = options.size()
		selected_index = clamp(0, new, options.size())
		if selected_index == options_size:
			selected_index = 0
		_selection_updated()

var _selected_target:Node3D:
	get:
		return options[selected_index] if options else null

func _ready() -> void:
	_selection_updated()
	_tween = create_tween()
	_tween.tween_interval(.1)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if _tween and _tween.is_running():
		return
	if Input.is_action_just_pressed("interact"):
		done.emit(_selected_target)
		queue_free()
	if Input.is_action_just_pressed("move_west"):
		selected_index -= 1
	elif Input.is_action_just_pressed("move_east"):
		selected_index += 1
	

func _selection_updated() -> void:
	if not (is_node_ready() and _selected_target):
		return
		
	if _tween and _tween.is_running():
		_tween.stop()
	
	_tween = create_tween()
	
	_tween.set_trans(Tween.TRANS_SINE)
	_tween.set_ease(Tween.EASE_IN_OUT)
	
	_tween.tween_property(mesh,"global_position", _selected_target.global_position, TWEEN_DURATION)
