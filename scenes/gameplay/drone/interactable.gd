extends Interactable

func interact() -> void:
	var drone:Drone = get_parent() as Drone
	drone.reset()

func _hover() -> void:
	$Label3D.show()
func _off_hover() -> void:
	$Label3D.hide()
