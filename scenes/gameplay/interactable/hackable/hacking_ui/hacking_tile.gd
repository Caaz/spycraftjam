class_name HackingTile extends PanelContainer

@onready var label:Label = find_child("Label")
@onready var texture_rect:TextureRect = find_child("TextureRect")

var value:int:
	set(new):
		value = new
		_update_display()

var texture:Texture2D:
	set(new):
		texture = new
		_update_display()

func _ready() -> void:
	_update_display()

func _update_display() -> void:
	if not is_node_ready():
		return
	label.text = "%d" % value
