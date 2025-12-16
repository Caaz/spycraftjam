class_name ThrowCast extends ShapeCast3D

@onready var floor_cast:ShapeCast3D = get_child(0)

func _process(_delta: float) -> void:
	if get_collision_count() == 0:
		return
	var point:Vector3 = get_collision_point(0)
	floor_cast.global_position = point
