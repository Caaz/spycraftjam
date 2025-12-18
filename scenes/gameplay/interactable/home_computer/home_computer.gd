extends Interactable

@export var conversation:Conversation
func interact() -> void:
	ChatManager.start_chat(conversation)
	collision_layer = 0b0

func _hover() -> void:
	$Label3D.show()

func _off_hover() -> void:
	$Label3D.hide()
