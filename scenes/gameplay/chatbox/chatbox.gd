@tool class_name Chatbox extends Control
signal dismissed()

const CHARACTERS_PER_SECOND:float = 40

@export var chat_message:ChatMessage

@onready var name_label:Label = find_child("Name")
@onready var content_label:Label = find_child("Content")
@onready var character_texture:TextureRect = find_child("Character")

@warning_ignore("unused_private_class_variable")
@export_tool_button("Preview") var _preview:Callable = _update_display

var tween:Tween

func _ready() -> void:
	_update_display()

func _update_display() -> void:
	if not chat_message:
		return
	name_label.text = chat_message.name
	content_label.text = chat_message.content
	if chat_message.texture:
		character_texture.show()
		character_texture.texture = chat_message.texture
	else:
		character_texture.hide()
	_tween_text()

func _tween_text() -> Tween:
	if not chat_message:
		return
	tween = create_tween()
	var character_count:int = chat_message.content.length()
	content_label.visible_characters = 0
	tween.tween_property(content_label, 'visible_characters', character_count, float(character_count)/CHARACTERS_PER_SECOND)
	return tween

func skip_tween() -> void:
	if tween and tween.is_running():
		tween.stop()
	content_label.visible_ratio = 1

func _process(_delta:float) -> void:
	if Engine.is_editor_hint():
		return
	if Input.is_action_just_pressed("interact"):
		if tween and tween.is_running():
			skip_tween()
		else:
			dismissed.emit()
			queue_free()
