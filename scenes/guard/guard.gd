class_name Guard extends CharacterBody3D

## How fast the player accellerates in meters per second
const MOVEMENT_ACCELLERATION:float = 10
## How fast the player stops or changes direction in meters per second
const MOVEMENT_DECELLERATION:float = 30
## Top speed in meters per second
const TOP_SPEED:float = 3
## how fast the player turns around in... radians per second?
const ROTATION_SPEED:float = 10

## Velocity on just the gameplay plane.
var flat_velocity:Vector2:
	get:
		return Tools.flatten(velocity)
	set(new):
		velocity.x = new.x
		velocity.z = new.y

## Current speed of the guard in the gameplay plane.
var speed:float:
	get:
		return flat_velocity.length()

@onready var gravity:Vector3 = get_gravity()
@onready var detection_area:DetectionArea = find_child("DetectionArea")
@onready var navigation_agent:NavigationAgent3D = find_child("NavigationAgent3D")
func _ready() -> void:
	navigation_agent.path_desired_distance = 0.6
	navigation_agent.target_desired_distance = 0.5
	detection_area.spotted.connect(func(body:Node3D) -> void:
		navigation_agent.target_position = body.global_position
		AlertManager.increase_alert()
	)

func _physics_process(delta:float) -> void:
	var input_dir:Vector2 = _get_target_direction()
	if not input_dir.is_zero_approx():
		_handle_movement(input_dir, delta)
	else:
		flat_velocity = flat_velocity.move_toward(Vector2.ZERO, delta * MOVEMENT_DECELLERATION)
	
	# Don't allow the player to speed up infinitely.
	if speed > TOP_SPEED:
		flat_velocity = flat_velocity.normalized() * TOP_SPEED
		
	move_and_slide()

func _get_target_direction() -> Vector2:
	if navigation_agent.is_navigation_finished():
		return Vector2.ZERO
	
	var current_agent_position: Vector3 = global_position
	var next_path_position: Vector3 = navigation_agent.get_next_path_position()
	#print("Smoving? %s %s" % [current_agent_position, next_path_position])
	return Tools.flatten(current_agent_position.direction_to(next_path_position)) * Vector2(1,-1)

func _handle_movement(input:Vector2, delta:float) -> void:
	var angle = input.angle() + PI/2
	var flat_basis:Vector2 = Vector2(basis.z.x, basis.z.z)
	var dot:float = input.dot(flat_basis * Vector2(1,-1))
	rotation.y = rotate_toward(rotation.y, angle, ROTATION_SPEED * delta * max(.4, 1.0-dot))
	velocity += basis.z * input.length() * MOVEMENT_ACCELLERATION * delta * dot
	flat_velocity = flat_velocity.move_toward(flat_basis * speed, delta * MOVEMENT_DECELLERATION)
