extends Node
var phantom_camera:PhantomCamera3D:
	get:
		return get_tree().get_first_node_in_group("phantom_camera") as PhantomCamera3D

var camera:Camera3D:
	get:
		return get_tree().get_first_node_in_group("camera")

func set_target(target:Node3D, teleport:bool=false) -> void:
	phantom_camera.follow_target = target
	if teleport:
		phantom_camera.teleport_position()
