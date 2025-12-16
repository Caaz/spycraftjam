class_name HackOptions extends PanelContainer

signal selected(option:StringName)

var options:Array[StringName]

@onready var button_container:VBoxContainer = find_child("VBoxContainer")

func _ready():
	var button:Button
	
	for option:StringName in options:
		button = Button.new()
		button.text = option
		button_container.add_child(button)
		button.pressed.connect(func():
			selected.emit(option)
			queue_free()
		)
	
	button = Button.new()
	button.text = "Cancel"
	button_container.add_child(button)
	button.pressed.connect(func():
		selected.emit("")
		queue_free()
	)
