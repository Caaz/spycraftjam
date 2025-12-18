class_name Level extends Node3D
signal completed()
@onready var player:Player = find_child("Player") as Player
@onready var teleporter:Teleporter = find_child("Teleporter") as Teleporter
@export var next_level:PackedScene
@export var intro_conversation:Conversation
func _ready() -> void:
	if intro_conversation:
		ChatManager.start_chat(intro_conversation)
	if teleporter:
		teleporter.interacted.connect(func() -> void:
			completed.emit()
		)
