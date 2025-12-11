class_name HackingTile extends CenterContainer

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
	if value > 0:
		label.text = "%d" % value
		label.show()
	else:
		label.hide()
	
	if texture:
		texture_rect.texture = texture
		texture_rect.show()
	else:
		texture_rect.hide()
