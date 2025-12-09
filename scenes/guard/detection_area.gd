class_name DetectionArea extends Area3D
signal spotted(body:Node3D)
var arc:float = .25

var target:Node3D
var meter:float = 0
var detection_rate:float = .5
var has_spotted:bool = false
@onready var parent:Node3D = get_parent()

func _ready() -> void:
	body_entered.connect(func(body:Node3D) -> void: target = body)
	body_exited.connect(func(_body:Node3D) -> void: target = null)

func _process(delta: float) -> void:
	if target and _target_is_within_arc():
		meter += delta * detection_rate
		if not has_spotted and meter > 1:
			spotted.emit(target)
			#has_spotted = true
	else:
		meter -= delta * detection_rate
		meter = max(meter, 0)
		if meter < .5:
			has_spotted = false
			
func _target_is_within_arc() -> bool:
	var my_position:Vector2 = Tools.flatten(global_position)
	var their_position:Vector2 = Tools.flatten(target.global_position)
	
	var direction:Vector2 = my_position.direction_to(their_position)
	var facing_direction:Vector2 = Tools.flatten(parent.basis.z)
	
	var dot:float = (direction.dot(facing_direction) + 1) / 2 
	return dot > 1.0-arc
