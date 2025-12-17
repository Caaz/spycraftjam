class_name Teleporter extends Interactable
signal interacted()

func interact() -> void:
	interacted.emit()
