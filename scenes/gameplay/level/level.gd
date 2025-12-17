class_name Level extends Node3D
signal completed()
@onready var player:Player = find_child("Player") as Player
@onready var teleporter:Teleporter = find_child("Teleporter") as Teleporter

func _ready() -> void:
	if teleporter:
		teleporter.interacted.connect(func() -> void:
			completed.emit()
		)
