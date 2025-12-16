extends Control

@onready var start:Button = find_child("Start")
@onready var settings:Button = find_child("Settings")
@onready var credits:Button = find_child("Credits")
@onready var quit:Button = find_child("Quit")

func _ready() -> void:
	start.pressed.connect(func():
		SceneManager.set_scene(SceneManager.Scene.GAMEPLAY)
	)
