extends Node
@export var level_scene:PackedScene

func _ready() -> void:
	LevelManager.load_level_by_scene(level_scene)
