class_name ThrownTranslocator extends RigidBody3D
signal landed(g_position:Vector3)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sleeping_state_changed.connect(func() -> void:
		if sleeping:
			print(global_position.y)
			if global_position.y < .1:
				global_position.y = 0
				landed.emit(global_position)
			queue_free()
	)

func _process(_delta: float) -> void:
	if get_contact_count() > 0:
		if global_position.y < .1:
			global_position.y = 0
			landed.emit(global_position)
			queue_free()
