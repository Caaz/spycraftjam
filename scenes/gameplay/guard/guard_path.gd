class_name GuardPath extends Path3D

const NEW_UPDATE_RANGE:float = .5
const JUMP_DISTANCE:float = .1
@onready var _last_position:PathFollow3D = find_child("PathFollow3D")

## From a global position, returns a global position the follower should navigate to.
func get_target(from:Vector3) -> Vector3:
	var distance:float = from.distance_to(_last_position.global_position)
	if distance < NEW_UPDATE_RANGE:
		_last_position.progress += JUMP_DISTANCE
	return _last_position.global_position
