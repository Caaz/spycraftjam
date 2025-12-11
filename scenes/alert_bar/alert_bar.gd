extends Control

@onready var bar:TextureRect = find_child('Bar')
@onready var eye:TextureRect = find_child('Bar')
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var bar_material:ShaderMaterial = bar.material.duplicate()
	bar.material = bar_material
	Game.alert_changed.connect(func(value:float):
		bar_material.set_shader_parameter('fill', value)
	)
