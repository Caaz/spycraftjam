class_name DetectionArea extends Area3D

signal spotted(body:Node3D)

const textures:Array[Texture2D] = [
	preload("uid://c4cs7faca3gaq"),
	preload("uid://b285ufkqb2exp"),
	preload("uid://cxn487tgnbn5a"),
]

const ALERT_RATE = 1
const ALERT_DECAY = 0.1
const DECAY_COOLDOWN_TIME:float = 2


@onready var parent:Node3D = get_parent()
@onready var awareness_icon:Sprite3D = find_child("AwarenessIcon")
@onready var raycast:RayCast3D = find_child("RayCast3D")
var decay_cooldown:float = 0
var arc:float = .25
var target:Node3D
var alert_level:float = 0
var awareness_material:ShaderMaterial

func _ready() -> void:
	body_entered.connect(func(body:Node3D) -> void: target = body)
	body_exited.connect(func(_body:Node3D) -> void: target = null)
	awareness_material = awareness_icon.material_override.duplicate()
	awareness_icon.material_override = awareness_material

func _process(delta: float) -> void:
	# TODO: Do a sight check here.
	if target and _target_is_within_arc() and _can_see_target():
		alert_level = min(1, alert_level + delta * ALERT_RATE) 
		if is_equal_approx(alert_level, 1.):
			spotted.emit(target)
	else:
		if is_zero_approx(decay_cooldown):
			alert_level = max(0, alert_level - delta * ALERT_DECAY)
		else:
			decay_cooldown -= delta

	awareness_material.set_shader_parameter("fill", alert_level)
	var texture:Texture2D = textures[0]
	var fill_color:Color = Color("#ffef0b")
	if alert_level > .9:
		texture = textures[2]
		fill_color = Color("#f21f1f")
	elif alert_level > .1:
		texture = textures[1]
		fill_color = Color("#ffef0b")
	awareness_material.set_shader_parameter("bar_texture", texture)
	awareness_material.set_shader_parameter("fill_color", fill_color)

func _target_is_within_arc() -> bool:
	var my_position:Vector2 = Tools.flatten(global_position)
	var their_position:Vector2 = Tools.flatten(target.global_position)
	
	var direction:Vector2 = my_position.direction_to(their_position)
	var facing_direction:Vector2 = Tools.flatten(parent.basis.z)
	
	var dot:float = (direction.dot(facing_direction) + 1) / 2 
	return dot > 1.0-arc

func _can_see_target() -> bool:
	raycast.target_position = to_local(target.global_position)
	if raycast.is_colliding():
		return raycast.get_collider() is Player
	return false
