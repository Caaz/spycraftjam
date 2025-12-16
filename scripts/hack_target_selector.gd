class_name HackTargetSelector extends Node3D
signal done(selection:Node3D)


var selected_target:Node3D:
	set(new):
		selected_target = new
		_selection_updated()

var options:Array[Node3D]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not selected_target:
		selected_target = options[0]
	
	if Input.is_action_just_pressed("interact"):
		done.emit(selected_target)

func _selection_updated() -> void:
	pass
